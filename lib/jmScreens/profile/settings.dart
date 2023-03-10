import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/jmScreens/profile/changeMPin.dart';
import 'package:markets/util/InAppSelections.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../CommonWidgets/switch.dart';
import '../login/ChangePassword.dart';
import '../login/SetMpin.dart';

class Settings extends StatefulWidget {
  final bool isComingFromMore;

  Settings(this.isComingFromMore);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _fingerPrintController = ValueNotifier<bool>(false);
  final _patternController = ValueNotifier<bool>(false);
  final _saveDataController = ValueNotifier<bool>(false);
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      prefs =  await SharedPreferences.getInstance();
    });
    _fingerPrintController.addListener(() {
      prefs.setBool('FingerprintEnabled', _fingerPrintController.value);
      InAppSelection.fingerPrintEnabled = _fingerPrintController.value;
      setState(() {});
    });
    _patternController.addListener(() {
      setState(() {});
    });
    _saveDataController.addListener(() {
      setState(() {});
    });


    if(InAppSelection.fingerPrintEnabled == true){
      _fingerPrintController.value = true;
    }

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.isComingFromMore ? AppBar(
        bottomOpacity: 2,
        backgroundColor: Utils.whiteColor,
        title: Text(
          "Settings",
          style: Utils.fonts(
              size: 18.0,
              fontWeight: FontWeight.w600,
              color: Utils.blackColor),
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
          GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus.unfocus();
                CommonFunction.marketWatchBottomSheet(context);
                // InAppSelection.mainScreenIndex = 1;
                // Navigator.of(context)
                //     .pushReplacement(MaterialPageRoute(
                //         builder: (_) => MainScreen(
                //               toChangeTab: false,
                //             )));
              },
              child:
              SvgPicture.asset('assets/appImages/tranding.svg')),
          SizedBox(
            width: 15,
          )
        ],
      ) : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                settingTile(title: 'Change Password', showToggle: false),
                const SizedBox(
                  height: 10,
                ),
                settingTile(title: 'Reset 2FA', showToggle: false),
                const SizedBox(
                  height: 10,
                ),
                settingTile(title: 'Change MPIN', showToggle: false),
                const SizedBox(
                  height: 10,
                ),
                settingTile(
                    title: 'Fingerprint / Facial Login',
                    showToggle: true,
                    switchController: _fingerPrintController),
                const SizedBox(
                  height: 10,
                ),
                settingTile(
                    title: 'Pattern Lock',
                    showToggle: true,
                    switchController: _patternController),
                const SizedBox(
                  height: 10,
                ),
                settingTile(title: 'Order Settings', showToggle: false),
                const SizedBox(
                  height: 10,
                ),
                settingTile(
                    title: 'Save Data Plan',
                    showToggle: true,
                    switchController: _saveDataController),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(Dataconstants.loginData.data.userMsg,
                        style: Utils.fonts(
                            size: 11.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget settingTile({String title, bool showToggle, var switchController}) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            if(title == 'Reset 2FA') {
              CommonFunction.firebaseEvent(
                clientCode: "dummy",
                device_manufacturer: Dataconstants.deviceName,
                device_model: Dataconstants.devicemodel,
                eventId: "5.0.5.0.0",
                eventLocation: "footer",
                eventMetaData: "dummy",
                eventName: "reset_2fa",
                os_version: Dataconstants.osName,
                location: "dummy",
                eventType:"Click",
                sessionId: "dummy",
                platform: Platform.isAndroid ? 'Android' : 'iOS',
                screenName: "having trouble signing in",
                serverTimeStamp: DateTime.now().toString(),
                source_metadata: "dummy",
                subType: "button",
              );
            }
            if(title == 'Order Settings') {
              CommonFunction.bottomSheet(context, title);
            }
            if(title == 'Change MPIN') {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChangeMPin()));
            }
            if(title == 'Change Password') {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          ChangePassword(true)));
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: Utils.fonts(
                      size: 14.0,
                      fontWeight: FontWeight.w400,
                    )),
                showToggle
                    ? ToggleSwitch(
                  switchController: switchController,
                  isBorder: false,
                  activeColor: Utils.primaryColor,
                  inactiveColor: Utils.lightGreyColor.withOpacity(0.2),
                  thumbColor: Utils.greyColor,
                )
                    : SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
              ],
            ),
          ),
        ),
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () {
        //     if(title == 'Order Settings') {
        //       CommonFunction.bottomSheet(context, title);
        //     }
        //     if(title == 'Change MPIN') {
        //       Navigator.of(context)
        //           .push(MaterialPageRoute(builder: (context) => SetMpin(true)));
        //     }
        //     if(title == 'Change Password') {
        //       Navigator.of(context).push(
        //           MaterialPageRoute(
        //               builder: (context) =>
        //                   ChangePassword(true)));
        //     }
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 10),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(title,
        //             style: Utils.fonts(
        //               size: 14.0,
        //               fontWeight: FontWeight.w400,
        //             )),
        //         showToggle
        //             ? ToggleSwitch(
        //                 switchController: switchController,
        //                 isBorder: false,
        //                 activeColor: Utils.primaryColor,
        //                 inactiveColor: Utils.lightGreyColor.withOpacity(0.2),
        //                 thumbColor: Utils.greyColor,
        //               )
        //             : SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
        //       ],
        //     ),
        //   ),
        // ),
        if(title == 'Save Data Plan')
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text('Use Data while using the app',
                  style: Utils.fonts(
                    size: 11.0,
                    fontWeight: FontWeight.w400,
                    color: Utils.greyColor
                  )),
            ),
          ),
        const SizedBox(
          height: 20,
        ),
        Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
