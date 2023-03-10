import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:validators/validators.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'ChangePassword.dart';
import 'OTPscreen.dart';

class TroubleSignIn extends StatefulWidget {
  const TroubleSignIn({Key key}) : super(key: key);

  @override
  State<TroubleSignIn> createState() => _TroubleSignInState();
}

class _TroubleSignInState extends State<TroubleSignIn> {
  final FocusNode myFocusNodeUserIDLogin = FocusNode();
  final FocusNode myFocusNodeUserEmailIDLogin = FocusNode();
  final FocusNode myFocusNodePanLogin = FocusNode();
  TextEditingController _loginUserIDController = TextEditingController();
  TextEditingController _loginUserEmailIDController = TextEditingController();
  TextEditingController _loginPanController = TextEditingController();
  bool isValidateEnable = false;

  @override
  Future<void> initState() {
    if (_loginUserIDController.text.length > 0 && _loginUserEmailIDController.text.length > 0 && _loginPanController.text.length > 0) isValidateEnable = true;
    super.initState();
    getEvent();
  }

  getEvent() async {
    CommonFunction.firebaseEvent(
      clientCode: "dummy",
      device_manufacturer: Dataconstants.deviceName,
      device_model: Dataconstants.devicemodel,
      eventId: "5.1.0.0.0",
      eventLocation: "body",
      eventMetaData: "dummy",
      eventName: "s-having_trouble_signing_in",
      os_version: Dataconstants.osName,
      location: "dummy",
      eventType: "impression",
      sessionId: "dummy",
      platform: Platform.isAndroid ? 'Android' : 'iOS',
      screenName: "having trouble signing in",
      serverTimeStamp: DateTime.now().toString(),
      source_metadata: "dummy",
      subType: "screen",
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
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
                  "Trouble Signing In?",
                  textAlign: TextAlign.center,
                  style: Utils.fonts(size: 26.0),
                ),
                Text(
                  "Don’t worry. Let’s get you signed in",
                  style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w100),
                ),
                TextField(
                  onTap: () async {
                    CommonFunction.firebaseEvent(
                      clientCode: _loginUserIDController.text,
                      device_manufacturer: Dataconstants.deviceName,
                      device_model: Dataconstants.devicemodel,
                      eventId: "5.0.1.0.0",
                      eventLocation: "body",
                      eventMetaData: "dummy",
                      eventName: "enter_user_id",
                      os_version: Dataconstants.osName,
                      location: "dummy",
                      eventType: "Click",
                      sessionId: "dummy",
                      platform: Platform.isAndroid ? 'Android' : 'iOS',
                      screenName: "having trouble signing in",
                      serverTimeStamp: DateTime.now().toString(),
                      source_metadata: "dummy",
                      subType: "enter text",
                    );
                  },
                  controller: _loginUserIDController,
                  focusNode: myFocusNodeUserIDLogin,
                  // showCursor: true,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  onChanged: (value) {
                    if (_loginUserIDController.text.length > 0 && _loginUserEmailIDController.text.length > 0 && _loginPanController.text.length > 0) {
                      setState(() {
                        isValidateEnable = true;
                      });
                    } else {
                      setState(() {
                        isValidateEnable = false;
                      });
                    }
                  },
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).cardColor,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    focusColor: Theme.of(context).primaryColor,
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    labelText: "Client Id",
                    prefixIcon: Icon(
                      Icons.phone_android_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextField(
                  onTap: () async {
                    CommonFunction.firebaseEvent(
                      clientCode: _loginUserIDController.text,
                      device_manufacturer: Dataconstants.deviceName,
                      device_model: Dataconstants.devicemodel,
                      eventId: "5.0.2.0.0",
                      eventLocation: "body",
                      eventMetaData: "dummy",
                      eventName: "enter_email_id",
                      os_version: Dataconstants.osName,
                      location: "dummy",
                      eventType: "Click",
                      sessionId: "dummy",
                      platform: Platform.isAndroid ? 'Android' : 'iOS',
                      screenName: "having trouble signing in",
                      serverTimeStamp: DateTime.now().toString(),
                      source_metadata: "dummy",
                      subType: "enter text",
                    );
                  },
                  controller: _loginUserEmailIDController,
                  focusNode: myFocusNodeUserEmailIDLogin,
                  // showCursor: true,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  onChanged: (value) {
                    if (_loginUserIDController.text.length > 0 && _loginUserEmailIDController.text.length > 0 && _loginPanController.text.length > 0) {
                      setState(() {
                        isValidateEnable = true;
                      });
                    } else {
                      setState(() {
                        isValidateEnable = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).cardColor,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    focusColor: Theme.of(context).primaryColor,
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextField(
                  onTap: () async {
                    CommonFunction.firebaseEvent(
                      clientCode: _loginUserIDController.text,
                      device_manufacturer: Dataconstants.deviceName,
                      device_model: Dataconstants.devicemodel,
                      eventId: "5.0.3.0.0",
                      eventLocation: "body",
                      eventMetaData: "dummy",
                      eventName: "enter_pan_number",
                      os_version: Dataconstants.osName,
                      location: "dummy",
                      eventType: "Click",
                      sessionId: "dummy",
                      platform: Platform.isAndroid ? 'Android' : 'iOS',
                      screenName: "having trouble signing in",
                      serverTimeStamp: DateTime.now().toString(),
                      source_metadata: "dummy",
                      subType: "enter text",
                    );
                  },
                  controller: _loginPanController,
                  focusNode: myFocusNodePanLogin,
                  // showCursor: true,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  onChanged: (value) {
                    if (_loginUserIDController.text.length > 0 && _loginUserEmailIDController.text.length > 0 && _loginPanController.text.length > 0) {
                      setState(() {
                        isValidateEnable = true;
                      });
                    } else {
                      setState(() {
                        isValidateEnable = false;
                      });
                    }
                  },
                  onSubmitted: (_) {
                    Focus.of(context).unfocus();
                  },
                  inputFormatters: [UpperCaseTextFormatter(), LengthLimitingTextInputFormatter(10)],
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).cardColor,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    focusColor: Theme.of(context).primaryColor,
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    labelText: "PAN",
                    prefixIcon: Icon(
                      Icons.credit_card,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: isValidateEnable
                          ? () async {
                              // if (_loginPanController.text == '' || _loginUserIDController.text == '' || _loginUserEmailIDController.text == '') {
                              //   if (_loginPanController.text == '') {
                              //     CommonFunction.showBasicToast("Enter PAN");
                              //   } else if (_loginUserIDController.text == '') {
                              //     CommonFunction.showBasicToast("Enter Client ID");
                              //   } else if (_loginUserEmailIDController.text == '') {
                              //     CommonFunction.showBasicToast("Enter Email ID");
                              //   }
                              // } else
                              if (!isEmail(_loginUserEmailIDController.text.trim())) {
                                CommonFunction.showBasicToast('Please enter valid Email ID');
                                return;
                              } else if (!RegExp('[A-Z]{5}[0-9]{4}[A-Z]{1}').hasMatch(_loginPanController.text.trim())) {
                                CommonFunction.showBasicToast('Please enter valid PAN number');
                                return;
                              } else {
                                var requestJson = {
                                  "userid": _loginUserIDController.text.trim(),
                                  "pan": _loginPanController.text.trim(),
                                  "dob": "",
                                  "email": _loginUserEmailIDController.text.trim(),
                                  "mobile": ""
                                };
                                var responses = await CommonFunction.verifyAccountDetails(requestJson);
                                var jsons = json.decode(responses);
                                if (jsons['status'] == false)
                                  CommonFunction.showBasicToast(jsons["emsg"].toString());
                                else {
                                  var data = jsons['data'];
                                  if (data['email'] == false) {
                                    CommonFunction.showBasicToast('Incorrect Email ID');
                                    return;
                                  }
                                  if (data['pan'] == false) {
                                    CommonFunction.showBasicToast('Incorrect PAN number');
                                    return;
                                  }
                                  showBottomSheet();
                                }
                              }
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                        child: Text(
                          "VALIDATE",
                          style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: isValidateEnable ? MaterialStateProperty.all<Color>(Utils.primaryColor) : MaterialStateProperty.all<Color>(Utils.primaryColor.withOpacity(0.2)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )))),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return new Container(
            height: 300.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "How can we help you?",
                          textAlign: TextAlign.center,
                          style: Utils.fonts(size: 18.0),
                        ),
                        GestureDetector(
                          onTap: () async {
                            CommonFunction.firebaseEvent(
                              clientCode: _loginUserIDController.text,
                              device_manufacturer: Dataconstants.deviceName,
                              device_model: Dataconstants.devicemodel,
                              eventId: "5.0.4.0.0",
                              eventLocation: "footer",
                              eventMetaData: "dummy",
                              eventName: "forgot_password",
                              os_version: Dataconstants.osName,
                              location: "dummy",
                              eventType: "Click",
                              sessionId: "dummy",
                              platform: Platform.isAndroid ? 'Android' : 'iOS',
                              screenName: "having trouble signing in",
                              serverTimeStamp: DateTime.now().toString(),
                              source_metadata: "dummy",
                              subType: "button",
                            );
                            var requestJson = {
                              "LOGINID": _loginUserIDController.text.trim(),
                              "pannumber": _loginPanController.text.trim(),
                              "Email": _loginUserEmailIDController.text.trim(),
                              "otp": "",
                            };
                            var responses = await CommonFunction.forgotPassword(requestJson);
                            var jsons = json.decode(responses);
                            if (jsons['status'] == false)
                              CommonFunction.showBasicToast(jsons["emsg"].toString());
                            else {
                              Dataconstants.forgotPass = true;
                              Dataconstants.accountDetails = [];
                              Dataconstants.accountDetails.addAll([
                                _loginUserIDController.text.trim(),
                                _loginPanController.text.trim(),
                                jsons["message"].toString().split('|')[1],
                                _loginUserEmailIDController.text.trim(),
                              ]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          // ChangePassword(false)
                                          OtpScreen(jsons['message'].toString().split("|")[1], false)));
                            }
                          },
                          child: Row(
                            children: [
                              Center(child: SvgPicture.asset("assets/appImages/troubleforgotpass.svg")),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Forgot Password",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 16.0),
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Center(
                        //         child: SvgPicture.asset(
                        //             "assets/appImages/troubleforgotpass.svg")),
                        //     SizedBox(
                        //       width: 20,
                        //     ),
                        //     Text(
                        //       "Forgot Password",
                        //       textAlign: TextAlign.center,
                        //       style: Utils.fonts(size: 16.0),
                        //     ),
                        //   ],
                        // ),
                        GestureDetector(
                          onTap: () async {
                            CommonFunction.firebaseEvent(
                              clientCode: _loginUserIDController.text,
                              device_manufacturer: Dataconstants.deviceName,
                              device_model: Dataconstants.devicemodel,
                              eventId: "5.0.5.0.0",
                              eventLocation: "footer",
                              eventMetaData: "dummy",
                              eventName: "reset_2fa",
                              os_version: Dataconstants.osName,
                              location: "dummy",
                              eventType: "Click",
                              sessionId: "dummy",
                              platform: Platform.isAndroid ? 'Android' : 'iOS',
                              screenName: "having trouble signing in",
                              serverTimeStamp: DateTime.now().toString(),
                              source_metadata: "dummy",
                              subType: "button",
                            );
                          },
                          child: Row(
                            children: [
                              Center(child: SvgPicture.asset("assets/appImages/troublereset.svg")),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Reset 2FA",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 16.0),
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Center(
                        //         child: SvgPicture.asset(
                        //             "assets/appImages/troublereset.svg")),
                        //     SizedBox(
                        //       width: 20,
                        //     ),
                        //     Text(
                        //       "Reset 2FA",
                        //       textAlign: TextAlign.center,
                        //       style: Utils.fonts(size: 16.0),
                        //     ),
                        //   ],
                        // ),
                        GestureDetector(
                          onTap: () async {
                            CommonFunction.firebaseEvent(
                              clientCode: _loginUserIDController.text,
                              device_manufacturer: Dataconstants.deviceName,
                              device_model: Dataconstants.devicemodel,
                              eventId: "5.0.6.0.0",
                              eventLocation: "footer",
                              eventMetaData: "dummy",
                              eventName: "unblock_account",
                              os_version: Dataconstants.osName,
                              location: "dummy",
                              eventType: "Click",
                              sessionId: "dummy",
                              platform: Platform.isAndroid ? 'Android' : 'iOS',
                              screenName: "having trouble signing in",
                              serverTimeStamp: DateTime.now().toString(),
                              source_metadata: "dummy",
                              subType: "button",
                            );
                          },
                          child: Row(
                            children: [
                              Center(child: SvgPicture.asset("assets/appImages/troubleunblockaccount.svg")),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Unblock Account",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 16.0),
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     Center(
                        //         child: SvgPicture.asset(
                        //             "assets/appImages/troubleunblockaccount.svg")),
                        //     SizedBox(
                        //       width: 20,
                        //     ),
                        //     Text(
                        //       "Unblock Account",
                        //       textAlign: TextAlign.center,
                        //       style: Utils.fonts(size: 16.0),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}
