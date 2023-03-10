import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'ChangePassword.dart';

class SetMpin extends StatefulWidget {
  final bool isSettingScreen;
  final String userid;
  final String password;

  SetMpin({this.isSettingScreen, this.userid, this.password});

  @override
  State<SetMpin> createState() => _SetMpinState();
}

class _SetMpinState extends State<SetMpin> with TickerProviderStateMixin {
  StreamController<ErrorAnimationType> errorController;
  final  GlobalKey<ScaffoldMessengerState> _scaffoldKey = new GlobalKey<ScaffoldMessengerState>();
  var currentText, newCurrentText, confirnNewCurrentText;
  bool isMpinSet = false, showSuccessfulPinPopUp = false, isNewmpin;
  TextEditingController _mpinController = TextEditingController();
  TextEditingController _newmpinTextController = TextEditingController();
  TextEditingController _confirmnewmpinTextController = TextEditingController();
  String mpinText = '', confirmPinText = '', newmpinText = '', confirmNewmpinText = '';
  AnimationController _controller, _newmpincontroller, _confirmnewmpincontroller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _newmpincontroller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _confirmnewmpincontroller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      HomeWidgets.assignWidgets(Dataconstants.navigatorKey.currentContext);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _mpinController.dispose();
    _newmpinTextController.dispose();
    _confirmnewmpinTextController.dispose();
    _newmpincontroller.dispose();
    _confirmnewmpincontroller.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  // height: 100,
                  height: size.height * 0.12,
                ),
                Text(
                  "${Dataconstants.resetMPin ? 'ReSet' : isMpinSet ? 'Confirm' : 'Set'} MPIN",
                  textAlign: TextAlign.center,
                  style: Utils.fonts(size: 24.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  // height: 80,
                  height: size.height * 0.1,
                ),
                Text(
                  "${isMpinSet ? 'Confirm' : 'Enter'} MPIN",
                  style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                ),
                SizedBox(
                  height: 30,
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    final dx = sin(_controller.value * 2 * pi) * 4;
                    return Transform.translate(
                      offset: Offset(dx, 0),
                      child: child,
                    );
                  },
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: theme.textTheme.bodyText1.color,
                      fontWeight: FontWeight.bold,
                    ),
                    errorTextSpace: 2,
                    enablePinAutofill: false,
                    hapticFeedbackTypes: HapticFeedbackTypes.medium,
                    textStyle: Utils.fonts(size: 16.0),
                    length: 4,
                    obscureText: true,
                    // obscuringCharacter: ,
                    blinkWhenObscuring: true,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.0),
                      borderWidth: 2.0,
                      fieldHeight: 40,
                      fieldWidth: 40,
                      errorBorderColor: mpinText.trim() != confirmPinText.trim() ? Colors.red : Colors.grey,
                      activeFillColor: Color(0xff969ba1),
                      activeColor: Color(0xff969ba1),
                      inactiveColor: Colors.grey[400],
                      selectedColor: Color(0xff969ba1),
                    ),
                    cursorColor: Utils.blackColor,
                    animationDuration: Duration(milliseconds: 300),
                    errorAnimationController: errorController,
                    controller: _mpinController,
                    keyboardType: TextInputType.number,
                    onCompleted: (v) async {
                      if (isMpinSet) {
                        Dataconstants.confirmMPin = _mpinController.text;
                      } else {
                        Dataconstants.currentMPin = _mpinController.text;
                      }
                    },
                    onChanged: (value) {
                      // //print(value);
                      if (value.length == 4) {
                        setState(() {
                          currentText = value;
                        });
                      } else {
                        setState(() {
                          currentText = value;
                        });
                      }
                    },
                    beforeTextPaste: (text) {
                      // //print("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
                onTap: () async {
                  CommonFunction.firebaseEvent(
                    clientCode: "dummy",
                    device_manufacturer: Dataconstants.deviceName,
                    device_model: Dataconstants.devicemodel,
                    eventId: "7.0.1.0.0",
                    eventLocation: "footer",
                    eventMetaData: "dummy",
                    eventName: "pin",
                    os_version: Dataconstants.osName,
                    location: "dummy",
                    eventType: "click",
                    sessionId: "dummy",
                    platform: Platform.isAndroid ? 'Android' : 'iOS',
                    screenName: "simplified login",
                    serverTimeStamp: DateTime.now().toString(),
                    source_metadata: "dummy",
                    subType: "icon",
                  );
                },
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                      child: Text(
                        isMpinSet ? "CONFIRM MPIN" : "SET MPIN",
                        style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ))),
                    onPressed: () async {
                      CommonFunction.firebaseEvent(
                        clientCode: "dummy",
                        device_manufacturer: Dataconstants.deviceName,
                        device_model: Dataconstants.devicemodel,
                        eventId: "7.0.1.0.0",
                        eventLocation: "footer",
                        eventMetaData: "dummy",
                        eventName: "pin",
                        os_version: Dataconstants.osName,
                        location: "dummy",
                        eventType: "click",
                        sessionId: "dummy",
                        platform: Platform.isAndroid ? 'Android' : 'iOS',
                        screenName: "simplified login",
                        serverTimeStamp: DateTime.now().toString(),
                        source_metadata: "dummy",
                        subType: "icon",
                      );

                      // var requestJson = {
                      //   "LoginID": widget.userid,
                      //   "Password": widget.password,
                      //   "Dob": "01011980", //Dob,
                      //   "Pan": "",
                      //   "ApkVersion": "1.0.2",
                      //   "Source": "MOB",
                      // };

                      // var requestJson = {
                      //     "logindevice": Platform.isAndroid ? 'Android' : 'iOS',
                      //     "deviceid": Dataconstants.feUserDeviceID,
                      //     "userid": widget.userid,
                      //     "code": currentText,
                      //     "source": "MOB",
                      //     "ApkVersion": "1.0.0"
                      // };
                      //
                      // var response = await CommonFunction.setMpin(requestJson);
                      // var resdata = json.decode(response.toString());
                      //
                      // //print(resdata);

                      // if(isMpinSet){
                      //   showSuccessfulPinPopUp = true;
                      // }

                      if (isMpinSet) {
                        var isSuccess = await checkMpin();
                        if (isSuccess) {
                          var requestJson = {
                            "logindevice": Platform.isAndroid ? 'Android' : 'iOS',
                            "deviceid": Dataconstants.feUserDeviceID,
                            "userid": widget.userid,
                            "code": Dataconstants.biometriccode,
                            "mpin": currentText,
                            "source": "MOB",
                            "ApkVersion": "1.0.0"
                          };
                          var response = await CommonFunction.setMpin(requestJson);
                          var resdata = json.decode(response.toString());

                          var value = resdata['status'];
                          //print(value);
                          if (value) {
                            CommonFunction.bottomSheet(context, "SETMPIN");
                          } else {
                            CommonFunction.showBasicToast(resdata["emsg"].toString());
                          }
                        }
                      } else {
                        //print(Dataconstants.currentMPin);
                        setState(() {
                          isMpinSet = true;
                          _mpinController.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
            // if(widget.isSettingScreen)
            //   Center(
            //   child: SizedBox(
            //     width: double.maxFinite,
            //     child: ElevatedButton(
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 15.0, horizontal: 50.0),
            //         child: Text(
            //           "${isMpinSet ? 'Confirm' : 'SET'} MPIN",
            //           style: Utils.fonts(
            //               size: 14.0,
            //               color: Utils.whiteColor,
            //               fontWeight: FontWeight.w400),
            //         ),
            //       ),
            //       style: ButtonStyle(
            //           backgroundColor:
            //               MaterialStateProperty.all<Color>(Utils.primaryColor),
            //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //               RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(50.0),
            //           ))),
            //       onPressed: () async {
            //         if (_mpinController.text == '') {
            //           await _controller.forward(from: 0.0);
            //         }
            //
            //         if (isMpinSet == false) {
            //           setState(() {
            //             isMpinSet = true;
            //             mpinText = _mpinController.text;
            //             _mpinController.text = '';
            //           });
            //         } else {
            //           confirmPinText = _mpinController.text;
            //           showSuccessfulPinPopUp = true;
            //
            //           //print("mpin $mpinText and confoirm pin $confirmPinText");
            //           // checkMpin();
            //
            //           if (mpinText.trim() == confirmPinText.trim())
            //             return showModalBottomSheet(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10.0),
            //               ),
            //               context: context,
            //               builder: (context) => Container(
            //                 height: MediaQuery.of(context).size.height * 0.4,
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(20.0),
            //                   child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceEvenly,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       SvgPicture.asset(
            //                           'assets/appImages/successful.svg'),
            //                       SizedBox(
            //                         height: 10,
            //                       ),
            //                       Text(
            //                         "MPIN Registered",
            //                         style: Utils.fonts(
            //                           size: 14.0,
            //                           fontWeight: FontWeight.w300,
            //                           color: Utils.greyColor,
            //                         ),
            //                       ),
            //                       // SizedBox(
            //                       //   height: 5,
            //                       // ),
            //                       Text(
            //                         "Successfully",
            //                         style: Utils.fonts(
            //                           size: 20.0,
            //                           fontWeight: FontWeight.w600,
            //                           color: Utils.blackColor,
            //                         ),
            //                       ),
            //                       Center(
            //                         child: SizedBox(
            //                           width: double.maxFinite,
            //                           child: ElevatedButton(
            //                               onPressed: () {
            //                                 Navigator.of(context).push(
            //                                     MaterialPageRoute(
            //                                         builder: (context) =>
            //                                             ChangePassword(false)));
            //                               },
            //                               child: Padding(
            //                                 padding: const EdgeInsets.symmetric(
            //                                     vertical: 15.0,
            //                                     horizontal: 50.0),
            //                                 child: Text(
            //                                   "CONTINUE TO APP",
            //                                   style: Utils.fonts(
            //                                       size: 14.0,
            //                                       color: Utils.whiteColor,
            //                                       fontWeight: FontWeight.w400),
            //                                 ),
            //                               ),
            //                               style: ButtonStyle(
            //                                   backgroundColor:
            //                                       MaterialStateProperty.all<
            //                                               Color>(
            //                                           Utils.primaryColor),
            //                                   shape: MaterialStateProperty.all<
            //                                           RoundedRectangleBorder>(
            //                                       RoundedRectangleBorder(
            //                                     borderRadius:
            //                                         BorderRadius.circular(50.0),
            //                                   )))),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //               backgroundColor: Utils.whiteColor,
            //             );
            //         }
            //       },
            //     ),
            //   ),
            // )
            // else
            //   Center(
            //     child: SizedBox(
            //       width: double.maxFinite,
            //       child: ElevatedButton(
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               vertical: 15.0, horizontal: 50.0),
            //           child: Text(
            //             "Set MPIN",
            //             style: Utils.fonts(
            //                 size: 14.0,
            //                 color: Utils.whiteColor,
            //                 fontWeight: FontWeight.w400),
            //           ),
            //         ),
            //         style: ButtonStyle(
            //             backgroundColor:
            //             MaterialStateProperty.all<Color>(Utils.primaryColor),
            //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //                 RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(50.0),
            //                 ))),
            //         onPressed: () {},
            //       ),
            //     ),
            //   ),
          ],
        ),
      )),
    );
  }

  setMobileNo(number) {
    if (widget.isSettingScreen) {
      if (isNewmpin) {
        if (_newmpinTextController.text.length < 4)
          setState(() {
            _newmpinTextController.text += number;
          });
      } else {
        if (_confirmnewmpinTextController.text.length < 4)
          setState(() {
            _confirmnewmpinTextController.text += number;
          });
      }
    } else {
      if (_mpinController.text.length < 4)
        setState(() {
          _mpinController.text += number;
        });
    }
  }

  removeMobileNo() {
    if (widget.isSettingScreen) {
      if (isNewmpin) {
        if (_newmpinTextController.text.isNotEmpty)
          setState(() {
            _newmpinTextController.text = _newmpinTextController.text.substring(0, _newmpinTextController.text.length - 1);
          });
      } else {
        if (_confirmnewmpinTextController.text.isNotEmpty)
          setState(() {
            _confirmnewmpinTextController.text = _confirmnewmpinTextController.text.substring(0, _confirmnewmpinTextController.text.length - 1);
          });
      }
    } else {
      if (_mpinController.text.isNotEmpty)
        setState(() {
          _mpinController.text = _mpinController.text.substring(0, _mpinController.text.length - 1);
        });
    }
  }

  Future<bool> checkMpin() async {
    if (widget.isSettingScreen) {
      if (newmpinText.trim() != confirmNewmpinText.trim() && !isNewmpin) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Utils.greyColor,
            content: Text('Mpin and Confirm Mpin not Matching'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
    } else {
      if (Dataconstants.currentMPin.trim() != Dataconstants.confirmMPin.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Utils.greyColor,
            content: Text('Mpin and Confirm Mpin not Matching'),
            duration: Duration(seconds: 2),
          ),
        );

        return false;
      }
    }
    return true;
  }
}
