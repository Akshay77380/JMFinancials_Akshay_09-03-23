import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:markets/jmScreens/market/news.dart';
import '../../controllers/BankDetailsController.dart';
import '../../controllers/watchListController.dart';
import '../../screens/search_bar_screen.dart';
import '../../util/BrokerInfo.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../news/news.dart';
import '../profile/profile.dart';
import '../watchlist/jmWatchlistScreen.dart';
import '../watchlist/marketWatchlist.dart';
import 'customiseDashboard.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getPaymentAccessToken();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Dataconstants.watchListController = Get.put(WatchListController());
    super.initState();
  }

  getPaymentAccessToken() async {
    var header = {"application": "Intellect"};
    var stringResponse = await CommonFunction.getPaymentAccessToken(header);
    var jsonResponse = jsonDecode(stringResponse);
    //print("Get access token: ${jsonResponse}");
    Dataconstants.fundstoken = await jsonResponse['data'];
    // getBankdetails();
    await Dataconstants.bankDetailsController.getBankDetails();
    getItems();
    return Dataconstants.fundstoken;
  }

  getItems() async {
    Dataconstants.items.clear();

    for (var i = 0; i < BankDetailsController.getBankDetailsListItems.length; i++) {
      Dataconstants.items.add(BankDetailsController.getBankDetailsListItems[i].id.toString().split("|")[0]);
    }

    Dataconstants.dropDownInitialValue = Dataconstants.items.first.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    print(BrokerInfo.mainUrl);
    var theme = Theme.of(context);
    HomeWidgets.context = context;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Dataconstants.isGuestUser
                      ? SizedBox.shrink()
                      : InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreenJm(Dataconstants.pageController.stream)));
                          },
                          child: SvgPicture.asset("assets/appImages/profilepic.svg")),
                  SizedBox(
                    width: 10,
                  ),
                  Observer(builder: (context) {
                    // Theme Change here (start) -Akshay
                    return Text(
                      "Hello ${Dataconstants.profileName.value.split(" ")[0] ?? ''}",
                      style: Utils.fonts(size: 17.0, color: Theme.of(context).brightness == Brightness.dark ? Utils.whiteColor : Utils.blackColor),
                    );
                    // Theme Change here (end) -Akshay
                  }),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        InAppSelection.searchTabIndex = 0;
                        Dataconstants.scriptCount = 0;
                        showSearch(
                          context: context,
                          delegate: SearchBarScreen(1),
                        );
                      },
                      child: Icon(Icons.search)),
                  Spacer(),

                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage()));
                      },
                      child: Image.asset(
                        "assets/appImages/bell-icon.png",
                        color: Theme.of(context).brightness == Brightness.dark ? Utils.whiteColor : Utils.blackColor,
                        height: 20,
                        width: 20,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomiseDashboard())).then((value) {
                          setState(() {});
                        });
                      },
                      // Theme Change here -Akshay
                      child: SvgPicture.asset(
                        "assets/appImages/boxSearch.svg",
                        color: Theme.of(context).brightness == Brightness.dark ? Utils.whiteColor : Utils.blackColor,
                      )),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  // InkWell(
                  //     onTap: () {
                  //       // showSearch(
                  //       //   context: context,
                  //       //   delegate:
                  //       //   SearchBarScreen(InAppSelection.marketWatchID),
                  //       // );
                  //     },
                  //     child: SvgPicture.asset("assets/appImages/search.svg")),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextField(
              //         onTap: () async {
              //           CommonFunction.firebaseEvent(
              //             clientCode: "dummy",
              //             device_manufacturer: Dataconstants.deviceName,
              //             device_model: Dataconstants.devicemodel,
              //             eventId: "6.0.2.0.0",
              //             eventLocation: "header",
              //             eventMetaData: "dummy",
              //             eventName: "search",
              //             os_version: Dataconstants.osName,
              //             location: "dummy",
              //             eventType: "Click",
              //             sessionId: "dummy",
              //             platform: Platform.isAndroid ? 'Android' : 'iOS',
              //             screenName: "guest user dashboard",
              //             serverTimeStamp: DateTime.now().toString(),
              //             source_metadata: "dummy",
              //             subType: "icon",
              //           );
              //         },
              //         onChanged: (value) {
              //           setState(() {
              //             HomeWidgets.searchValue = value;
              //             HomeWidgets.assignWidgets(context);
              //           });
              //         },
              //         decoration: InputDecoration(
              //           contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              //           filled: true,
              //           fillColor: Color(0xFFFFFFFF),
              //           prefixIcon: Icon(Icons.search, color: Utils.greyColor.withOpacity(0.7)),
              //           suffixIcon: Padding(
              //             padding: const EdgeInsets.all(8.5),
              //             child: Container(
              //               // height: 10,
              //               // width: 10,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(20),
              //                 color: Color(0xff0063f5).withOpacity(0.25),
              //               ),
              //               child: Icon(
              //                 Icons.mic_none,
              //                 size: 20,
              //                 color: Utils.primaryColor,
              //               ),
              //             ),
              //           ),
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(10),
              //             ),
              //           ),
              //           hintText: 'Search Widget',
              //         ),
              //         keyboardType: TextInputType.visiblePassword,
              //       ),
              //       // TextField(
              //       //   onChanged: (value) {
              //       //     setState(() {
              //       //       searchValue = value;
              //       //     });
              //       //   },
              //       //   decoration: InputDecoration(
              //       //     contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              //       //     filled: true,
              //       //     fillColor: Color(0xFFFFFFFF),
              //       //     prefixIcon: Icon(Icons.search, color: Utils.greyColor.withOpacity(0.7)),
              //       //     suffixIcon: Padding(
              //       //       padding: const EdgeInsets.all(8.5),
              //       //       child: Container(
              //       //         // height: 10,
              //       //         // width: 10,
              //       //         decoration: BoxDecoration(
              //       //           borderRadius: BorderRadius.circular(20),
              //       //           color: Color(0xff0063f5).withOpacity(0.25),
              //       //         ),
              //       //         child: Icon(
              //       //           Icons.mic_none,
              //       //           size: 20,
              //       //           color: Utils.primaryColor,
              //       //         ),
              //       //       ),
              //       //     ),
              //       //     border: OutlineInputBorder(
              //       //       borderRadius: BorderRadius.all(
              //       //         Radius.circular(10),
              //       //       ),
              //       //     ),
              //       //     hintText: 'Search Widget',
              //       //   ),
              //       // ),
              //     ),
              //     // SvgPicture.asset("assets/appImages/search.svg"),
              //     // SizedBox(
              //     //   width: 10,
              //     // ),
              //     // Container(
              //     //   height: 20,
              //     //   color: Utils.greyColor,
              //     //   width: 1.0,
              //     // ),
              //     // SizedBox(
              //     //   width: 10,
              //     // ),
              //     // Text(
              //     //   "Search Widget",
              //     //   style: Utils.fonts(
              //     //       fontWeight: FontWeight.w300,
              //     //       color: Utils.greyColor),
              //     // ),
              //     // Spacer(),
              //     // InkWell(
              //     //   onTap: () {},
              //     //   child: Icon(
              //     //     Icons.mic,
              //     //     color: Utils.primaryColor,
              //     //   ),
              //     // )
              //   ],
              // ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: HomeWidgets.controller,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: HomeWidgets.newData
            // children: [
            //   Text('Home')
            // ],
            ),
      ),
    );
  }
}
