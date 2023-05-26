import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Connection/News/NewsClient.dart';
import '../../Connection/ResponseListener.dart';
import '../../controllers/BankDetailsController.dart';
import '../../controllers/holdingController.dart';
import '../../controllers/netPositionController.dart';
import '../../controllers/orderBookController.dart';
import '../../controllers/todaysPostionController.dart';
import '../../controllers/tradeBookController.dart';
import '../../util/BrokerInfo.dart';
import '../../util/CommonFunctions.dart';
import '../../util/ConnectionStatus.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../dashboard/Home.dart';
import '../more/more_screen.dart';
import '../more/more_screen_old.dart';
import '../orders/orders_screen.dart';
import '../portfolio/portfolio.dart';
import '../portfolio/zero_portfolio.dart';
import '../watchlist/jmWatchlistScreen.dart';

class MainScreen extends StatefulWidget {
  final bool changePassword;
  final String message;
  final bool toChangeTab;

  const MainScreen({Key key, this.changePassword = false, this.message = '', this.toChangeTab = false}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver implements ResponseListener {
  static List<Widget> _pages;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool finalToChangeTab = false;

  static const snackBarDuration = Duration(seconds: 3);
  final snackBar = SnackBar(
    content: Text('Press back again to exit'),
    duration: snackBarDuration,
  );
  DateTime backButtonPressTime;
  StreamSubscription _connectionChangeStream;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    checkGuestUser();

    Dataconstants.iqsClient.sendIqsReconnectWithCallback;

    getMessage();

    super.initState();
    // var params = {
    //   "screen": "main_Screen",
    // };
    // CommonFunction.JMFirebaseLogging("Screen_Tracking", params);

    _pages = <Widget>[
      Home(),
      // Text('Home'),
      JmWatchlistScreen(),
      zeroPortfolio(),
      JMOrdersScreen(0),
      JMMoreScreen(),
      // JMMoreScreenOld(Dataconstants.pageController.stream),
    ];

    if (!Dataconstants.lifeCycleConstant) {
      WidgetsBinding.instance.addObserver(this);
      Dataconstants.lifeCycleConstant = true;
    }

    Dataconstants.itsClient.mResponseListener = this;
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Dataconstants.fToast = FToast();
      // Dataconstants.fToast.init(context);
      if (Dataconstants.isMainOnLogin == true) {
        if (Dataconstants.mpinFlag == false) await CommonFunction.changePasswordPopUp(Dataconstants.navigatorKey.currentContext, "Need to vrfvtr password");
      }
      Future.delayed(Duration(milliseconds: 500));
      if (Dataconstants.loginData.watchlistFlag.toString() == "false") Dataconstants.watchListController.checkWatchList();
    });

    Timer.periodic(Duration(minutes: 1), (timer) {
      Dataconstants.limitController.getLimitsData();
      // //print('Limits timer');
    });

    if (Dataconstants.isMainOnLogin == true) {
      var dashboardData = InAppSelection.dashboardSettings.toString();

      List decodedlist = json.decode(dashboardData);
      for (int i = 0; i < decodedlist.length; i++) {
        if (decodedlist[i][2] == true) {
          switch (decodedlist[i][1]) {
            case "Limits":
              Dataconstants.limitController.getLimitsData();
              getPaymentAccessToken();
              break;
            case "Positions":
              Dataconstants.netPositionController.fetchNetPosition();
              break;
            case "Trending Stocks":
              Dataconstants.mostActiveVolumeController.getMostActiveVolume("NSE", "Nifty");
              break;
            case "Top Performing Industries":
              Dataconstants.topPerformingIndustriesController.getTopPerformingIndustries();
              break;
            case "Orders":
              Dataconstants.orderBookData.fetchOrderBook();
              break;
            case "Top Gainers":
              Dataconstants.topGainersController.getTopGainers("nse", "nifty", "day");
              break;
            case "Events":
              Dataconstants.eventsDividendController.getEventsDividend();
              break;
            case "Most Active":
              Dataconstants.mostActiveVolumeController.getMostActiveVolume("NSE", "Nifty");
              break;
            case "JM Baskets":
              break;
            case "My Ongoing SIPs":
              Dataconstants.equitySipController.getEquitySip();
              break;
            case "Research":
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                await CommonFunction.getResearchClientStructuredCallEntries();
              });
              break;
            case "Market Breadth":
              Dataconstants.nseAdvanceController.getNseAdvance();
              Dataconstants.nseDeclineController.getNseDecline();
              Dataconstants.bseAdvanceController.getBseAdvance();
              Dataconstants.bseDeclineController.getBseDecline();
              break;
            case "Top Losers":
              Dataconstants.topLosersController.getTopLosers("nse", "nifty", 'month');
              break;
            case "News":
              Dataconstants.newsClient = NewsClient.getInstance();
              Dataconstants.newsClient.connect();
              break;
            case "Global Indices":
              Dataconstants.worldIndicesController.getWorldIndices();
              break;
            case "Circuit Breakers":
              Dataconstants.circuitBreakersController.getCircuitBreakers();
              break;
            case "OI Analysis":
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                await Dataconstants.topHighestOiController.getTopHighestOi();
                await Dataconstants.topLowestOIController.getTopLowestOi();
                await Dataconstants.increaseInOiController.getIncreaseInOi();
                await Dataconstants.decreaseInOiController.getDecreaseinOi();
              });

              break;
            case "Backoffice":
              break;
            case "IPO":
              Dataconstants.openIpoController.getOpenIpo();
              // Dataconstants.upcomingIpoController.getUpcomingIpo();
              // Dataconstants.recentListingController.getIpoRecentListing();
              break;
            case "NFO":
              break;
            case "NCD":
              break;
            case "DP Holdings":
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                await Dataconstants.holdingController.fetchHolding();
                await Dataconstants.holdingController.fetchMtfHolding();
              });
              break;
            case "Other Assets":
              Dataconstants.openIpoController.getOpenIpo();
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                for (int i = 0; i < Dataconstants.otherAssets.length; i++) {
                  Dataconstants.otherAssets[i] = CommonFunction.getScripDataModel(
                    exch: Dataconstants.otherAssets[i].exch,
                    exchCode: Dataconstants.otherAssets[i].exchCode,
                    getNseBseMap: true,
                    sendReq: true,
                    getChartDataTime: 15,
                  );
                }
                for (int i = 0; i < Dataconstants.marketWatchList.length; i++) {
                  Dataconstants.marketWatchList[i] = CommonFunction.getScripDataModel(
                    exch: Dataconstants.marketWatchList[i].exch,
                    exchCode: Dataconstants.marketWatchList[i].exchCode,
                    getNseBseMap: true,
                    sendReq: true,
                    getChartDataTime: 15,
                  );
                }
              });
              break;
          }
        }
      }

      //TODO:
      CommonFunction.registerToken();
      //TODO: order settings & profile
      CommonFunction.getOrderSettings();
      CommonFunction.getProfileData();
      CommonFunction.getClientType().then((value) {
        if (value != null) {
          var responseJson = jsonDecode(value);
          Dataconstants.clientTypeData = responseJson['data'];
        }
      });
      Dataconstants.newsClient = NewsClient.getInstance();
      Dataconstants.newsClient.connect();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (Dataconstants.showPasswordPopup == true || Dataconstants.showPasswordPopup == null) {
          // if (Dataconstants.mpinFlag == false) await CommonFunction.changePasswordPopUp(Dataconstants.navigatorKey.currentContext, "Need to change password");
        }
      });
      Dataconstants.isMainOnLogin = false;
    }
    WidgetsBinding.instance.addObserver(this);
  }

  void getMessage() async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // await flutterLocalNotificationsPlugin.show(
      //   messageId++,
      //   message.notification.title,
      //   message.notification.body,
      //   platformChannelSpecifics,
      // );

      flutterLocalNotificationsPlugin.show(
          message.hashCode,
          null,
          message.data[4],
          NotificationDetails(
            android: AndroidNotificationDetails('high_importance_channel', 'High Importance Notifications',
              channelDescription: 'This channel is used for important notifications.',
              importance: Importance.max,

              priority: Priority.high,
              icon: '@mipmap/notiicon',
              enableLights: true,
              color: Color(0xffff5c34),
              showWhen: false,
            ), )
      );
    });
  }

  checkGuestUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("prefs.getBool('isGuestLogin') ${prefs.getBool('isGuestUser')}");
    var boolGuest = await prefs.getBool('isGuestUser');

    setState(() {
      if (boolGuest == true || boolGuest == false) {
        Dataconstants.isGuestUser = boolGuest;
      } else {
        Dataconstants.isGuestUser = false;
      }
    });

    if (Dataconstants.isGuestUser) var dashboardData = Dataconstants.guestDashboard;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          // Dataconstants.iqsClient.sendIqsReconnect();
          // Dataconstants.iqsClient.bulkSendScripRequestToIQS(Dataconstants.marketWatchListeners[InAppSelection.marketWatchID].watchList, true);
          // Dataconstants.iqsClient.bulkSendScripRequestToIQS(Dataconstants.predefinedMarketWatchListener.watchList, true);
          // Dataconstants.iqsClient.bulkSendScripRequestToIQS(Dataconstants.indicesMarketWatchListener.watchList, true);
          // Dataconstants.iqsClient.requestForMarketSummary(
          //   Dataconstants.exchData[Dataconstants.summaryMarketWatchListener.summaryExchPos].exch,
          //   Dataconstants.exchData[Dataconstants.summaryMarketWatchListener.summaryExchPos].exchTypeShort,
          //   Dataconstants.summaryMarketWatchListener.selectedFilter,
          // );
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        if (Dataconstants.itsClient.isLoggedIn) {
          // Dataconstants.itsClient.stopHandshakeTimer();
          // Dataconstants.iqsClient.stopiqsTimer();
          // Dataconstants.ispaused = true;
          // print("app in paused");
        }
        InAppSelection.saveSelections();
        CommonFunction.saveRecentSearchData();
        break;
      case AppLifecycleState.detached:
        //print("app in detached");
        break;
      //   //print("app in detached");
      //   break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Dataconstants.lifeCycleConstant = false;
    super.dispose();
  }

  void connectionChanged(dynamic hasConnection) {
    if (hasConnection) {
      CommonFunction.reconnect();
      CommonFunction.showSnackBarKey(context: context, key: _scaffoldKey, text: 'Connected to intenet. Reconnecting servers.', color: Colors.green);
    } else
      CommonFunction.showSnackBarKey(context: context, key: _scaffoldKey, text: 'Lost connection to server. Please check internet connection', color: Colors.red);
  }

  getItems() async {
    Dataconstants.items.clear();

    for (var i = 0; i < BankDetailsController.getBankDetailsListItems.length; i++) {
      Dataconstants.items.add(BankDetailsController.getBankDetailsListItems[i].id.toString().split("|")[0]);
    }

    Dataconstants.dropDownInitialValue = Dataconstants.items.first.toString().trim();
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size(0.0, 0.0),
        child: Container(
          color: theme.appBarTheme.color,
        ),
      ),
      // body: Text('Main'),
      body: Builder(
        builder: (context) => WillPopScope(
          onWillPop: () => handleWillPop(context),
          child:
              // InAppSelection.mainScreenIndex != 4 &&
              //         InAppSelection.mainScreenIndex != 2 &&
              //         InAppSelection.mainScreenIndex != 5 &&
              //         InAppSelection.mainScreenIndex != 1 &&
              //         InAppSelection.mainScreenIndex != 0
              //     ? AnnotatedRegion<SystemUiOverlayStyle>(
              //         value: SystemUiOverlayStyle(statusBarColor: Colors.black),
              //         child: SafeArea(
              //           child: NestedScrollView(
              //               floatHeaderSlivers: true,
              //               headerSliverBuilder: (context, innerBoxIsScrolled) => [
              //                     SliverPersistentHeader(
              //                       delegate: DynamicHeader(),
              //                       floating: true,
              //                     )
              //                   ],
              //               body: _pages.elementAt(InAppSelection.mainScreenIndex)),
              //         ),
              //       )
              //     :
              _pages.elementAt(InAppSelection.mainScreenIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        selectedIconTheme: IconThemeData(color: Utils.primaryColor),
        selectedLabelStyle: Utils.fonts(
          size: 12.0,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: Utils.fonts(
          size: 10.0,
          fontWeight: FontWeight.w500,
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/appImages/bottom_home.svg",
              color: InAppSelection.mainScreenIndex == 0 ? Utils.primaryColor : Utils.greyColor,
            ),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/appImages/bottom_watchlist.svg",
              color: InAppSelection.mainScreenIndex == 1 ? Utils.primaryColor : Utils.greyColor,
            ),
            label: 'WATCHLIST',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/appImages/bottom_portfolio.svg",
              color: InAppSelection.mainScreenIndex == 2 ? Utils.primaryColor : Utils.greyColor,
            ),
            label: 'PORTFOLIO',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/appImages/bottom_orders.svg",
              color: InAppSelection.mainScreenIndex == 3 ? Utils.primaryColor : Utils.greyColor,
            ),
            label: 'ORDERS',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/appImages/bottom_more.svg",
              color: InAppSelection.mainScreenIndex == 4 ? Utils.primaryColor : Utils.greyColor,
            ),
            label: "DISCOVER",
          ),
        ],
        currentIndex: InAppSelection.mainScreenIndex,
        onTap: (index) {
          if (index == 4) {
            Dataconstants.moreSelectedText = 'more';
            Dataconstants.pageController.add(true);
          }
          if (index == 2) {
            // Dataconstants.orderBookData = Get.put(OrderBookController());
            // Dataconstants.tradeBookData.fetchTradeBook();
            // Dataconstants.netPositionController = Get.put(NetPositionController());
            // Dataconstants.todaysPositionController = Get.put(TodaysPositionController());
            // Dataconstants.holdingController = Get.put(HoldingController());

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await Dataconstants.holdingController.fetchHolding();
              await Dataconstants.holdingController.fetchMtfHolding();
            });
          }
          setState(() {
            InAppSelection.mainScreenIndex = index;
            InAppSelection.marketWatchID = 0;
          });
        },
      ),
    );
  }

  Future<bool> handleWillPop(BuildContext context) async {
    if (InAppSelection.mainScreenIndex == 4) {
      if (Dataconstants.moreSelectedText != 'more') {
        Dataconstants.moreSelectedText = 'more';
        Dataconstants.pageController.add(true);
      }
    } else {
      final now = DateTime.now();
      final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed = backButtonPressTime == null || now.difference(backButtonPressTime) > snackBarDuration;

      if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
        backButtonPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
      return true;
    }
  }

  @override
  void onErrorReceived(String error, int type) {
    CommonFunction.showSnackBarKey(
      context: context,
      key: _scaffoldKey,
      text: error,
      color: Colors.red,
    );
  }

  @override
  void onResponseReceieved(String resp, int type) {
    if (type == 2) {
      CommonFunction.showSnackBarKey(
        context: context,
        key: _scaffoldKey,
        text: resp,
        color: Colors.green,
        duration: const Duration(milliseconds: 1000),
      ).then(
        (value) => Navigator.of(context).pop(),
      );
    } else if (type == 100) {
      CommonFunction.showSnackBarKey(
        context: context,
        key: _scaffoldKey,
        text: resp,
        color: Colors.green,
      );
    }
  }
}
