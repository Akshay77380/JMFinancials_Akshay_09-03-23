import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class MarketStatus extends StatefulWidget {
  var _currentIndex = 0;

  @override
  State<MarketStatus> createState() => _MarketStatusState();
}

class _MarketStatusState extends State<MarketStatus> {
  
  var marketStatus;

  @override
  Future<void> initState() {
    super.initState();
    getEvent();
  }

  getEvent() async {

    CommonFunction.firebaseEvent(
      clientCode: "dummy",
      device_manufacturer: Dataconstants.deviceName,
      device_model: Dataconstants.devicemodel,
      eventId: "6.0.3.0.0",
      eventLocation: "header",
      eventMetaData: "dummy",
      eventName: "market_status",
      os_version: Dataconstants.osName,
      location: "dummy",
      eventType:"Click",
      sessionId: "dummy",
      platform: Platform.isAndroid ? 'Android' : 'iOS',
      screenName: "guest user dashboard",
      serverTimeStamp: DateTime.now().toString(),
      source_metadata: "dummy",
      subType: "icon",
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  marketStatus = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: marketStatus == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: marketStatus == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: marketStatus == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: marketStatus == 1
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("NSE",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: marketStatus == 1
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  marketStatus = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: marketStatus == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: marketStatus == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: marketStatus == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: marketStatus == 2
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("BSE",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: marketStatus == 2
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  marketStatus = 3;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      top: marketStatus == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      bottom: marketStatus == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide(color: Utils.greyColor),
                      right: marketStatus == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                      left: marketStatus == 3
                          ? BorderSide(color: Utils.primaryColor)
                          : BorderSide.none,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("MCX",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: marketStatus == 3
                              ? Utils.primaryColor
                              : Utils.greyColor)),
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: 20,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("NSE",
                style: Utils.fonts(
                    fontWeight: FontWeight.w700,
                    size: 14.0,
                    color: Utils.greyColor)),
            Container(
              width: MediaQuery.of(context).size.width * 0.23,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Status",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w700,
                          size: 14.0,
                          color: Utils.greyColor)),
                ],
              ),
            )
          ],
        ),

        SizedBox(height: 15,),

        Divider(
          thickness: 2,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Spot Market",
                  style: Utils.fonts(
                      fontWeight: FontWeight.w700,
                      size: 14.0,
                      color: Utils.greyColor)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.23,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/appImages/markets/yellow_dot.svg",
                      color: Colors.orange,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Preopen",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size: 14.0,
                              color: Utils.greyColor)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Divider(
          thickness: 1,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("OddLot Market",
                  style: Utils.fonts(
                      fontWeight: FontWeight.w700,
                      size: 14.0,
                      color: Utils.greyColor)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.23,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/appImages/markets/yellow_dot.svg",
                      color: Utils.brightRedColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Closed",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size: 14.0,
                              color: Utils.greyColor)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Call Auction 2 Market",
                  style: Utils.fonts(
                      fontWeight: FontWeight.w700,
                      size: 14.0,
                      color: Utils.greyColor)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.23,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/appImages/markets/yellow_dot.svg",
                      color: Utils.lightGreenColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Open",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size: 14.0,
                              color: Utils.greyColor)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Spot Market",
                  style: Utils.fonts(
                      fontWeight: FontWeight.w700,
                      size: 14.0,
                      color: Utils.greyColor)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.23,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/appImages/markets/yellow_dot.svg",
                      color: Colors.orange,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Preopen",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size: 14.0,
                              color: Utils.greyColor)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
