import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:markets/jmScreens/login/MultipleAccount.dart';
import 'package:markets/jmScreens/login/SetMpin.dart';
import 'package:markets/jmScreens/login/simplifiedLogin.dart';
import 'package:markets/jmScreens/login/validatempin.dart';
import 'package:markets/util/BrokerInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Connection/ResponseListener.dart';
import '../../database/watchlist_database.dart';
import '../../model/jmModel/login.dart';
import '../../util/CommonFunctions.dart';
import '../../util/ConnectionStatus.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import 'package:http/http.dart' as http;

import '../mainScreen/MainScreen.dart';
import 'OTPscreen.dart';
import 'TroubleSignin.dart';
import 'mobileScreen.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin implements ResponseListener {
  final _formKey = GlobalKey<FormState>();

  final FocusNode myFocusNodeUserIDLogin = FocusNode();
  TextEditingController _loginUserIDController = TextEditingController();
  final FocusNode myFocusNodeUserIDPass = FocusNode();
  final FocusNode myFocusNodeUserDOB = FocusNode();
  TextEditingController _loginUserPassController = TextEditingController();
  TextEditingController _loginUserDobController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureDOB = true;
  SharedPreferences pref;
  final yearOfBirthRegex = RegExp(r'[A-Za-z.-]');
  String userName = '', accessPin = '', password = '', biometriccode = '';
  int _loginCount = 0;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  bool isValidateEnable = false;

  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");//22222

  @override
  void initState() {
    // getIPDetails(); //TODO: 21/12
    checkIfFirstInstalledApp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsernamePass();
    });
    super.initState();
    WatchlistDatabase.instance.initDB();
    CommonFunction.getDefault();
    Dataconstants.itsClient.mResponseListener = this;
    // _loginUserDobController.text = "01011990";
    // _loginUserPassController.text = "abcd@123"; // UAT
    if (Dataconstants.selectedID != "") {
      _loginUserIDController.text = Dataconstants.selectedID; // UAT
    }
    // _loginUserPassController.text = "abc123"; // razorpay
    // _loginUserIDController.text = "10116241"; // razorpay
    // _loginUserIDController.text = "10114165"; // UAT
    // _loginUserIDController.text = "10116210"; // LIVE
    // _loginUserPassController.text = "july@2022"; // LIVE

    if (_loginUserPassController.text.length > 0 && _loginUserIDController.text.length > 0) {
      setState(() {
        isValidateEnable = true;
      });
    }

    var params = {
      "screen": "Login_Screen",
    };
    CommonFunction.JMFirebaseLogging("Screen_Tracking", params);
  }

  @override
  void dispose() {
    _loginUserIDController.dispose();
    _loginUserPassController.dispose();
    _loginUserDobController.dispose();
    super.dispose();
  }

  bool validatePassword(String pass){
    String _password = pass.trim();
    if(pass_valid.hasMatch(_password)){
      return false;
    }else{
      return false;
    }
  }

  checkIfFirstInstalledApp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var x = pref.setBool("firstInstall", false);
    // //print("first install => $x");
  }

  void getUsernamePass() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      userName = pref.getString('username');
      password = pref.getString('password');
      accessPin = pref.getString('accessPin');
      biometriccode = pref.getString('biometriccode');
      InAppSelection.fingerPrintEnabled = pref.getBool("FingerprintEnabled");

      Dataconstants.feUserID = userName;
      Dataconstants.feUserPassword1 = password;
      Dataconstants.confirmMPin = accessPin;
      Dataconstants.biometriccode = biometriccode;

      if (Dataconstants.resetMPin == false) if (userName != null && userName.isNotEmpty) {
        _loginUserIDController.text = userName.trim();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ValidateMPIN(isSettingScreen: false),
          ),
        );
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                "Welcome",
                textAlign: TextAlign.center,
                style: Utils.fonts(
                    size: 26.0
                ),
              ),
              Text(
                "Login to Blink Trade",
                style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w100),
              ),
              TextField(
                onTap: () async {
                  CommonFunction.firebaseEvent(
                    clientCode: _loginUserIDController.text,
                    device_manufacturer: Dataconstants.deviceName,
                    device_model: Dataconstants.devicemodel,
                    eventId: "3.0.1.0.0",
                    eventLocation: "body",
                    eventMetaData: "dummy",
                    eventName: "enter_user_id",
                    os_version: Dataconstants.osName,
                    location: "dummy",
                    eventType: "Click",
                    sessionId: "dummy",
                    platform: Platform.isAndroid ? 'Android' : 'iOS',
                    screenName: "welcome to blink trade",
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
                  if (_loginUserIDController.text.length > 0 && _loginUserPassController.text.length > 0) {
                    if (value.length > 0) {
                      setState(() {
                        isValidateEnable = true;
                      });
                    } else {
                      setState(() {
                        isValidateEnable = false;
                      });
                    }
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
                  labelText: "Client Id/ Email Id / Mobile No",
                  prefixIcon: Icon(
                    Icons.phone_android_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
              //RegExp regexUpper = RegExp(r'^(?=.*[A-Z])$');
              //             RegExp regexLower = RegExp(r'^(?=.*[a-z])$');
              //             RegExp regexLength = RegExp(r'^.{8,}$');
              //
              //             if (!regexLength.hasMatch(value.toString())) {
              //               return 'Пароль слишком короткий';
              //             }
              //             if (!regexLower.hasMatch(value.toString())) {
              //               //print(value);
              //               return 'Пароль должен содержать хотя бы одну маленькую букву';
              //             }
              //             if (!regexUpper.hasMatch(value.toString())) {
              //               return 'Введите хотя бы одну заглавную букву';
              //             }
              //             return null;
              TextFormField(
                key: _formKey,
                onTap: () async {
                  CommonFunction.firebaseEvent(
                    clientCode: _loginUserIDController.text,
                    device_manufacturer: Dataconstants.deviceName,
                    device_model: Dataconstants.devicemodel,
                    eventId: "3.0.6.0.0",
                    eventLocation: "body",
                    eventMetaData: "dummy",
                    eventName: "enter_password",
                    os_version: Dataconstants.osName,
                    location: "dummy",
                    eventType: "Click",
                    sessionId: "dummy",
                    platform: Platform.isAndroid ? 'Android' : 'iOS',
                    screenName: "welcome to blink trade",
                    serverTimeStamp: DateTime.now().toString(),
                    source_metadata: "dummy",
                    subType: "enter text",
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return "Please enter password";
                  }else{
                    //call function to check password
                    bool result = validatePassword(value);
                    if(result){
                      // create account event
                      return null;
                    }else{
                      return " Password should contain Capital, small letter &                                Number & Special";
                    }
                  }
                },
                controller: _loginUserPassController,
                focusNode: myFocusNodeUserIDPass,
                // showCursor: true,
                obscureText: _obscurePassword,

                // inputFormatters: [
                //   FilteringTextInputFormatter.deny(
                //     //^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$
                //
                //       RegExp(r'^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$')),
                //   // LengthLimitingTextInputFormatter(6),
                //
                // ],
                style: TextStyle(
                  fontSize: 18.0,
                ),
                onChanged: (value) {
                  if (_loginUserIDController.text.length > 0 && _loginUserPassController.text.length > 0) {
                    if (value.length > 0) {
                      setState(() {
                        isValidateEnable = true;
                      });
                    } else {
                      setState(() {
                        isValidateEnable = false;
                      });
                    }
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
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.visibility,
                      size: 18,
                      color: Colors.grey,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        _togglePassword();
                      },
                      child: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                        color: Colors.grey,
                      ),
                    )),
              ),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: isValidateEnable
                            ? () async {
                                if (_loginUserIDController.text.toString().isEmpty) {
                                  CommonFunction.showBasicToast("Login ID cannot be empty");
                                  return;
                                }
                                if (_loginUserPassController.text.toString().isEmpty) {
                                  CommonFunction.showBasicToast("Please Enter Password");
                                  return;
                                }
                                if (_loginUserPassController.text.length < 6) {
                                  CommonFunction.showBasicToast("Password should be minimum 6 characters");
                                  return;
                                }

                                if (_loginUserPassController.text.length > 12) {
                                  CommonFunction.showBasicToast("Password should be maximum 12 characters");
                                  return;
                                }

                                // if(pass_valid.hasMatch(_loginUserPassController.text)){
                                // }else{
                                //   CommonFunction.showBasicToast("Password should contain Capital, small letter & Number & Special");
                                // }



                                // if (_loginUserDobController.text.toString().isEmpty) {
                                //   CommonFunction.showBasicToast(
                                //       "DOB / Password cannot be empty");
                                //   return;
                                // }
                                // _formKey.currentState.validate();
                                //
                                // if (_formKey.currentState.validate()) {
                                //   // Process data.
                                // }

                                loginPressed(
                                    _loginUserIDController.text.toString(),
                                    _loginUserPassController.text.toString(),
                                    _loginUserDobController.text.toString(),
                                    "");

                                CommonFunction.firebaseEvent(
                                  clientCode: _loginUserIDController.text,
                                  device_manufacturer: Dataconstants.deviceName,
                                  device_model: Dataconstants.devicemodel,
                                  eventId: "3.0.8.0.0",
                                  eventLocation: "footer",
                                  eventMetaData: "dummy",
                                  eventName: "password_and_secure_image_validate",
                                  os_version: Dataconstants.osName,
                                  location: "dummy",
                                  eventType: "Click",
                                  sessionId: "dummy",
                                  platform: Platform.isAndroid ? 'Android' : 'iOS',
                                  screenName: "s-welcome to blink trade",
                                  serverTimeStamp: DateTime.now().toString(),
                                  source_metadata: "dummy",
                                  subType: "button",
                                );

                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => SimplifiedLogin()));
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
                    // SizedBox(height: 20,),

                    // InkWell(
                    //   onTap: (){
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => MultipleAccounts()));
                    //   },
                    //   child: Text(
                    //     "Switch account",
                    //     style: TextStyle(
                    //       decoration: TextDecoration.underline,
                    //       fontSize: 15.0,
                    //       fontWeight: FontWeight.w600,
                    //       color: Utils.primaryColor,
                    //     ),
                    //     // style: Utils.fonts(size: 14.0, color: Utils.primaryColor,fontWeight: FontWeight.w600,textDecoration:TextDecoration.underline, ),
                    //   ),
                    // ),
                  ],
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       if(Dataconstants.firsttimelogin == true){
                //
                //       }
                //       if (_loginUserIDController.text.toString().isEmpty) {
                //         CommonFunction.showBasicToast(
                //             "Login ID cannot be empty");
                //         return;
                //       }
                //       if (_loginUserPassController.text.toString().isEmpty) {
                //         CommonFunction.showBasicToast(
                //             "Password cannot be empty");
                //         return;
                //       }
                //       // if (_loginUserDobController.text.toString().isEmpty) {
                //       //   CommonFunction.showBasicToast(
                //       //       "DOB / Password cannot be empty");
                //       //   return;
                //       // }
                //       loginPressed(
                //           _loginUserIDController.text.toString(),
                //           _loginUserPassController.text.toString(),
                //           _loginUserDobController.text.toString(),
                //           "");
                //
                //       // Navigator.of(context).push(MaterialPageRoute(
                //       //     builder: (context) => SimplifiedLogin()));
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //           vertical: 15.0, horizontal: 50.0),
                //       child: Text(
                //         "VALIDATE",
                //         style: Utils.fonts(
                //             size: 14.0,
                //             color: Colors.white,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ),
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all<Color>(
                //             Utils.primaryColor),
                //         shape:
                //             MaterialStateProperty.all<RoundedRectangleBorder>(
                //                 RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(50.0),
                //         )))),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      // loginPressed("SPD111", "abc123", "01011990", "");

                      CommonFunction.firebaseEvent(
                        clientCode: _loginUserIDController.text,
                        device_manufacturer: Dataconstants.deviceName,
                        device_model: Dataconstants.devicemodel,
                        eventId: "2.0.3.0.0",
                        eventLocation: "footer",
                        eventMetaData: "dummy",
                        eventName: "login_as_guest",
                        os_version: Dataconstants.osName,
                        location: "dummy",
                        eventType: "Click",
                        sessionId: "dummy",
                        platform: Platform.isAndroid ? 'Android' : 'iOS',
                        screenName: "discover blink trade",
                        serverTimeStamp: DateTime.now().toString(),
                        source_metadata: "dummy",
                        subType: "button",
                      );

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => MainScreen(
                              changePassword: false,
                              message: 'SUCCESS',
                            ),
                          ), (route) => false
                      );

                      // loginNewClick();
                    },
                    child: Text(
                      "Login as Guest",
                      style: Utils.fonts(size: 14.0, color: Utils.primaryColor),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     loginPressed("SPD111", "abc123", "01011990", "");
                  //     // loginNewClick();
                  //   },
                  //   child: Text(
                  //     "Login as Guest",
                  //     style: Utils.fonts(size: 14.0, color: Utils.primaryColor),
                  //   ),
                  // ),
                  Container(
                    height: 30.0,
                    width: 2.0,
                    color: Utils.greyColor.withOpacity(0.3),
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TroubleSignIn()));

                      CommonFunction.firebaseEvent(
                        clientCode: _loginUserIDController.text,
                        device_manufacturer: Dataconstants.deviceName,
                        device_model: Dataconstants.devicemodel,
                        eventId: "2.0.4.0.0",
                        eventLocation: "footer",
                        eventMetaData: "dummy",
                        eventName: "trouble_signing_in",
                        os_version: Dataconstants.osName,
                        location: "dummy",
                        eventType: "Click",
                        sessionId: "dummy",
                        platform: Platform.isAndroid ? 'Android' : 'iOS',
                        screenName: "discover blink trade",
                        serverTimeStamp: DateTime.now().toString(),
                        source_metadata: "dummy",
                        subType: "button",
                      );
                    },
                    child: Text(
                      "Trouble signing in",
                      style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => TroubleSignIn()));
                  //   },
                  //   child: Text(
                  //     "Trouble signing in",
                  //     style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _authenticateUser() async {
  //   bool isAuthenticated = false;
  //   try {
  //     isAuthenticated = await _localAuthentication.authenticate(
  //       localizedReason: "Please authenticate to sign in",
  //       // stickyAuth: true,
  //     );
  //   } on PlatformException catch (e) {
  //     if (e.code == 'NotEnrolled')
  //       setState(() {
  //         //InAppSelection.isBioMetricAvailable = false;
  //         InAppSelection.fingerPrintEnabled = false;
  //       });
  //     //print(e);
  //     _localAuthentication.stopAuthentication();
  //   }
  //
  //   if (!mounted) return;
  //
  //   if (isAuthenticated) {
  //     HapticFeedback.vibrate();
  //     loginClick(true);
  //   }
  // }

  void loginClick(bool fingerprint) async {
    String strLogin, strPswd, strPin;
    strLogin = userName.toUpperCase().trim();
    strPswd = fingerprint ? password.trim() : _loginUserPassController.text.toString().toUpperCase().trim();

    strPin = strPswd.split('').reversed.join();

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("isLoggedOut", false);

    if (strLogin.isEmpty) {
      CommonFunction.showBasicToast("Login ID cannot be empty");
      return;
    }

    if (strPswd.isEmpty) {
      CommonFunction.showBasicToast("Password cannot be empty");
      return;
    }

    if (strPswd.length < 4) {
      CommonFunction.showBasicToast("Incorrect password");
      return;
    }

    _loginCount++;
    Dataconstants.feUserID = strLogin;
    Dataconstants.feUserPassword1 = strPswd;
    Dataconstants.feUserPassword2 = strPin;
  }

  static checkWatchList() {
    var jsons = {"LoginID": Dataconstants.feUserID, "Operation": "SELECT"};

    var response = CommonFunction.getWatchList(jsons);

    var responseJsons = jsonDecode(response);

    if (responseJsons["data"]) {}
  }

  Future<void> loginPressed(LoginID, Password, Dob, Pan) async {
    // Dataconstants.itsClient.onLoggedIn(
    //   indicator: 1,
    //   message: "SUCCESS",
    // );

    //TODO: request for / login api
    // var requestJson = {
    //   "LoginID": LoginID,
    //   "Password": Password,
    //   "Dob": "0101200", //Dob,
    //   "Pan": "",
    //   "ApkVersion": "1.0.2",
    //   "Source": "MOB",
    //   "imei": Dataconstants.feUserDeviceID,
    //   "devID": Dataconstants.feUserDeviceID,
    //   "LoginDevice": Platform.isAndroid ? 'Android' : 'iOS'
    // };

    //TODO: request for /login2FA api
    var requestJson = {
      "LoginID": LoginID,
      "Password": Password,
      "Dob": "01012000",
      "Pan": "",
      "ApkVersion": "1.0.2",
      "Source": "MOB",
      "LoginDevice": Platform.isAndroid ? 'Android' : 'iOS',
      "imei": Dataconstants.feUserDeviceID,
      "DevId": Dataconstants.feUserDeviceID,
      "FactorTwo": Dataconstants.isVerifyLoginOtp ? "" : Dataconstants.login2FAOtp,
    };

    // log('login payload -- $requestJson');
    Dataconstants.isMainOnLogin = true;
    var responses = await CommonFunction.login(requestJson);
    // log(responses["status"]);
    var jsonResponse = jsonDecode(responses);
    try {
    // Dataconstants.jwtTokenThroughoutApp = jsonResponse["data"]["jwtToken"];
      var jsons = json.decode(responses);
      if (jsons["status"] == false) {
        CommonFunction.showBasicToast(jsons["emsg"].toString());
      } else {
        Dataconstants.feUserID = LoginID;
        Dataconstants.feUserPassword1 = Password;
        if (Dataconstants.login2FAOtp == '') {
          // getUsernamePass();
          // if (Dataconstants.biometriccode != null || Dataconstants.biometriccode != '')
          //   InAppSelection.fingerPrintEnabled = true;
          // else
          //   InAppSelection.fingerPrintEnabled = false;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpScreen(jsons['message'].toString().split("|")[1], false)));
          Dataconstants.isMpinEnabled = false;
          Dataconstants.mpinFlag = jsons['data']['isMpinEnabled'];

        } else {
          Dataconstants.loginData = LoginFromJson(responses);
          Dataconstants.biometriccode = jsons['data']['biometric'];
          Dataconstants.isMpinEnabled = jsons['data']['isMpinEnabled'];
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("showPasswordPopup", true);
          Dataconstants.showPasswordPopup = true;
          Dataconstants.mpinFlag = jsons['data']['isMpinEnabled'];
          Dataconstants.itsClient.onLoggedIn(
            indicator: 1,
            message: "SUCCESS",
          );
        }
      }
    } catch (e) {
      var jsons = json.decode(responses);
      var params = {
        "Login": "Failure",
      };
      CommonFunction.JMFirebaseLogging("Login_Tracking", params);
      CommonFunction.showBasicToast(jsons["data"].toString());
    }
    return;
  }

  void loginNewClick() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("isLoggedOut", false);
    bool requested = sp.getBool('FingerPrintAccessRequested') ?? false;
    if (InAppSelection.isBioMetricAvailable && !requested) {
      sp.setBool('FingerPrintAccessRequested', true);
      await requestFingerprintAccess();
    }
    String strLogin, strPswd, strPin, strDOB;
    strLogin = 'demo4'.toUpperCase().trim();
    strPswd = 'abcd@1234'.toString().toUpperCase().trim();
    strPin = strPswd.split('').reversed.join();
    strDOB = '01/01/1980'.trim();
    if (strLogin.isEmpty) {
      CommonFunction.showBasicToast("Login ID cannot be empty");
      return;
    }
    if (strPswd.isEmpty) {
      CommonFunction.showBasicToast("Please enter password");
      return;
    }
    if (strPswd.length < 4) {
      CommonFunction.showBasicToast("Incorrect password");
      return;
    }
    if (strDOB.isEmpty) {
      CommonFunction.showBasicToast(BrokerInfo.yearOfBirth ? "Please enter year" : 'Please enter date of birth');
      return;
    }
    if (BrokerInfo.yearOfBirth) {
      if (strDOB.length != 4) {
        CommonFunction.showBasicToast("Year should be in YYYY format");
        return;
      }
    } else {
      if (strDOB.length != 10) {
        CommonFunction.showBasicToast("Date of birth should be in DD/MM/YYYY format");
        return;
      }
      final components = strDOB.split("/");
      if (components.length == 3) {
        final day = int.tryParse(components[0]);
        final month = int.tryParse(components[1]);
        final year = int.tryParse(components[2]);
        if (day != null && month != null && year != null) {
          final date = DateTime(year, month, day);
          if (date.year != year || date.month != month || date.day != day) {
            CommonFunction.showBasicToast("Invalid Date of birth");
            return;
          }
        }
      }
    }
    if (BrokerInfo.yearOfBirth && strDOB.contains(yearOfBirthRegex)) {
      CommonFunction.showBasicToast("Year can only contain numbers");
      return;
    }
    _loginCount++;
    if (BrokerInfo.yearOfBirth) strDOB = "01/01/" + strDOB;
    Dataconstants.feDob = DateUtil.getFormattedDate(strDOB);
    Dataconstants.feUserID = strLogin;
    Dataconstants.feUserPassword1 = strPswd;
    Dataconstants.feUserPassword2 = strPin;
    // connectITS();
  }

  Future<void> requestFingerprintAccess() async {
    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var theme = Theme.of(context);
          return Platform.isIOS
              ? CupertinoAlertDialog(
                  title: const Text('Biometric Login'),
                  content: Text(
                    'Do you want to enable Biometric Login? You can change this setting later in Settings page.', // no
                    style: TextStyle(color: Colors.grey),
                  ),
                  //content: ChangelogScreen(),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        InAppSelection.fingerPrintEnabled = false;
                        prefs.setBool('FingerprintEnabled', false);
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Allow',
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        InAppSelection.fingerPrintEnabled = true;
                        prefs.setBool('FingerprintEnabled', true);
                        Navigator.of(context).pop();
                      },
                    ),
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
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        // CommonFunction.changePasswordPopUp(context, "Need to change password");
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        InAppSelection.fingerPrintEnabled = false;
                        prefs.setBool('FingerprintEnabled', false);
                        Navigator.of(context).pop();

                      },
                    ),
                    TextButton(
                      child: Text(
                        'Allow',
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        InAppSelection.fingerPrintEnabled = true;
                        prefs.setBool('FingerprintEnabled', true);
                         Navigator.of(context).pop();
                        CommonFunction.changePasswordPopUp(context, "Need to change password");
                        // if(Dataconstants.mpinFlag==false){
                        //   CommonFunction.changePasswordPopUp(context, "Need to change password");
                        // }
                      },
                    ),
                  ],
                );
        }).then((value) {

      // if(Dataconstants.mpinFlag==false)
      // {
      //   CommonFunction.changePasswordPopUp(context, "Need to change password");
      // }

    });
  }

  Future<void> requestFingerprint() async {
    await showDialog<String>(
        context: context,
        barrierDismissible: false,
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
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        InAppSelection.fingerPrintEnabled = false;
                        prefs.setBool('FingerprintEnabled', false);
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Allow',
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        InAppSelection.fingerPrintEnabled = true;
                        prefs.setBool('FingerprintEnabled', true);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text(
                    'Hello' + Dataconstants.feUserID,
                    style: TextStyle(color: Utils.greyColor),
                  ),
                  content: Container(
                    // margin: EdgeInsets.all(10),
                    // padding: EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Utils.lightGreyColor,
                      )),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Click on the checkbox to register your device & biometric for 2FA authentication.',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  'Biometric & registered device',
                                ),
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                activeColor: Utils.primaryColor,
                                value: false,
                                shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    width: 250,
                                    height: 30,
                                    margin: EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Utils.primaryColor,
                                        ),
                                      ],
                                    ),
                                    child: Center(child: Text('CONTINUE', style: TextStyle(color: Colors.white))),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MobileNoScreen()), (Route<dynamic> route) => false);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 15),
                                          child: Row(
                                            children: [
                                              Text("Skip", style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                                            ],
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //content: ChangelogScreen(),
                  /*actions: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 250,
                              height: 30,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                              child: Center(child: Text('CONTINUE',style: TextStyle(color: Colors.white))),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    //print("Container clicked");
                                  },
                                  child:  Container(
                                    width: 50.0,
                                    //color: Colors.green,
                                    child:  Row(
                                      children: [
                                        Text("Skip",style: TextStyle(color: Colors.red,fontStyle: FontStyle.italic)),
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],*/
                );
        });
  }

  @override
  void onErrorReceived(String error, int type) {
    CommonFunction.showSnackBarKey(
      context: context,
      key: _scaffoldKey,
      text: error,
      color: Colors.black87,
    );
  }

  @override
  void onResponseReceieved(String resp, int type) {
    // CommonFunction.showSnackBarKey(
    //   context: context,
    //   key: _scaffoldKey,
    //   text: resp,
    //   color: Colors.black87,
    // );

    if (type == 3) {
      ////SETMPIN
      if (Dataconstants.isMpinEnabled) {
        // getUsernamePass();
        InAppSelection.fingerPrintEnabled = false;
        CommonFunction.setUsernamePass(userName: Dataconstants.feUserID, password: Dataconstants.feUserPassword1, accessPin: Dataconstants.confirmMPin, biometricCode: Dataconstants.biometriccode);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ValidateMPIN(
                  isSettingScreen: false,
                  userid: _loginUserIDController.text.trim(),
                  password: _loginUserPassController.text.trim(),
              registerBiometric: true,
                )));
        Dataconstants.isMpinEnabled = false;
      } else
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SetMpin(
                  isSettingScreen: false,
                  userid: _loginUserIDController.text.trim(),
                  password: _loginUserPassController.text.trim(),
                )));
      // //SETMPIN

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (_) => MainScreen(
      //       changePassword: false,
      //       message: 'SUCCESS',
      //     ),
      //   ),
      // );

    }
    if (type == 2) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainScreen(
            changePassword: true,
            message: resp,
          ),
        ), (route) => false
      );
    }

    Utils.saveSharedPreferences("LoggedInApp", true, "Bool");
    /* Getting last login time and date to show in profile screen */
    getLastTimeLogin();
  }

  // void connectITS() {
  //   if (ConnectionStatusSingleton.getInstance().hasConnection) {
  //     if (!Dataconstants.itsClient.isConnected) {
  //       Dataconstants.itsClient.mResponseListener = this;
  //       Dataconstants.itsClient.connect();
  //     }
  //   } else
  //     CommonFunction.showDialogInternet(context);
  // }

  getLastTimeLogin() async {
    DateTime now = new DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var formatterDate = new DateFormat('dd-MM-yyyy');
    Dataconstants.getLastDateLogin = formatterDate.format(now);
    var formatterTime = new DateFormat('HH:mm:ss');
    Dataconstants.getLastTimeLogin = formatterTime.format(now);
    // //print(Dataconstants.getLastDateLogin);
    // //print(Dataconstants.getLastTimeLogin);
    prefs.setString('getLastTimeLogin', Dataconstants.getLastTimeLogin);
    prefs.setString('getLastDateLogin', Dataconstants.getLastDateLogin);
  }

  void getIPDetails() async {
    /* BOB requirement */
    // if (Platform.isIOS) {
    //   Dataconstants.feIP = await FlutterIp.externalIP;
    // } else
    //   Dataconstants.feIP = await GetIp.ipAddress;

    Dataconstants.feIP = await CommonFunction.getIp();

    CommonFunction.getVersionNumber().then((value) => Dataconstants.fileVersion = value.trim());
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleDob() {
    setState(() {
      _obscureDOB = !_obscureDOB;
    });
  }
}
