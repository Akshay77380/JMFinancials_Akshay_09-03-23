import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class ChangeMPin extends StatefulWidget {
  @override
  State<ChangeMPin> createState() => _ChangeMPinState();
}

class _ChangeMPinState extends State<ChangeMPin> with TickerProviderStateMixin {
  StreamController<ErrorAnimationType> errorController;
  AnimationController _controller, _newmpincontroller, _confirmnewmpincontroller;
  TextEditingController _mpinController = TextEditingController();
  TextEditingController _newmpinTextController = TextEditingController();
  TextEditingController _confirmnewmpinTextController = TextEditingController();
  String mpinText = '', confirmPinText = '', newmpinText = '', confirmNewmpinText = '';
  var currentText = '', newCurrentText = '', confirnNewCurrentText = '';
  bool isMPinMatch = false;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _newmpincontroller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _confirmnewmpincontroller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
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
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Enter old MPIN",
                style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
              ),
              SizedBox(
                height: 10,
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
                  enablePinAutofill: false,
                  errorTextSpace: 2,
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
                    activeFillColor: Color(0xff969ba1),
                    activeColor: Color(0xff969ba1),
                    inactiveColor: Colors.grey[400],
                    selectedColor: Color(0xff969ba1),
                  ),
                  cursorColor: Utils.blackColor,
                  animationDuration: Duration(milliseconds: 300),
                  controller: _mpinController,
                  keyboardType: TextInputType.number,
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
              SizedBox(
                height: 40,
              ),
              Text(
                "Enter new MPIN",
                style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
              ),
              SizedBox(
                height: 10,
              ),
              AnimatedBuilder(
                animation: _newmpincontroller,
                builder: (BuildContext context, Widget child) {
                  final dx = sin(_newmpincontroller.value * 2 * pi) * 4;
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
                  enablePinAutofill: false,
                  errorTextSpace: 2,
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
                    errorBorderColor: newmpinText.trim() != confirmNewmpinText.trim() ? Colors.red : Colors.grey,
                    activeFillColor: Color(0xff969ba1),
                    activeColor: Color(0xff969ba1),
                    inactiveColor: Colors.grey[400],
                    selectedColor: Color(0xff969ba1),
                  ),
                  cursorColor: Utils.blackColor,
                  animationDuration: Duration(milliseconds: 300),
                  errorAnimationController: errorController,
                  controller: _newmpinTextController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) async {
                    newmpinText = _newmpinTextController.text;
                  },
                  onChanged: (value) {
                    // //print(value);
                    setState(() {
                      newCurrentText = value;
                      if (confirnNewCurrentText.trim() != newCurrentText.trim())
                        isMPinMatch = false;
                      else
                        isMPinMatch = true;
                    });
                  },
                  beforeTextPaste: (text) {
                    // //print("Allowing to paste $text");
                    return true;
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Text(
                    "Confirm new MPIN",
                    style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (isMPinMatch) SvgPicture.asset('assets/appImages/checkbox_circle_green.svg'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              AnimatedBuilder(
                animation: _confirmnewmpincontroller,
                builder: (BuildContext context, Widget child) {
                  final dx = sin(_confirmnewmpincontroller.value * 2 * pi) * 4;
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
                    errorBorderColor: confirmNewmpinText.trim() != newmpinText.trim() ? Colors.red : Colors.grey,
                    activeFillColor: Color(0xff969ba1),
                    activeColor: Color(0xff969ba1),
                    inactiveColor: Colors.grey[400],
                    selectedColor: Color(0xff969ba1),
                  ),
                  cursorColor: Utils.blackColor,
                  animationDuration: Duration(milliseconds: 300),
                  errorAnimationController: errorController,
                  controller: _confirmnewmpinTextController,
                  keyboardType: TextInputType.number,
                  onCompleted: (v) async {
                    confirmNewmpinText = _confirmnewmpinTextController.text;
                  },
                  onChanged: (value) {
                    // //print(value);
                    setState(() {
                      confirnNewCurrentText = value;
                      if (newmpinText.trim() != confirnNewCurrentText.trim())
                        isMPinMatch = false;
                      else
                        isMPinMatch = true;
                    });
                  },
                  beforeTextPaste: (text) {
                    // //print("Allowing to paste $text");
                    return true;
                  },
                ),
              ),
              Spacer(),
              Center(
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                      child: Text(
                        "Set MPIN",
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
                      if (_mpinController.text == '' || _mpinController.text.isEmpty || _mpinController.text == null) {
                        CommonFunction.showSnackBar(context: context, text: 'Please Enter Old MPIN', color: Utils.brightRedColor);
                        return;
                      }
                      if (_newmpinTextController.text == '' || _newmpinTextController.text.isEmpty || _newmpinTextController.text == null) {
                        CommonFunction.showSnackBar(context: context, text: 'Please Enter New MPIN', color: Utils.brightRedColor);
                        return;
                      }
                      if (_confirmnewmpinTextController.text == '' || _confirmnewmpinTextController.text.isEmpty || _confirmnewmpinTextController.text == null) {
                        CommonFunction.showSnackBar(context: context, text: 'Please Enter Confirm MPIN', color: Utils.brightRedColor);
                        return;
                      }
                      if (_mpinController.text.trim() != Dataconstants.confirmMPin.trim()) {
                        CommonFunction.showSnackBar(context: context, text: 'Incorrect Old MPIN', color: Utils.brightRedColor);
                        return;
                      }
                      if (newmpinText.trim() == _mpinController.text.trim()) {
                        CommonFunction.showSnackBar(context: context, text: 'Old MPIN and New MPIN cannot be same', color: Utils.brightRedColor);
                        return;
                      }
                      if (newmpinText.trim() != confirmNewmpinText.trim()) {
                        CommonFunction.showSnackBar(context: context, text: 'New MPIN and Confirm MPIN does not Match', color: Utils.brightRedColor);
                        return;
                      }
                      var requestJson = {
                        "logindevice": Platform.isAndroid ? 'Android' : 'iOS',
                        "deviceid": Dataconstants.feUserDeviceID,
                        "userid": Dataconstants.feUserID,
                        "code": Dataconstants.biometriccode,
                        "mpin": confirmNewmpinText,
                        "source": "MOB",
                        "ApkVersion": "1.0.0"
                      };
                      var response = await CommonFunction.setMpin(requestJson);
                      var resdata = json.decode(response.toString());
                      var value = resdata['status'];
                      if (value) {
                        Dataconstants.confirmMPin = confirmNewmpinText;
                        Dataconstants.changeMPin = true;
                        Navigator.pop(context);
                        CommonFunction.bottomSheet(context, "SETMPIN");
                      } else {
                        CommonFunction.showBasicToast(resdata["emsg"].toString());
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
