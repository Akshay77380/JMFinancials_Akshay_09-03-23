import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';
import 'LimitScreen.dart';
import 'accountDetails.dart';
import 'preferedSector.dart';
import 'settings.dart';
import 'shareFeedback.dart';

class ProfileScreenJm extends StatefulWidget {
  final Stream<bool> stream;

  ProfileScreenJm(this.stream);

  @override
  State<ProfileScreenJm> createState() => _ProfileScreenJmState();
}

class _ProfileScreenJmState extends State<ProfileScreenJm> {
  var selectedChart = chartValue.intellectChart;
  colorMode selectColorMode;
  SharedPreferences prefs;

  // chartValue selectedchart = chartValue.chartIq;
  void initState() {

    if (ThemeConstants.themeMode.value == ThemeMode.light)
      selectColorMode = colorMode.light;
    else
      selectColorMode = colorMode.dark;
    initPreference();
    widget.stream.listen((seconds) {
      _updateSeconds();
    });
    super.initState();
    CommonFunction.getProfileData();
  }

  void _updateSeconds() {
    if (mounted) setState(() {});
  }

  void initPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  void saveTheme() {
    int themeVal;
    if (ThemeConstants.themeMode.value == ThemeMode.light) {
      themeVal = 0;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    } else if (ThemeConstants.themeMode.value == ThemeMode.dark &&
        ThemeConstants.amoledThemeMode.value) {
      themeVal = 2;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      themeVal = 1;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    }
    prefs.setInt('themeMode', themeVal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Dataconstants.profileSelectedIndex == 1
          ? AppBar(
              bottomOpacity: 2,
              title: Text(
                "Account Details",
                style: Utils.fonts(
                    size: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Utils.blackColor),
              ),
              elevation: 1,
              leading: InkWell(
                onTap: () {
                  // Navigator.pop(context);
                  setState(() {
                    Dataconstants.profileSelectedIndex = 0;
                  });
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
                    },
                    child: SvgPicture.asset('assets/appImages/tranding.svg')),
                SizedBox(
                  width: 15,
                )
              ],
            )
          : Dataconstants.profileSelectedIndex == 2
              ? AppBar(
                  bottomOpacity: 2,
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
                      setState(() {
                        Dataconstants.profileSelectedIndex = 0;
                      });
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
                )
              : Dataconstants.profileSelectedIndex == 3
                  ? AppBar(
                      bottomOpacity: 2,
                      title: Text(
                        "Share Feedback",
                        style: Utils.fonts(
                            size: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Utils.blackColor),
                      ),
                      elevation: 1,
                      leading: InkWell(
                        onTap: () {
                          setState(() {
                            Dataconstants.profileSelectedIndex = 0;
                          });
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
                              // Navigator.of(context).pushReplacement(MaterialPageRoute(
                              //     builder: (_) => MainScreen(
                              //           toChangeTab: false,
                              //         )));
                            },
                            child: SvgPicture.asset(
                                'assets/appImages/tranding.svg')),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    )
                  : AppBar(
                      // automaticallyImplyLeading: false,
                      // bottom: 2,
                      bottomOpacity: 2,
                      leading: InkWell(
                        onTap: () {
                          setState(() {
                            Dataconstants.moreSelectedText = 'more';
                            Dataconstants.pageController.add(true);
                            Navigator.of(context).pop();
                          });
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Utils.greyColor,
                        ),
                      ),
                      title: Text(
                        "Profile",
                        style: Utils.fonts(
                            size: 18.0,
                            fontWeight: FontWeight.w400,
                            color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor
                        ),
                      ),
                      elevation: 1,
                    ),
      body: Dataconstants.profileSelectedIndex == 1
          ? AccountDetails()
          : Dataconstants.profileSelectedIndex == 2
              ? Settings(false)
              : Dataconstants.profileSelectedIndex == 3
                  ? ShareFeedback()
                  : SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              // width: 360,
                              height: 190,
                              decoration: BoxDecoration(
                                  // border: Border.all(
                                  //   color: Colors.
                                  //     red
                                  // )
                                  ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        child: Image.asset(
                                            'assets/images/logo/jm-primary.png'),
                                      ),

                                      Text(
                                        InAppSelection.profileData['name'] ??
                                            "",
                                        style: Utils.fonts(
                                            size: 18.0,
                                            fontWeight: FontWeight.w400),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/appImages/message.svg'),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      Text(
                                        InAppSelection.profileData['email'],
                                        style: Utils.fonts(
                                            size: 14.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/appImages/ac_details.svg'),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      Text(
                                        InAppSelection
                                                .profileData['mobileno'] ??
                                            "",
                                        style: Utils.fonts(
                                            size: 14.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        Dataconstants.profileSelectedIndex = 1;
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => AccountDetails()));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/appImages/ac_details.svg'),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                        Text(
                                          "Account Details",
                                          style: Utils.fonts(
                                              size: 14.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/appImages/arrow_right_circle.svg'),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Utils.lightGreyColor,
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'User Settings',
                                            style: Utils.fonts(
                                                size: 11.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                              'assets/appImages/chart.svg'),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                          Text(
                                            "Chart",
                                            style: Utils.fonts(
                                                size: 14.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedChart = chartValue.intellectChart;
                                                // selectedChart =
                                                //     selectedChart == chartValue.chartIq
                                                //         ? chartValue.tradingView
                                                //         : chartValue.chartIq;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                  child: Radio(
                                                      value: chartValue.intellectChart,
                                                      groupValue: selectedChart,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedChart = value;
                                                        });
                                                      }),
                                                ),
                                                // SvgPicture.asset('assets/appImages/chart_iq.svg', color: Colors.blueAccent,),
                                                // Image.asset(
                                                //     'assets/appImages/chart_iq.png'),
                                                Text("Intellect Charts",
                                                    style: Utils.fonts(
                                                        size: 12.0,
                                                        fontWeight: FontWeight.w300)),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     setState(() {
                                          //       selectedChart =
                                          //           chartValue.chartIq;
                                          //       // selectedChart =
                                          //       //     selectedChart == chartValue.chartIq
                                          //       //         ? chartValue.tradingView
                                          //       //         : chartValue.chartIq;
                                          //     });
                                          //   },
                                          //   child: Row(
                                          //     children: [
                                          //       SizedBox(
                                          //         width: 30,
                                          //         child: Radio(
                                          //             value: chartValue.chartIq,
                                          //             groupValue: selectedChart,
                                          //             onChanged: (value) {
                                          //               setState(() {
                                          //                 selectedChart = value;
                                          //               });
                                          //             }),
                                          //       ),
                                          //       // SvgPicture.asset('assets/appImages/chart_iq.svg', color: Colors.blueAccent,),
                                          //       Image.asset(
                                          //           'assets/appImages/chart_iq.png'),
                                          //       // Text("Chart Iq",
                                          //       //     style: Utils.fonts(
                                          //       //         size: 12.0,
                                          //       //         color: Utils.greyColor,
                                          //       //         fontWeight: FontWeight.w300)),
                                          //     ],
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     setState(() {
                                          //       selectedChart =
                                          //           chartValue.tradingView;
                                          //       // selectedChart =
                                          //       //     selectedChart == chartValue.chartIq
                                          //       //         ? chartValue.tradingView
                                          //       //         : chartValue.chartIq;
                                          //     });
                                          //   },
                                          //   child: Row(
                                          //     children: [
                                          //       SizedBox(
                                          //         width: 30,
                                          //         child: Radio(
                                          //             value: chartValue
                                          //                 .tradingView,
                                          //             groupValue: selectedChart,
                                          //             onChanged: (value) {
                                          //               setState(() {
                                          //                 selectedChart = value;
                                          //               });
                                          //             }),
                                          //       ),
                                          //       Image.asset(
                                          //           'assets/appImages/trading_view.png'),
                                          //       // Text("Trading View",
                                          //       //     style: Utils.fonts(
                                          //       //         size: 12.0,
                                          //       //         color: Utils.greyColor,
                                          //       //         fontWeight: FontWeight.w300)),
                                          //     ],
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      profileTile(context, 'colormode.svg',
                                          'Color Mode'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      profileTile(
                                          context,
                                          'preferredSector.svg',
                                          'Preferred Sector'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      profileTile(
                                          context, 'chart.svg', 'Notification'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      profileTile(
                                          context, 'setting.svg', 'Settings'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Utils.lightGreyColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'More',
                                            style: Utils.fonts(
                                                size: 11.0,
                                                color: Utils.greyColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      profileTile(
                                          context, 'rateUs.svg', 'Rate Us'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      profileTile(context, 'feedBack.svg',
                                          'Share Feedback'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      profileTile(context, 'refer&earn.svg',
                                          'Refer & Earn'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      profileTile(
                                          context, 'logout.svg', 'Logout'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Version:   ${Dataconstants.fileVersion}',
                                          style: Utils.fonts(
                                              size: 12.0,
                                              color: Utils.greyColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget profileTile(BuildContext context, String icon, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (title == 'Logout') {
          CommonFunction.bottomSheet(context, 'Logout');
        }
        if (title == 'Color Mode') {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0)),
              ),
              context: context,
              builder: (context) => StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Set Color Mode",
                                  textAlign: TextAlign.center,
                                  style: Utils.fonts(
                                      size: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Radio(
                                        value: colorMode.light,
                                        groupValue: selectColorMode,
                                        onChanged: (colorMode value) {
                                          setState(() {
                                            selectColorMode = value;
                                          });
                                          ThemeConstants.setLightTheme();
                                        }),
                                    Text("Light"),
                                    Radio(
                                        value: colorMode.dark,
                                        groupValue: selectColorMode,
                                        onChanged: (colorMode value) {
                                          setState(() {
                                            selectColorMode = value;
                                            ThemeConstants.setDarkTheme();
                                          });
                                        }),
                                    Text("Dark"),
                                    Radio(
                                        value: colorMode.syncWithSystem,
                                        groupValue: selectColorMode,
                                        onChanged: (colorMode value) {
                                          setState(() {
                                            selectColorMode = value;
                                          });


                                        }),
                                    Text("Sync with System"),
                                  ],
                                ),
                                Divider(
                                  // thickness: 1,
                                  color: Utils.lightGreyColor,
                                ),
                                CommonFunction.saveAndCancelButton(
                                    cancelText: 'Cancel',
                                    SaveText: 'Save',
                                    cancelCall: () {
                                      Navigator.pop(context);
                                    },
                                    saveCall: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            ),
                          ),
                        ));
                  }));
        }
        if (title == 'Settings') {
          setState(() {
            Dataconstants.profileSelectedIndex = 2;
          });
        }
        if (title == 'Preferred Sector') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PreferredSector()));
        }
        if (title == 'Rate Us') {
          CommonFunction.bottomSheet(
            context,
            'Rate Us',
          );
        }
        if (title == 'Share Feedback') {
          setState(() {
            Dataconstants.profileSelectedIndex = 3;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/appImages/$icon'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Text(
                  title,
                  style: Utils.fonts(
                      size: 14.0,
                      fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                    // Transform.rotate(
                    //   angle: 270 * math.pi / 180,
                    //   child: Icon(
                    //     Icons.arrow_drop_down_circle_rounded,
                    //     color: Utils.greyColor.withOpacity(0.6),
                    //     size: 20,
                    //   ),
                    // )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum chartValue { chartIq, tradingView, intellectChart }
enum colorMode { light, dark, syncWithSystem }
