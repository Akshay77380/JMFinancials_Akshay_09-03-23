import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:markets/jmScreens/login/SetMpin.dart';
import 'package:markets/jmScreens/login/mobileScreen.dart';
import 'package:markets/util/InAppSelections.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/jmModel/login.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';
import 'ChangePassword.dart';
import 'Login.dart';

class ValidateMPIN extends StatefulWidget {
  final bool isSettingScreen;
  final String userid;
  final String password;
  bool registerBiometric = false;

  ValidateMPIN({this.isSettingScreen, this.userid, this.password, this.registerBiometric});

  @override
  State<ValidateMPIN> createState() => _ValidateMPINState();
}

class _ValidateMPINState extends State<ValidateMPIN> with TickerProviderStateMixin {
  StreamController<ErrorAnimationType> errorController;
  final  GlobalKey<ScaffoldMessengerState> _scaffoldKey = new GlobalKey<ScaffoldMessengerState>();

  var currentText, newCurrentText, confirnNewCurrentText;
  bool isMpinSet = false, showSuccessfulPinPopUp = false, isNewmpin;
  TextEditingController _mpinController = TextEditingController();
  TextEditingController _newmpinTextController = TextEditingController();
  TextEditingController _confirmnewmpinTextController = TextEditingController();
  String mpinText = '', confirmPinText = '', newmpinText = '', confirmNewmpinText = '';
  String userName = '', accessPin = '', password = '', biometriccode = '';
  AnimationController _controller, _newmpincontroller, _confirmnewmpincontroller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _newmpincontroller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _confirmnewmpincontroller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isBiometricAvailable();
      HomeWidgets.assignWidgets(Dataconstants.navigatorKey.currentContext);
    });

    if(Dataconstants.resetMPin)
      Dataconstants.resetMPin = false;
    else {
      if (InAppSelection.fingerPrintEnabled == true) {
        _authenticateUser();
      }
    }

    // TODO: implement initState
    super.initState();
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await CommonFunction.localAuthentication.authenticate(
        localizedReason: "Please authenticate to sign in",
        // stickyAuth: true,
      );
    } on PlatformException catch (e) {
      if (e.code == 'NotEnrolled')
        setState(() {
          //InAppSelection.isBioMetricAvailable = false;
          InAppSelection.fingerPrintEnabled = false;
        });
      //print(e);
      CommonFunction.localAuthentication.stopAuthentication();
    }

    if (!mounted) return;

    if (isAuthenticated) {
      HapticFeedback.vibrate();

      // if (_loginUserPassController.text.toString().isEmpty) {
      //   CommonFunction.showBasicToast("Please Enter Password");
      //   return;
      // }
      // loginPressed(_loginUserIDController.text.toString(), _loginUserPassController.text.toString(), _loginUserDobController.text.toString(), "");

      var requestJson = {
        "logindevice": Platform.isAndroid ? 'Android' : 'iOS',
        "deviceid": Dataconstants.feUserDeviceID,
        "userid": Dataconstants.feUserID,
        "code": Dataconstants.biometriccode,
        "task": "CHECKLOGIN",
        "source": "MOB",
        "ApkVErsion": "1.0.0"
      };

      var response = await CommonFunction.BiometricLogin(requestJson);
      var resdata = json.decode(response.toString());
      var resVal = resdata['status'];

      if (resVal) {
        Dataconstants.isMainOnLogin = true;
        var jsons = json.decode(response);
        Dataconstants.loginData = LoginFromJson(response);
        Dataconstants.biometriccode = jsons['data']['biometric'];
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MainScreen(
              changePassword: false,
              message: 'SUCCESS',
            ),
          ), (route) => false
        );
        Utils.saveSharedPreferences("LoggedInApp", true, "Bool");
      } else {
        CommonFunction.showBasicToast(resdata["emsg"].toString());
      }
    }
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
      appBar: widget.isSettingScreen
          ? AppBar(
              bottomOpacity: 2,
              backgroundColor: Utils.whiteColor,
              title: Text(
                "Change MPIN",
                style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
              ),
              elevation: 1,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Utils.greyColor,
                ),
              ),
              actions: [
                SvgPicture.asset('assets/appImages/tranding.svg'),
                SizedBox(
                  width: 15,
                )
              ],
            )
          : null,
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
                  "Welcome",
                  textAlign: TextAlign.center,
                  style: Utils.fonts(size: 24.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  // height: 80,
                  height: size.height * 0.1,
                ),
                Text(
                  "Unlock using MPIN",
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
                    autoFocus: true,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: theme.textTheme.bodyText1.color,
                      fontWeight: FontWeight.bold,
                    ),
                    errorTextSpace: 2,
                    hapticFeedbackTypes: HapticFeedbackTypes.medium,
                    textStyle: Utils.fonts(size: 16.0),
                    length: 4,
                    enablePinAutofill: false,
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
                    onCompleted: (v) {
                      // Focus.of(context).unfocus();
                    },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
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
                      "CONTINUE",
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
                    if (currentText.toString().length == 4) {
                      var requestJson = {
                        "logindevice": Platform.isAndroid ? 'Android' : 'iOS',
                        "deviceid": Dataconstants.feUserDeviceID,
                        "userid": Dataconstants.feUserID,
                        "code": Dataconstants.biometriccode,
                        "mpin": currentText,
                        "source": "MOB",
                        "ApkVErsion": "1.0.0"
                      };
                      var response = await CommonFunction.MPINLogin(requestJson);
                      var resdata = json.decode(response.toString());
                      if(resdata['status'] == false)
                        resdata["emsg"] == null ? null : CommonFunction.showBasicToast(resdata["emsg"].toString());
                      else {
                        var resVal = resdata['status'];
                        Dataconstants.isMainOnLogin = true;
                        var jsons = json.decode(response);
                        Dataconstants.loginData = LoginFromJson(response);
                        //print("${Dataconstants.loginData}");
                        Dataconstants.biometriccode = jsons['data']['biometric'];

                        if (resVal) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => MainScreen(
                                    changePassword: false,
                                    message: 'SUCCESS',
                                  ),
                                ), (route) => false
                            );
                            if(widget.registerBiometric)
                              CommonFunction.bottomSheet(context, 'REGISTERBIOMETRIC', comingFrom: 'validateMPIN');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Utils.greyColor,
                              content: Text('Session Expired !!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    } else {
                      if (Dataconstants.biometriccode != "") {
                        Dataconstants.isMainOnLogin = true;
                        var requestJson = {
                          "logindevice": Platform.isAndroid ? 'Android' : 'iOS',
                          "deviceid": Dataconstants.feUserDeviceID,
                          "userid": Dataconstants.feUserID,
                          "code": Dataconstants.biometriccode,
                          "task": "CHECKLOGIN",
                          "source": "MOB",
                          "ApkVErsion": "1.0.0"
                        };

                        var response = await CommonFunction.BiometricLogin(requestJson);
                        var resdata = json.decode(response.toString());
                        if(resdata['status'] == false)
                          CommonFunction.showBasicToast(resdata["emsg"].toString());
                        else {
                          var resVal = resdata['status'];
                          if (resVal) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => MainScreen(
                                    changePassword: false,
                                    message: 'SUCCESS',
                                  ),
                                ), (route) => false
                            );
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Utils.greyColor,
                            content: Text('Please enter 4 digit MPIN'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Dataconstants.isBiometricOtpVerified && InAppSelection.isBioMetricAvailable
                ? FutureBuilder<List<BiometricType>>(
                    future: CommonFunction.isBiometricAvailable(),
                    builder: (BuildContext context, AsyncSnapshot<List<BiometricType>> snapshot) {
                      if (snapshot.hasData && snapshot.data.isNotEmpty && InAppSelection.fingerPrintEnabled)
                        return Column(
                          children: [
                            Center(
                              child: Text(
                                'or login with',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            snapshot.data.contains(BiometricType.face)
                                ? InkWell(
                                    onTap: _authenticateUser,
                                    child: Image.asset('assets/images/icons/face_unlock.png'),
                                  )
                                : IconButton(
                                    iconSize: 50,
                                    color: Theme.of(context).primaryColor,
                                    icon: Icon(Icons.fingerprint),
                                    onPressed: _authenticateUser,
                                  ),
                          ],
                        );
                      else
                        return const SizedBox.shrink();
                    },
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () async {
                        Dataconstants.resetMPin = true;
                        Dataconstants.login2FAOtp = '';
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setString('accessPin', '');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        "Reset",
                        style: Utils.fonts(size: 14.0, color: Colors.grey, fontWeight: FontWeight.w400),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  VerticalDivider(color: Colors.grey),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                      onTap: () async {
                        CommonFunction.setUsernamePass(delete: true);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setBool('FingerprintEnabled', false);
                        prefs.setBool('BiometricEnabled', false);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MobileNoScreen()));
                      },
                      child: Text(
                        "Switch Accounts",
                        style: Utils.fonts(size: 14.0, color: Colors.grey, fontWeight: FontWeight.w400),
                      )),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  void isBiometricAvailable() async {
    try {
      var biometrics = await CommonFunction.isBiometricAvailable();
      InAppSelection.isBioMetricAvailable = biometrics.isNotEmpty;

      SharedPreferences pref = await SharedPreferences.getInstance();
      bool isFingerPrintAvailable = pref.getBool("FingerprintEnabled");
      InAppSelection.fingerPrintEnabled = isFingerPrintAvailable;
      Dataconstants.isBiometricOtpVerified = isFingerPrintAvailable ?? false;
    } catch (e) {}

    setState(() {});
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
