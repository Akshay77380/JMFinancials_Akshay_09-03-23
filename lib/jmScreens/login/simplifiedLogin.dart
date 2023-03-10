import 'dart:collection';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markets/util/Dataconstants.dart';
import 'package:markets/util/InAppSelections.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import 'SetMpin.dart';

class SimplifiedLogin extends StatefulWidget {
  const SimplifiedLogin({Key key}) : super(key: key);

  @override
  State<SimplifiedLogin> createState() => _SimplifiedLoginState();
}

class _SimplifiedLoginState extends State<SimplifiedLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Hello",
                textAlign: TextAlign.center,
                style: Utils.fonts(size: 24.0, color: Utils.blackColor),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  "Activate MPIN / Face / Fingerprint for fast & secure login.",
                  style: Utils.fonts(size: 14.0, color: Utils.blackColor),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: 246,
                  child: Column(
                    children: [
                      Text(
                        "After activation the mode selected will be used for login",
                        style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'You can also activate it by visiting Settings > Security type.',
                          style:
                              Utils.fonts(size: 14.0, color: Utils.greyColor))
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                'Select your simplified login type',
                style: Utils.fonts(
                  size: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Utils.blackColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Logintype('assets/appImages/mpin.svg', 'MPIN', context),
                  Logintype('assets/appImages/face.svg', 'FACE ID/FINGERPRINT',
                      context),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {

                  CommonFunction.firebaseEvent(
                    clientCode: "dummy",
                    device_manufacturer: Dataconstants.deviceName,
                    device_model: Dataconstants.devicemodel,
                    eventId: "7.0.4.0.0",
                    eventLocation: "footer",
                    eventMetaData: "dummy",
                    eventName: "register_later",
                    os_version: Dataconstants.osName,
                    location: "dummy",
                    eventType:"Click",
                    sessionId: "dummy",
                    platform: Platform.isAndroid ? 'Android' : 'iOS',
                    screenName: "simplified login",
                    serverTimeStamp: DateTime.now().toString(),
                    source_metadata: "dummy",
                    subType: "button",
                  );
                },
                child: Center(
                  child: Text('Register Later',
                      style: Utils.fonts(
                        size: 14.0,
                        color: Utils.greyColor,
                      )),
                ),
              )
              // Center(
              //   child: Text('Register Later',
              //       style: Utils.fonts(
              //         size: 14.0,
              //         color: Utils.greyColor,
              //       )),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requestFingerprintAccess(BuildContext context) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          var theme = Theme.of(context);
          return Platform.isIOS
              ? CupertinoAlertDialog(
            title: const Text('Biometric Login'),
            content: Text(
              'Do you want to enable Biometric Login? You can change this setting later in Settings page.',
              style: TextStyle(color: Colors.grey),
            ),
            //content: ChangelogScreen(),
            actions: <Widget>[


              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    InAppSelection.fingerPrintEnabled = false;
                    prefs.setBool('FingerprintEnabled', false);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: Utils.fonts(
                      size: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    CommonFunction.bottomSheet(context,"BIOMETRIC");
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    InAppSelection.fingerPrintEnabled = true;
                    prefs.setBool('FingerprintEnabled', true);

                  },
                  child: Text(
                    "Allow",
                    style: Utils.fonts(
                      size: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )

            ],
          )
              : AlertDialog(
            title: Text('Biometric Login'),
            content: Text(
              'Do you want to enable Biometric Login? You can change this setting later in Settings page.',
              style: TextStyle(color: Colors.grey),
            ),
            //content: ChangelogScreen(),
            actions: <Widget>[

              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    InAppSelection.fingerPrintEnabled = false;
                    prefs.setBool('FingerprintEnabled', false);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    CommonFunction.bottomSheet(context,"BIOMETRIC");

                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        InAppSelection.fingerPrintEnabled = true;
                        prefs.setBool('FingerprintEnabled', true);

                  },
                  child: Text(
                    "Allow",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ),
              )

              // TextButton(
              //   child: Text(
              //     'Cancel',
              //     style: TextStyle(
              //       color: theme.primaryColor,
              //     ),
              //   ),
              //   onPressed: () async {
              //     SharedPreferences prefs =
              //     await SharedPreferences.getInstance();
              //     InAppSelection.fingerPrintEnabled = false;
              //     prefs.setBool('FingerprintEnabled', false);
              //     Navigator.of(context).pop();
              //   },
              // ),
              // TextButton(
              //   child: Text(
              //     'Allow',
              //     style: TextStyle(
              //       color: theme.primaryColor,
              //     ),
              //   ),
              //   onPressed: () async {
              //     SharedPreferences prefs =
              //     await SharedPreferences.getInstance();
              //     InAppSelection.fingerPrintEnabled = true;
              //     prefs.setBool('FingerprintEnabled', true);
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          );
        });
  }

  Widget Logintype(String icon, String loginTypeText, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (loginTypeText == 'MPIN') {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => SetMpin(false)));

          //SETMPIN
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SetMpin(isSettingScreen: false,
                userid: Dataconstants.feUserID,
                password: Dataconstants.feUserPassword1,)));
          //SETMPIN
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool('fingerprintRegister', true);


          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => SetMpin(isSettingScreen: false,
          //       userid: Dataconstants.feUserID,
          //       password: Dataconstants.feUserPassword1,)));

          requestFingerprintAccess(context);

        }
      },
      child: Column(
        children: [
          Container(
            width: 86.9,
            height: 86.9,
            child: SvgPicture.asset(icon),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            '$loginTypeText',
            style: Utils.fonts(
              size: 12.9,
              fontWeight: FontWeight.w400,
              color: Utils.blackColor,
            ),
          )
        ],
      ),
    );
  }
}
