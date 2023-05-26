import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'mobileScreen.dart';

class IntroScreens extends StatefulWidget {
  const IntroScreens({Key key}) : super(key: key);

  @override
  State<IntroScreens> createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  final List<String> imageList = [
    "assets/appImages/introscreen1.svg",
    "assets/appImages/introscreen2.svg",
    "assets/appImages/introscreen3.svg"
  ];

  final List<String> titleList = [
    "One App For All your Finances",
    "Lighting Fast Order Placement",
    "Intelligent Market Scanners"
  ];

  final List<String> descList = [
    "Experience High Speed Trading with Blink Trade",
    "Place your orders in microseconds with advanced technology",
    "Scanners built to identify stocks for trading and investing"
  ];

  var currentIndexPage = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CarouselSlider(
                items: imageList.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: SvgPicture.asset(i));
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    autoPlayAnimationDuration: Duration(seconds: 2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    // enlargeCenterPage: true,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) async {

                      setState(() {
                        currentIndexPage = double.parse(index.toString());
                      });
                      if(index == 0) {
                        // CommonFunction.firebaseEvent(
                        //   clientCode: "dummy",
                        //   device_manufacturer: deviceName,
                        //   device_model: devicemodel,
                        //   eventId: "1.1.0.0.0",
                        //   eventLocation: "body",
                        //   eventMetaData: "dummy",
                        //   eventName: "s_welcome_screen",
                        //   os_version: osName,
                        //   location: "dummy",
                        //   eventType:"impression",
                        //   sessionId: "dummy",
                        //   platform: Platform.isAndroid ? 'Android' : 'iOS',
                        //   screenName: "welcome screen",
                        //   serverTimeStamp: DateTime.now().toString(),
                        //   source_metadata: "dummy",
                        //   subType: "screen",
                        // );
                      }
                      if(index == 1) {
                        CommonFunction.firebaseEvent(
                          clientCode: "dummy",
                          device_manufacturer: Dataconstants.deviceName,
                          device_model: Dataconstants.devicemodel,
                          eventId: "2.0.0.1.0",
                          eventLocation: "body",
                          eventMetaData: "dummy",
                          eventName: "card1_lighting_fast_order_placement",
                          os_version: Dataconstants.osName,
                          location: "dummy",
                          eventType:"swipe",
                          sessionId: "dummy",
                          platform: Platform.isAndroid ? 'Android' : 'iOS',
                          screenName: "discover blink trade",
                          serverTimeStamp: DateTime.now().toString(),
                          source_metadata: "dummy",
                          subType: "swipe",
                        );
                      }
                      if(index == 2) {
                        CommonFunction.firebaseEvent(
                          clientCode: "dummy",
                          device_manufacturer: Dataconstants.deviceName,
                          device_model: Dataconstants.devicemodel,
                          eventId: "2.0.0.8.0",
                          eventLocation: "body",
                          eventMetaData: "dummy",
                          eventName: "card8_intelligent_market_scanner",
                          os_version: Dataconstants.osName,
                          location: "dummy",
                          eventType:"swipe",
                          sessionId: "dummy",
                          platform: Platform.isAndroid ? 'Android' : 'iOS',
                          screenName: "discover blink trade",
                          serverTimeStamp: DateTime.now().toString(),
                          source_metadata: "dummy",
                          subType: "swipe",
                        );
                      }

                    })
                // options: CarouselOptions(
                //     height: 200,
                //     aspectRatio: 16 / 9,
                //     viewportFraction: 1,
                //     initialPage: 0,
                //     enableInfiniteScroll: true,
                //     reverse: false,
                //     autoPlay: true,
                //     autoPlayInterval: Duration(seconds: 4),
                //     autoPlayAnimationDuration: Duration(seconds: 2),
                //     autoPlayCurve: Curves.fastOutSlowIn,
                //     // enlargeCenterPage: true,
                //     // onPageChanged: callbackFunction,
                //     scrollDirection: Axis.horizontal,
                //     onPageChanged: (index, reason) {
                //       setState(() {
                //         currentIndexPage = double.parse(index.toString());
                //       });
                //     })
            ),
            SizedBox(
              height: 70,
            ),
            DotsIndicator(
              dotsCount: 3,
              position: currentIndexPage,
              decorator: DotsDecorator(
                activeSize: const Size(18.0, 9.0),
                shapes: [
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ],
                colors: [Utils.greyColor, Utils.greyColor, Utils.greyColor],
                // Inactive dot colors
                activeColors: [
                  Utils.mediumRedColor,
                  Utils.mediumRedColor,
                  Utils.mediumRedColor
                ],
                activeShapes: [
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                titleList[int.parse(currentIndexPage.toStringAsFixed(0))],
                style: Utils.fonts(size: 26.0),
                textAlign: TextAlign.center,
              ),
            ),
            currentIndexPage == 2
                ? SizedBox(
              height: 30,
            )
                : SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                descList[int.parse(currentIndexPage.toStringAsFixed(0))],
                style: Utils.fonts(size: 18.0, color: Utils.greyColor),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MobileNoScreen()),
                          (route) => false);

                  CommonFunction.firebaseEvent(
                    clientCode: "dummy",
                    device_manufacturer: Dataconstants.deviceName,
                    device_model: Dataconstants.devicemodel,
                    eventId: "1.0.1.0.0",
                    eventLocation: "footer",
                    eventMetaData: "dummy",
                    eventName: "get_started",
                    os_version: Dataconstants.osName,
                    location: "dummy",
                    eventType:"Click",
                    sessionId: "dummy",
                    platform: Platform.isAndroid ? 'Android' : 'iOS',
                    screenName: "welcome screen",
                    serverTimeStamp: DateTime.now().toString(),
                    source_metadata: "dummy",
                    subType: "button",
                  );

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 50.0),
                  child: Text(
                    "LET'S GET STARTED",
                    style: Utils.fonts(
                        size: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Utils.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )))),
            // ElevatedButton(
            //     onPressed: () {
            //       // Utils.saveSharedPreferences("IntroDone", true, "Bool");
            //       Navigator.pushAndRemoveUntil(
            //           context,
            //           MaterialPageRoute(builder: (context) => MobileNoScreen()),
            //               (route) => false);
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //           vertical: 15.0, horizontal: 50.0),
            //       child: Text(
            //         "LET'S GET STARTED",
            //         style: Utils.fonts(
            //             size: 14.0,
            //             color: Colors.white,
            //             fontWeight: FontWeight.w400),
            //       ),
            //     ),
            //     style: ButtonStyle(
            //         backgroundColor:
            //         MaterialStateProperty.all<Color>(Utils.primaryColor),
            //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //             RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(50.0),
            //             )))),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}