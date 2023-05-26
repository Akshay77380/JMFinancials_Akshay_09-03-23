import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:markets/jmScreens/login/Login.dart';
import 'package:markets/jmScreens/login/MultipleAccount.dart';
import 'package:markets/util/InAppSelections.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// import 'package:sms_autofill/sms_autofill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/jmModel/login.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'ChangePassword.dart';
import 'GuestOpenAccount.dart';

class OtpScreen extends StatefulWidget {
  var mobileNo;
  var isComingFromMobileScreen;


  OtpScreen(this.mobileNo, this.isComingFromMobileScreen ,);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FocusNode myFocusNodeUserIDLogin = FocusNode();
  TextEditingController _loginUserIDController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  var currentText;
  bool isVerifiedEnable = false;
  Timer timer;
  String _comingSms = 'Unknown';
  int _start = 60;
  bool resendOTP = false;
  bool submitMobileNo = false;

  @override
  void initState() {
    startTimer();
    var params = {
      "screen": "OTP_Screen",
    };
    CommonFunction.JMFirebaseLogging("Screen_Tracking", params);
    super.initState();

    // SmsAutoFill().listenForCode();
    //
    // _registerCallback();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initSmsListener();
    });
  }

  Future<void> initSmsListener() async {
    String comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
      if (!mounted) return;
      setState(() {
        _comingSms = comingSms;
        _comingSms.split(", ")[1];
        print("====>Message: ${_comingSms}");
        print("${_comingSms}");
        _loginUserIDController.text = _comingSms.split(", ")[1][0] +
            _comingSms.split(", ")[1][1] +
            _comingSms.split(", ")[1][2] +
            _comingSms.split(", ")[1][3] +
            _comingSms.split(", ")[1][4] +
            _comingSms.split(", ")[1][5]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
      });
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    } catch (e, s) {
      print(e);
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _start--;
        });
        if (_start == 0) {
          setState(() {
            timer.cancel();
            resendOTP = true;
            submitMobileNo = false;
            _start = 30;
          });
        } else {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back)),
              SizedBox(
                height: 20,
              ),
              Text(
                "Verify Mobile",
                style: Utils.fonts(size: 26.0),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Enter OTP sent on ${widget.mobileNo.toString().replaceRange(4, 8, "XXXX")}",
                style: Utils.fonts(size: 16.0, color: Utils.greyColor),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Enter OTP",
                style: Utils.fonts(size: 12.0, color: Utils.greyColor),
              ),
              SizedBox(
                height: 20,
              ),
              PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: theme.textTheme.bodyText1.color,
                  fontWeight: FontWeight.bold,
                ),
                hapticFeedbackTypes: HapticFeedbackTypes.medium,
                textStyle: Utils.fonts(size: 16.0),
                length: 6,
                obscureText: true,
                // obscuringCharacter: '*',
                blinkWhenObscuring: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10.0),
                  borderWidth: 2.0,
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Color(0xff969ba1),
                  activeColor: Color(0xff969ba1),
                  inactiveColor: Colors.grey[400],
                  selectedColor: Color(0xff969ba1),
                ),
                cursorColor: Utils.blackColor,
                animationDuration: Duration(milliseconds: 300),
                errorAnimationController: errorController,
                controller: _loginUserIDController,
                keyboardType: TextInputType.number,
                onCompleted: (v) async {
                },
                onChanged: (value) {
                  //print(value);
                  if (value.length == 6) {
                    setState(() {
                      currentText = value;
                      isVerifiedEnable = true;
                    });
                  } else {
                    setState(() {
                      isVerifiedEnable = false;
                    });
                  }
                },
                beforeTextPaste: (text) {
                  // //print("Allowing to paste $text");
                  return true;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: isVerifiedEnable
                        ? () async {
                            if (Dataconstants.unblockUser) {
                              var requestJson = {"LOGINID": Dataconstants.unblockId, "Otp": _loginUserIDController.text};

                              var response = await CommonFunction.unblockUser(requestJson);

                              var jsons = json.decode(response);

                              if (jsons['status'] == false)
                                CommonFunction.showBasicToast(jsons["emsg"].toString());
                              else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                Dataconstants.unblockUser = false;
                                Dataconstants.unblockId = "";
                              }


                            } else if (widget.isComingFromMobileScreen && Dataconstants.unblockUser == false) {
                              // var requestJson2 = {"MobileNo": widget.mobileNo, "Otp": _loginUserIDController.text.toString()};

                              var requestJson2 = {"MobileNo": widget.mobileNo, "Otp": _loginUserIDController.text.toString(), "DeviceId": "DEV-PC", "Source": "MOB"};

                              var response2 = await CommonFunction.getMappingID(requestJson2);

                              // //print(response2.toString());
                              var resdata = json.decode(response2);
                              if (resdata['status'] == false) {
                                CommonFunction.showBasicToast(resdata["emsg"].toString());
                              } else {
                                Dataconstants.multipleMapIDs = resdata['data'];
                                try {
                                  Dataconstants.selectedID = Dataconstants.multipleMapIDs[0];
                                } catch (e) {}
                                Dataconstants.login2FAOtp = _loginUserIDController.text.toString();
                                if (Dataconstants.selectedID == "") {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OpenGuestAccount()), (route) => false);
                                } else if (Dataconstants.multipleMapIDs.length > 1) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MultipleAccounts()));
                                } else if (Dataconstants.multipleMapIDs.length == 0) {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OpenGuestAccount()), (route) => false);
                                } else {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                                }
                              }
                            } else if (Dataconstants.forgotPass) {
                              var requestJson = {
                                "LOGINID": Dataconstants.accountDetails[0],
                                "pannumber": Dataconstants.accountDetails[1],
                                "Email": Dataconstants.accountDetails[3],
                                "otp": _loginUserIDController.text.toString(),
                              };
                              var responses = await CommonFunction.forgotPassword(requestJson);
                              var jsons = json.decode(responses);
                              if (jsons['status'] == false)
                                CommonFunction.showBasicToast(jsons["emsg"].toString());
                              else
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChangePassword(
                                              false,
                                              otp: _loginUserIDController.text.toString(),
                                            )));
                              Dataconstants.forgotPass = false;
                            } else if (Dataconstants.login2FAOtp == '') {
                              Dataconstants.login2FAOtp = _loginUserIDController.text.toString();
                              var requestJson = {
                                "LoginID": Dataconstants.feUserID,
                                "Password": Dataconstants.feUserPassword1,
                                "Dob": "01011990",
                                "Pan": "",
                                "ApkVersion": "1.0.2",
                                "Source": "MOB",
                                "LoginDevice": Platform.isAndroid ? 'Android' : 'iOS',
                                "imei": Dataconstants.feUserDeviceID,
                                "DevId": Dataconstants.feUserDeviceID,
                                "FactorTwo": Dataconstants.login2FAOtp,
                              };
                              var responses = await CommonFunction.login(requestJson);
                              try {
                                var jsons = json.decode(responses);
                                if (jsons["status"] == false) {
                                  CommonFunction.showBasicToast(jsons["emsg"].toString());
                                } else {
                                  Dataconstants.loginData = LoginFromJson(responses);
                                  Dataconstants.biometriccode = jsons['data']['biometric'];
                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                  pref.setString("isPoa", jsons["POA_flag"]);
                                  Dataconstants.isPoa = await pref.get('isPoa');
                                  print(pref.getString('isPoa'));
                                  Dataconstants.isPoa = pref.getString('isPoa');
                                  Dataconstants.isMpinEnabled = Dataconstants.resetMPin == true ? false : jsons['data']['isMpinEnabled'];
                                  Dataconstants.itsClient.onLoggedIn(
                                    indicator: 1,
                                    message: "SUCCESS",
                                  );
                                }
                              } catch (e) {
                                var jsons = json.decode(responses);
                                var params = {
                                  "Login": "Failure",
                                };
                                CommonFunction.JMFirebaseLogging("Login_Tracking", params);
                                CommonFunction.showBasicToast(jsons["data"].toString());
                              }
                              Dataconstants.login2FAOtp = '';
                            }
                            // var responseJson2 = json.decode(response2.toString());
                            // if(responseJson2['status' == false]) {
                            //   CommonFunction.showBasicToast(responseJson2['data']);
                            // }
                            // else {
                            //   List list = responseJson2["data"];
                            //   for(int i=0;i<list.length;i++){
                            //     //print(list[i]);
                            //   }
                            // }

                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => OpenGuestAccount()),
                            //     (route) => false);
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                      child: Text(
                        "VERIFY OTP",
                        style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: isVerifiedEnable ? MaterialStateProperty.all<Color>(Utils.primaryColor) : MaterialStateProperty.all<Color>(Utils.primaryColor.withOpacity(0.2)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )))),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  var uniqueId = "";
                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                  if (Platform.isAndroid) {
                    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                    uniqueId = androidInfo.id;
                    //print('Running on ${androidInfo.model}');
                  } else {
                    IosDeviceInfo iosDevice = await deviceInfo.iosInfo;
                    uniqueId = iosDevice.identifierForVendor;
                  }
                  var requestJson = {"MobileNo": widget.mobileNo, "UserOTP": uniqueId};
                  var response = await CommonFunction.generateOtp(requestJson);
                  var responseJson = json.decode(response.toString());
                  if (responseJson['status'] == false) CommonFunction.showBasicToastForJm(responseJson['emsg']);
                },
                child: Center(
                  child: Text(
                    "Resend OTP",
                    style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setMobileNo(number) {
    if (_loginUserIDController.text.length == 5) {
      setState(() {
        _loginUserIDController.text += number;
        isVerifiedEnable = true;
      });
    } else if (_loginUserIDController.text.length < 6)
      setState(() {
        _loginUserIDController.text += number;
        isVerifiedEnable = false;
      });
  }

  removeMobileNo() {
    if (_loginUserIDController.text.isNotEmpty)
      setState(() {
        _loginUserIDController.text = _loginUserIDController.text.substring(0, _loginUserIDController.text.length - 1);
        isVerifiedEnable = false;
      });
  }
}
