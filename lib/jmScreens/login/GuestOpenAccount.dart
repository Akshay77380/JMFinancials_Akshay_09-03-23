import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/jmScreens/login/Login.dart';
import 'package:markets/util/BrokerInfo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'MultipleAccount.dart';

class OpenGuestAccount extends StatefulWidget {
  const OpenGuestAccount({Key key}) : super(key: key);

  @override
  State<OpenGuestAccount> createState() => _OpenGuestAccountState();
}

class _OpenGuestAccountState extends State<OpenGuestAccount> {

  @override
  void initState() {
    var params = {
      "screen": "Guest_Open_Account_Screen",
    };
    CommonFunction.JMFirebaseLogging("Screen_Tracking", params);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(child: SvgPicture.asset("assets/appImages/openaccount.svg")),
            Container(
                margin: EdgeInsets.zero,
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  "assets/appImages/jmicon.svg",
                  // color: Colors.grey,
                )),
            Text(
              "Hello",
              style: Utils.fonts(size: 14.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 71.0),
              child: InkWell(
                onTap: () async{

                },
                child: Text(
                  "Open Account In 15 Minutes",
                  textAlign: TextAlign.center,
                  style: Utils.fonts(size: 26.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 71.0),
              child: Text(
                "Digital, paperless eKYC account opening in no time",
                textAlign: TextAlign.center,
                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
              ),
            ),
            ElevatedButton(
                onPressed: () async {

                  CommonFunction.firebaseEvent(
                    clientCode: "dummy",
                    device_manufacturer: Dataconstants.deviceName,
                    device_model: Dataconstants.devicemodel,
                    eventId: "2.0.1.0.0",
                    eventLocation: "footer",
                    eventMetaData: "dummy",
                    eventName: "open_account",
                    os_version: Dataconstants.osName,
                    location: "dummy",
                    eventType:"Click",
                    sessionId: "dummy",
                    platform: Platform.isAndroid ? 'Android' : 'iOS',
                    screenName: "discover blink trade",
                    serverTimeStamp: DateTime.now().toString(),
                    source_metadata: "dummy",
                    subType: "button",
                  );
                  if (await canLaunch(BrokerInfo.openAnAccount))
                    await launch(BrokerInfo.openAnAccount);


                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 50.0),
                  child: Text(
                    "OPEN MY ACCOUNT",
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
            //     onPressed: () async {
            //
            //       String deviceName, osName, devicemodel;
            //       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            //
            //       if (Platform.isIOS) {
            //         IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
            //         //print("${iosInfo.name}");
            //         deviceName = iosInfo.name;
            //         osName = iosInfo.systemVersion;
            //         devicemodel = iosInfo.model;
            //       } else {
            //         AndroidDeviceInfo androidInfo =
            //             await deviceInfo.androidInfo;
            //         //print("${androidInfo.brand}");
            //         deviceName = androidInfo.brand.replaceAll(' ', '');
            //         osName = 'Android${androidInfo.version.release}';
            //         devicemodel = androidInfo.model;
            //       }
            //
            //       CommonFunction.firebaseEvent(
            //         clientCode: "dummy",
            //         device_manufacturer: deviceName,
            //         device_model: devicemodel,
            //         eventId: "2.0.1.0.0",
            //         eventLocation: "footer",
            //         eventMetaData: "dummy",
            //         eventName: "open_account",
            //         os_version: osName,
            //         location: "dummy",
            //         eventType:"Click",
            //         sessionId: "dummy",
            //         platform: Platform.isAndroid ? 'Android' : 'iOS',
            //         screenName: "discover blink trade",
            //         serverTimeStamp: DateTime.now().toString(),
            //         source_metadata: "dummy",
            //         subType: "button",
            //       );
            //
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => MultipleAccounts()));
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
            //             MaterialStateProperty.all<Color>(Utils.primaryColor),
            //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //             RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(50.0),
            //         )))),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login()));
              },
              child: Text("Sign In",
                  style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
              },
              child: Text("Let me Explore App",
                  style: Utils.fonts(size: 14.0, color: Utils.greyColor)),
            ),
          ],
        ),
      ),
    );
  }
}
