import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/connectors/v1.dart';
import 'package:markets/util/Dataconstants.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import 'Login.dart';
import 'OTPscreen.dart';

class MobileNoScreen extends StatefulWidget {
  const MobileNoScreen({Key key}) : super(key: key);

  @override
  State<MobileNoScreen> createState() => _MobileNoScreenState();
}

class _MobileNoScreenState extends State<MobileNoScreen> {
  final FocusNode myFocusNodeUserIDLogin = FocusNode();
  TextEditingController _loginUserIDController = TextEditingController();
  bool isValidMobile = false;

  @override
  void initState() {
    var params = {
      "screen": "mobile_Screen",
    };
    CommonFunction.JMFirebaseLogging("Screen_Tracking", params);
    Utils.saveSharedPreferences("LoggedInApp", false, "Bool");
    super.initState();
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
              SizedBox(
                height: 20,
              ),
              Text(
                "Let's Get Started",
                style: Utils.fonts(size: 26.0),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "One time password will be sent to verify your mobile number",
                style: Utils.fonts(size: 16.0, color: Utils.greyColor),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Enter Mobile Number",
                style: Utils.fonts(size: 12.0, color: Utils.greyColor),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                cursorColor: theme.primaryColor,
                maxLength: 10,
                controller: _loginUserIDController,
                focusNode: myFocusNodeUserIDLogin,
                enableInteractiveSelection: true,
                showCursor: true,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length > 9) {
                    setState(() {
                      isValidMobile = true;
                    });
                  } else {
                    setState(() {
                      isValidMobile = false;
                    });
                  }
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                style: TextStyle(
                  fontSize: 18.0,
                ),
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
                  labelText: "Mobile No",
                  prefixIcon: Icon(
                    Icons.phone_android_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: isValidMobile
                        ? () async {
                            Dataconstants.isVerifyLoginOtp = false;
                            String deviceName, osName, devicemodel;
                            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

                            if (_loginUserIDController.text.length < 10) {
                              CommonFunction.showBasicToast("Please Enter 10 Digit No");
                              return;
                            }

                            var uniqueId = "";

                            if (Platform.isAndroid) {
                              AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                              uniqueId = androidInfo.id;
                              //print('Running on ${androidInfo.model}');
                            } else {
                              IosDeviceInfo iosDevice = await deviceInfo.iosInfo;
                              uniqueId = iosDevice.identifierForVendor;
                            }

                            if (Platform.isIOS) {
                              IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                              //print("${iosInfo.name}");
                              deviceName = iosInfo.name;
                              osName = iosInfo.systemVersion;
                              devicemodel = iosInfo.model;
                            } else {
                              AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                              //print("${androidInfo.brand}");
                              deviceName = androidInfo.brand.replaceAll(' ', '');
                              osName = 'Android${androidInfo.version.release}';
                              devicemodel = androidInfo.model;
                            }

                            // var requestJson = {"MobileNo": _loginUserIDController.text.toString(), "deviceId": uniqueId};

                            var requestJson = {
                              "MobileNo": _loginUserIDController.text.toString(),
                              "Otp": "",
                              "DeviceId": uniqueId,
                              "Source": "MOB"
                            };

                            //print(requestJson);

                            // var response = await CommonFunction.generateOtp(requestJson);

                            var response = await CommonFunction.getMappingID(requestJson);

                            var responseJson = json.decode(response.toString());
                            if (responseJson['status'] == false)
                              CommonFunction.showBasicToastForJm(responseJson['emsg']);
                            else
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(_loginUserIDController.text, true)));

                            CommonFunction.firebaseEvent(
                              clientCode: "dummy",
                              device_manufacturer: deviceName,
                              device_model: devicemodel,
                              eventId: "4.0.2.0.0",
                              eventLocation: "footer",
                              eventMetaData: "dummy",
                              eventName: "generate_otp",
                              os_version: osName,
                              location: "dummy",
                              eventType: "Click",
                              sessionId: "dummy",
                              platform: Platform.isAndroid ? 'Android' : 'iOS',
                              screenName: "try blink trade",
                              serverTimeStamp: DateTime.now().toString(),
                              source_metadata: "dummy",
                              subType: "button",
                            );
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                      child: Text(
                        "GET OTP",
                        style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: isValidMobile ? MaterialStateProperty.all<Color>(Utils.primaryColor) : MaterialStateProperty.all<Color>(Utils.primaryColor.withOpacity(0.2)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )))),
                // ElevatedButton(
                //     onPressed: () async {
                //       if (_loginUserIDController.text.length < 10) {
                //         CommonFunction.showBasicToast(
                //             "Please Enter 10 Digit No");
                //         return;
                //       }
                //
                //       var uniqueId = "";
                //       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                //       if (Platform.isAndroid) {
                //         AndroidDeviceInfo androidInfo =
                //             await deviceInfo.androidInfo;
                //         uniqueId = androidInfo.id;
                //         //print('Running on ${androidInfo.model}');
                //       } else {
                //         IosDeviceInfo iosDevice = await deviceInfo.iosInfo;
                //         uniqueId = iosDevice.identifierForVendor;
                //       }
                //
                //       var requestJson = {
                //         "MobileNo": _loginUserIDController.text.toString(),
                //         "deviceId": uniqueId
                //       };
                //
                //       //print(requestJson);
                //
                //       var response =
                //           await CommonFunction.generateOtp(requestJson);
                //       if (response.toString().contains("Success"))
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) =>
                //                     OtpScreen(_loginUserIDController.text)));
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //           vertical: 15.0, horizontal: 50.0),
                //       child: Text(
                //         "GET OTP",
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
                height: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Dataconstants.isVerifyLoginOtp = true;
                    Dataconstants.login2FAOtp = '';
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Login Via Client ID",
                    style: Utils.fonts(size: 12.0, color: Utils.primaryColor, textDecoration: TextDecoration.underline, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 30,
              // ),
              // Center(
              //   child: ElevatedButton(
              //       onPressed: () {
              //         Dataconstants.isVerifyLoginOtp = true;
              //         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
              //       },
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
              //         child: Text(
              //           "LOGIN",
              //           style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
              //         ),
              //       ),
              //       style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
              //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(50.0),
              //           )))),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  setMobileNo(number) {
    if (_loginUserIDController.text.length == 9) {
      setState(() {
        _loginUserIDController.text += number;
        isValidMobile = true;
      });
    } else if (_loginUserIDController.text.length < 10)
      setState(() {
        _loginUserIDController.text += number;
        isValidMobile = false;
      });
    else
      setState(() {
        isValidMobile = true;
      });
  }

  removeMobileNo() {
    if (_loginUserIDController.text.isNotEmpty)
      setState(() {
        _loginUserIDController.text = _loginUserIDController.text.substring(0, _loginUserIDController.text.length - 1);
        isValidMobile = false;
      });
  }
}
