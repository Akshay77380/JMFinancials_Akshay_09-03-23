import 'dart:async';
import 'dart:convert';
import 'dart:developer' as io;
import 'dart:io';
import 'dart:math';

// import 'package:connectivity/connectivity.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:syncfusion_flutter_maps/maps.dart';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:markets/jmScreens/ScriptInfo/ScriptInfo.dart';
import 'package:markets/util/Dataconstants.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:sqflite/sqflite.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../controllers/BseAdvanceController.dart';
import '../controllers/CircuitBreakersController.dart';
import '../controllers/DetailController.dart';
import '../controllers/EventsBoardMeetController.dart';
import '../controllers/EventsBonusController.dart';
import '../controllers/EventsDividendController.dart';
import '../controllers/EventsRightsController.dart';
import '../controllers/EventsSplitsController.dart';
import '../controllers/IpoRecentListingController.dart';
import '../controllers/MostActiveFuturesController.dart';
import '../controllers/MostActivePutController.dart';
import '../controllers/MostActiveTurnoverController.dart';
import '../controllers/MostActiveVolumeController.dart';
import '../controllers/NseAdvanceController.dart';
import '../controllers/OpenIpoController.dart';
import '../controllers/WorldIndicesController.dart';
import '../controllers/equitySipController.dart';
import '../controllers/fundtransactioncontroller.dart';
import '../controllers/holdingController.dart';
import '../controllers/limitController.dart';
import '../controllers/mostActiveCallController.dart';
import '../controllers/netPositionController.dart';
import '../controllers/orderBookController.dart';
import '../controllers/positionFilterController.dart';
import '../controllers/topGainersController.dart';
import '../controllers/topHighestOIController.dart';
import '../controllers/topLosersController.dart';
import '../controllers/topPerformingIndustries.dart';
import '../controllers/upcomingIpoController.dart';
import '../database/watchlist_database.dart';
import '../jmScreens/CommonWidgets/custom_keyboard.dart';
import '../jmScreens/CommonWidgets/number_field.dart';
import '../jmScreens/CommonWidgets/switch.dart';
import '../jmScreens/addFunds/AddFunds.dart';
import '../jmScreens/addFunds/AddMoney.dart';
import '../jmScreens/login/ChangePassword.dart';
import '../jmScreens/login/Login.dart';
import '../jmScreens/login/validatempin.dart';
import '../jmScreens/mainScreen/MainScreen.dart';
import '../jmScreens/market/market_stats_next.dart';
import '../jmScreens/news/news.dart';
import '../jmScreens/orders/holdings_screen.dart';
import '../jmScreens/orders/orders_screen.dart';
import '../jmScreens/profile/LimitScreen.dart';
import '../jmScreens/redirectedWidgets/Events.dart';
import '../jmScreens/redirectedWidgets/circuitBreakers.dart';
import '../jmScreens/redirectedWidgets/options.dart';
import '../jmScreens/redirectedWidgets/topPerformingIndustries..dart';
import '../jmScreens/redirectedWidgets/trendingStocks.dart';
import '../jmScreens/research/research_cards.dart';
import '../jmScreens/research/research_screen.dart';
import '../model/exchData.dart';
import '../model/indices_listener.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import '../model/jmModel/topPerformingIndustries.dart';
import '../model/scripStaticModel.dart';
import '../model/scrip_info_model.dart';
import '../style/theme.dart';
import '../widget/predefined_marketwatch.dart';
import '../widget/scripdetail_optionChain.dart';
import 'BrokerInfo.dart';
import '../util/DateUtil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import '../widget/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/smallChart.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'ConnectionStatus.dart';
import 'InAppSelections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Utils.dart';
enum requestResponseState { Error, DataReceived, Loading, SessionExpired }
List bankDetails = List();
StreamController<requestResponseState> bankdetailscontroller = StreamController.broadcast();

class CommonFunction {
  // JM
  static LocalAuthentication localAuthentication = LocalAuthentication();
  List<ScripStaticModel> _scripStaticData = [];
  static String productType;
  static Map<String, String> productItems;

  static ObservableList<ScripInfoModel> indices;

  static StateSetter setState;

  var formatter = new DateFormat('dd MMM, yy');

  static List<MemberData> getMembers(String grType, String grCode) => Dataconstants.memberData.where((element) => element.grType == grType && element.grCode == grCode).toList();

  static String getGroupName(String grType, String grCode) => Dataconstants.groupData.firstWhere((element) => element.grType == grType && element.grCode == grCode).grName;

  static List<GroupData> getGroup(String grType, String searchText) {
    if (searchText.isEmpty)
      return Dataconstants.groupData.where((element) => element.grType == grType).toList();
    else
      return Dataconstants.groupData.where((element) => element.grType == grType && element.grName.toLowerCase().contains(searchText)).toList();
  }

  static void backOfficeTrPlSummary() async {
    String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPLSummaryCMFY.svc/TrPLSummaryCMFYGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~2020-21~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}", bs64);

    //print(res1);
  }

  static void backOfficeTrPLSummaryCMFY() async {
    String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);
    //print(bs64);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPLSummaryCMFY.svc/TrPLSummaryCMFYGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~2020-21~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}", bs64);

    //print(res1);
  }

  static void backOfficeTrPLSummaryCMFYDetail() async {
    String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);
    //print(bs64);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPLSummaryCMFYDetail.svc/TrPLSummaryCMFYDetailGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~2020-21~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}",
        bs64);

    //print(res1);
  }

  static void backOfficeTrPLSummaryCMYTDDetail2() async {
    String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);
    //print(bs64);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPLSummaryCMYTDDetail.svc/TrPLSummaryCMYTDDetailGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}",
        bs64);
  }

  static void getPnlYears() async {
    Dataconstants.pnlItems.clear();
    for (var i = 0; i < DetailsControlller.getYears.length; i++) {
      if (i == 0) {
        Dataconstants.pnlItems.add(DetailsControlller.getYears[i]);
      } else {
        if (Dataconstants.pnlItems.contains(DetailsControlller.getYears[i])) {
        } else {
          Dataconstants.pnlItems.add(DetailsControlller.getYears[i]);
        }
      }
    }
    Dataconstants.pnlItems.sort((a, b) => a.compareTo(b));
    Dataconstants.pnlDropodownYear = Dataconstants.pnlItems[0];
  }

  static cancelFilters(bool isOrderBook) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonData;
    List lastFilters;
    if (isOrderBook) {
      jsonData = prefs.getString('orderBookFilters');
      lastFilters = jsonDecode(jsonData);
      // //print('lastFilters $lastFilters');
      OrderBookController.orderBookFilters[0]['All'] = lastFilters[0]['All'];
      OrderBookController.orderBookFilters[0]['Equity'] = lastFilters[0]['Equity'];
      OrderBookController.orderBookFilters[0]['Future'] = lastFilters[0]['Future'];
      OrderBookController.orderBookFilters[0]['Option'] = lastFilters[0]['Option'];
      OrderBookController.orderBookFilters[0]['Currency'] = lastFilters[0]['Currency'];
      OrderBookController.orderBookFilters[0]['Commodity'] = lastFilters[0]['Commodity'];
      OrderBookController.orderBookFilters[1]['All'] = lastFilters[1]['All'];
      OrderBookController.orderBookFilters[1]['CNC'] = lastFilters[1]['CNC'];
      OrderBookController.orderBookFilters[1]['MIS'] = lastFilters[1]['MIS'];
      OrderBookController.orderBookFilters[1]['NRML'] = lastFilters[1]['NRML'];
      OrderBookController.orderBookFilters[2]['All'] = lastFilters[2]['All'];
      OrderBookController.orderBookFilters[2]['Executed'] = lastFilters[2]['Executed'];
      OrderBookController.orderBookFilters[2]['Rejected'] = lastFilters[2]['Rejected'];
      OrderBookController.orderBookFilters[2]['Cancelled'] = lastFilters[2]['Cancelled'];
    } else {
      jsonData = prefs.getString('positionFilters');
      lastFilters = jsonDecode(jsonData);
      PositionFilterController.positionFilters[0]['All'] = lastFilters[0]['All'];
      PositionFilterController.positionFilters[0]['Equity'] = lastFilters[0]['Equity'];
      PositionFilterController.positionFilters[0]['Future'] = lastFilters[0]['Future'];
      PositionFilterController.positionFilters[0]['Option'] = lastFilters[0]['Option'];
      PositionFilterController.positionFilters[0]['Currency'] = lastFilters[0]['Currency'];
      PositionFilterController.positionFilters[0]['Commodity'] = lastFilters[0]['Commodity'];
      PositionFilterController.positionFilters[1]['All'] = lastFilters[1]['All'];
      PositionFilterController.positionFilters[1]['CNC'] = lastFilters[1]['CNC'];
      PositionFilterController.positionFilters[1]['MIS'] = lastFilters[1]['MIS'];
      PositionFilterController.positionFilters[1]['NRML'] = lastFilters[1]['NRML'];
      PositionFilterController.positionFilters[2]['All'] = lastFilters[2]['All'];
      PositionFilterController.positionFilters[2]['Long'] = lastFilters[2]['Long'];
      PositionFilterController.positionFilters[2]['Short'] = lastFilters[2]['Short'];
      PositionFilterController.positionFilters[3]['All'] = lastFilters[3]['All'];
      PositionFilterController.positionFilters[3]['Daily'] = lastFilters[3]['Daily'];
      PositionFilterController.positionFilters[3]['Expiry'] = lastFilters[3]['Expiry'];
    }
  }

  static getWatchListNames(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dataconstants.watchListNames.clear();
    for (var i = 0; i < id; i++) {
      String temp1 = (prefs.getString(i.toString()));
      if (temp1 != null) {
        /* Setting Watch List Name of every watchList */
        Dataconstants.watchListNames.add(temp1);
      } else {
        /* Setting Watch List Name of every watchList */
        Dataconstants.watchListNames.add('Watchlist ${i + 1}');
      }
    }
  }

  static changeStatusBar() {
    var overlayStyle;
    if (ThemeConstants.themeMode.value == ThemeMode.light) {
      overlayStyle = SystemUiOverlayStyle.dark;
    } else if (ThemeConstants.themeMode.value == ThemeMode.dark && ThemeConstants.amoledThemeMode.value) {
      overlayStyle = SystemUiOverlayStyle.light;
    } else {
      overlayStyle = SystemUiOverlayStyle.light;
    }
    Dataconstants.overlayStyle = overlayStyle;
  }

  static generateOtp(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "SendOTP", json.encode(requestJson));
    // //print("generate OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static getMappingID(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "GetUserListByMobileNo", json.encode(requestJson));
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static verifyOtp(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "VerifyOTP", requestJson);
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static watchListOperations(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "Watchlistoperation", requestJson, Dataconstants.loginData.data.jwtToken);
    //print("insert Watchlist response - ${response.body.toString()}");
    return response.body.toString();
  }

  static verifyAccountDetails(requestJson) async {
    try {
      http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "VerifyAccountDetails", jsonEncode(requestJson));
      // //log("verify OTP response - ${response.body.toString()}");
      return response.body.toString();
    } catch (e, s) {
      print(e);
    }
  }

  static Future getClientType() async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "GetClientDpType", {}, Dataconstants.loginData.data.jwtToken);
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static forgotPassword(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "ForgotPasswordUsingOTP", json.encode(requestJson));
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static unblockUser(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "UnblockUser", json.encode(requestJson));
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static setPassword(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "SetPassword", json.encode(requestJson));
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static changePassword(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "ChangePassword", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static login(requestJson) async {
    // http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "Login", json.encode(requestJson));
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "Login2FA", json.encode(requestJson));
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static BiometricLogin(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "BiometricLogin", json.encode(requestJson));
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static MPINLogin(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "MpinLogin", json.encode(requestJson));
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static setMpin(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "SetMPin", requestJson, Dataconstants.loginData.data.jwtToken);
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static refreshToken(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "refresh-token", json.encode(requestJson));
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static Future<bool> extract7zFile(String filePath) async {
    // Read the 7z file
    final bytes = File(filePath).readAsBytesSync();
    var outputDirPath = await getDatabasesPath();
    // Decode the archive
    final archive = ZipDecoder().decodeBytes(bytes);
    // Extract each file in the archive to the output directory
    for (final file in archive) {
      final filePath = '${outputDirPath}/${file.name.toLowerCase()}';
      if (file.isFile) {
        final data = file.content as List<int>;
        File(filePath).writeAsBytesSync(data);
        final databasePath = join(outputDirPath, "masters.mf");
        final dbFile = File(databasePath);
        final masterExists = await dbFile.exists();
        if (masterExists) await dbFile.delete();
        dbFile.writeAsBytesSync(data, flush: true);
      } else {
        Directory(filePath).create(recursive: true);
      }
    }
    return true;
  }

  // static setToken(requestJson) async {
  //   http.Response response = await Dataconstants.itsClient.httpPostWithHeaderContentType(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "InsertFCMToken", json.encode(requestJson));
  //   // //log("verify OTP response - ${response.body.toString()}");
  //   return response.body.toString();
  // }

  static setToken(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "InsertFCMToken", requestJson, Dataconstants.loginData.data.jwtToken);
    // //log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static registerToken() async {
    Dataconstants.fcmToken = await Dataconstants.firebaseMessaging.getToken();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var storedToken = pref.getString('FCMToken');
    var storedUserId = pref.getString('FCMUserId');
    var requestTokenJson = {
      "FCMToken": Dataconstants.fcmToken,
    };
    if (storedUserId != Dataconstants.feUserID) {
      var deleted = await Dataconstants.firebaseMessaging.getToken();
      if (deleted != '') {
        pref.setString('FCMUserId', Dataconstants.feUserID);
        Dataconstants.fcmToken = await Dataconstants.firebaseMessaging.getToken();

        var response = setToken(requestTokenJson);
        //print(response);
      }
    }
    if (storedToken == null || storedToken != Dataconstants.fcmToken) {
      var response = await setToken(requestTokenJson);
      //print(response);
    }

    //TODO: Login Aakash start
    //print("sdfdsfsdf");
    //TODO: Login Aakash end
  }

  static getLimits() async {
    var requestJson = {"Segment": "ALL"};

    // var requestJson = {
    //   "Segment":"ALL",
    //   "Exchange": "",
    //   "Producttype": "ALL"
    // };

    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "Limits", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static payoutResponse() async {
    var response = await CommonFunction.getMaxpayout({"AccountID": Dataconstants.feUserID, "segment": "ALL", "Sourceid": "MOB", "token": Dataconstants.loginData.data.jwtToken});

    var res = json.decode(response);

    print("res.toString() ${res["maxpayoutamt"]["amount"].toString()}");

    setState(() {
      Dataconstants.payoutamount = res["maxpayoutamt"]["amount"].toString();
    });
  }

  static orderSettings(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "ClientSetting", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static getProfile(requestJson) async {
    // changed to v2 - 27/12/22 by sushil
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "GetProfile", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static getPaymentAccessToken(body) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "payment/GetAccessToken", null, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static getValidateUPI(body) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "payment/ValidateVPA", body, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static collectPaymentrequest(body) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "payment/CollectPaymentRequest", body, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static getPaymentStatus(body) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "payment/GetAllPaymentStatus", body, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static getBankDetails(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "payment/GetBankDetails", requestJson, Dataconstants.loginData.data.jwtToken);
    // //log("Access token API response - ${response.body.toString()}");
    return response.body.toString();
  }

  static sendPaymentResponse(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "payment/RazorpayResponse", requestJson, Dataconstants.loginData.data.jwtToken);
    //print("sendPaymentResponse---${response.body.toString()}");
    return response.body.toString();
  }

  static showBasicToastForJm(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.grey, textColor: Colors.black, fontSize: 16.0);
  }

  static placeOrder(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "PlaceOrder", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static placeBracketOrder(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "BracketOrder", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static placeGtcGtd(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "GTCGTDPlaceOrder", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static coverPriceRange(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "LTPCoverpercentage", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static modifyOrder(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "ModifyOrder", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static cancelOrder(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "CancelOrder", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static exitCoverOrder(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "ExitCoverOrder", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static exitBracketOrder(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "ExitBracketOrder", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static squareOfPosition(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "Squareofposition", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  static convertPositionOrder(requestJson) async {
    http.Response response =
        await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "PartialConvertPosition", requestJson, Dataconstants.loginData.data.jwtToken);
    return response.body.toString();
  }

  //TODO: PAYOUT
  static checkMarket(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "PayOut/checkMarketDays", requestJson, Dataconstants.loginData.data.jwtToken);
    // log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static getMaxpayout(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "/api/v2/GetMaxPayout", requestJson, Dataconstants.loginData.data.jwtToken);
    // log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static getCollectPayout(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "PayOut/CollectPayOutRequest", requestJson, Dataconstants.loginData.data.jwtToken);
    // log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  static getPayoutDetails(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "PayOut/GetPayoutDetails", requestJson, Dataconstants.loginData.data.jwtToken);
    // log("verify OTP response - ${response.body.toString()}");
    return response.body.toString();
  }

  // static getPayInDetails(requestJson) async {
  //   http.Response response = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "PayOut/GetPayoutDetails", requestJson, Dataconstants.loginData.data.jwtToken);
  //   // log("verify OTP response - ${response.body.toString()}");
  //   return response.body.toString();
  // }

  static getPaymentStauts(body) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + "payment/GetAllPaymentStatus", body, Dataconstants.loginData.data.jwtToken);
    print("kwyudfgc: ${response.body.toString()}");
    return response.body.toString();
  }

  //TODO: PAYOUT

  static insertWatchList(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "Watchlistoperation", requestJson, Dataconstants.loginData.data.jwtToken);
    //print("insert Watchlist response - ${response.body.toString()}");
    return response.body.toString();
  }

  static Future<http.Response> getResearchClientStructuredCallEntries() async {
    var requestJson = {};

    Dataconstants.researchCallsModel.updateFetchingData(true);
    http.Response response =
        await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "GetResearchClientStructuredCallEntries", requestJson, Dataconstants.loginData.data.jwtToken);
    Dataconstants.researchCallsModel.updateFetchingData(false);
    Dataconstants.researchCallsModel.getResearchData(response);

    print(response.body);
    return response;
  }

  static sendDataToCrashlytics(dynamic exception, StackTrace stackTrace, dynamic reason) async {
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace, reason: reason);
  }

  static getOrderSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('orderType') == null || prefs.getString('orderType') == '' || prefs.getString('UserID') != Dataconstants.feUserID) {
      /* get order settings */
      var jsonRequest = {"LoginID": Dataconstants.feUserID, "Type": "order", "Operation": "SELECT"};
      var result = await CommonFunction.orderSettings(jsonRequest);
      // //log("get order settings --- $result");
      try {
        var response = jsonDecode(result);
        if (response["status"] == false) {
          CommonFunction.showBasicToast(response["emsg"].toString());
        } else {
          if (response['message'] == "Success") {
            //print("order -- ${response['data'][0]['OrderSetting']}");
            if (response['data'][0]['OrderSetting'] != '') {
              var json = response['data'][0]['OrderSetting'];
              var setting = json.decode(json);
              //print('settings -- $setting');
              prefs.setString('orderType', setting['orderType']);
              prefs.setString('productTypeEquity', setting['productTypeEquity']);
              prefs.setString('productTypeDerivative', setting['productTypeDerivative']);
              prefs.setInt('equityDefaultQty', int.tryParse(setting['qtyCash']));
              prefs.setInt('futureDefaultQty', int.tryParse(setting['qtyFuture']));
              prefs.setInt('optionDefaultQty', int.tryParse(setting['qtyOption']));
            } else {
              Dataconstants.isUpdateOrderSettings = false;
              prefs.setString('orderType', '');
              prefs.setString('productTypeEquity', '');
              prefs.setString('productTypeDerivative', '');
              prefs.setInt('equityDefaultQty', -1);
              prefs.setInt('futureDefaultQty', -1);
              prefs.setInt('optionDefaultQty', -1);
            }
          }
        }
      } catch (e) {
        var jsons = json.decode(result);
        // CommonFunction.showBasicToast(jsons["data"].toString());
      }
    } else
      Dataconstants.isUpdateOrderSettings = true;
    prefs.setString('UserID', Dataconstants.feUserID);
  }

  static getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var requestJson = {};
    var response2 = await CommonFunction.getProfile(requestJson);
    var responseJson = jsonDecode(response2.toString());
    if (responseJson['status'] == true) {
      Dataconstants.setProfileName([responseJson['data']['name'] == null || responseJson['data']['name'] == '' ? " " : responseJson['data']['name']]);

      prefs.setString('profileData', jsonEncode(responseJson['data']));
      InAppSelection.profileData = jsonDecode(prefs.getString('profileData'));
    } else {
      CommonFunction.showBasicToast(responseJson["emsg"].toString());
    }
    Dataconstants.pageController.add(true);
  }

  static Future<bool> deleteWatchList(context, index, name) async {
    await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return new Container(
            height: 500.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Container(
                            width: 30,
                            height: 2,
                            color: Utils.greyColor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: SvgPicture.asset(
                            "assets/appImages/deleteWatchlist.svg",
                            width: 200,
                            height: 200,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Delete $name",
                          style: Utils.fonts(size: 18.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Are you sure want to delete this Watchlist?",
                          style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                  child: Text(
                                    "Cancel",
                                    style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                                  ),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: Utils.greyColor))))),
                            ElevatedButton(
                                onPressed: () {
                                  WatchlistDatabase.deleteWatchList(index);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset("assets/appImages/deleteWhite.svg"),
                                      Text(
                                        "Delete",
                                        style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Utils.lightRedColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    )))),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          );
        }).then((value) {
      return true;
    });
  }

  // static Future<bool> requestFingerprintAccess(BuildContext context) async {
  //   await showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         var theme = Theme.of(context);
  //         return Platform.isIOS
  //             ? CupertinoAlertDialog(
  //                 title: const Text('Biometric Login'),
  //                 content: Text(
  //                   'Do you want to enable Biometric Login? You can change this setting later in Settings page.',
  //                   style: TextStyle(color: Colors.grey),
  //                 ),
  //                 //content: ChangelogScreen(),
  //                 actions: <Widget>[
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         SharedPreferences prefs = await SharedPreferences.getInstance();
  //                         InAppSelection.fingerPrintEnabled = false;
  //                         prefs.setBool('FingerprintEnabled', false);
  //                         Navigator.of(context).pop();
  //                         return false;
  //                       },
  //                       child: Text(
  //                         "Cancel",
  //                         style: Utils.fonts(
  //                           size: 12.0,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 5,
  //                   ),
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         SharedPreferences prefs = await SharedPreferences.getInstance();
  //                         InAppSelection.fingerPrintEnabled = true;
  //                         prefs.setBool('FingerprintEnabled', true);
  //                         return true;
  //                       },
  //                       child: Text(
  //                         "Allow",
  //                         style: Utils.fonts(
  //                           size: 12.0,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               )
  //             : AlertDialog(
  //                 title: Text('Biometric Login'),
  //                 content: Text(
  //                   'Do you want to enable Biometric Login? You can change this setting later in Settings page.',
  //                   style: TextStyle(color: Colors.grey),
  //                 ),
  //                 //content: ChangelogScreen(),
  //                 actions: <Widget>[
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         SharedPreferences prefs = await SharedPreferences.getInstance();
  //                         InAppSelection.fingerPrintEnabled = false;
  //                         prefs.setBool('FingerprintEnabled', false);
  //                         InAppSelection.isBiometricEnable = false;
  //                         prefs.setBool('BiometricEnabled', false);
  //                         Navigator.of(context).pop();
  //
  //                         return false;
  //                       },
  //                       child: Text(
  //                         "Cancel",
  //                         style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         Navigator.of(context).pop();
  //                         CommonFunction.bottomSheet(context, "BIOMETRIC");
  //
  //                         SharedPreferences prefs = await SharedPreferences.getInstance();
  //                         InAppSelection.fingerPrintEnabled = true;
  //                         prefs.setBool('FingerprintEnabled', true);
  //                         InAppSelection.isBiometricEnable = true;
  //                         prefs.setBool('BiometricEnabled', true);
  //                         return true;
  //                       },
  //                       child: Text(
  //                         "Allow",
  //                         style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
  //                       ),
  //                     ),
  //                   )
  //
  //                   // TextButton(
  //                   //   child: Text(
  //                   //     'Cancel',
  //                   //     style: TextStyle(
  //                   //       color: theme.primaryColor,
  //                   //     ),
  //                   //   ),
  //                   //   onPressed: () async {
  //                   //     SharedPreferences prefs =
  //                   //     await SharedPreferences.getInstance();
  //                   //     InAppSelection.fingerPrintEnabled = false;
  //                   //     prefs.setBool('FingerprintEnabled', false);
  //                   //     Navigator.of(context).pop();
  //                   //   },
  //                   // ),
  //                   // TextButton(
  //                   //   child: Text(
  //                   //     'Allow',
  //                   //     style: TextStyle(
  //                   //       color: theme.primaryColor,
  //                   //     ),
  //                   //   ),
  //                   //   onPressed: () async {
  //                   //     SharedPreferences prefs =
  //                   //     await SharedPreferences.getInstanceany();
  //                   //     InAppSelection.fingerPrintEnabled = true;
  //                   //     prefs.setBool('FingerprintEnabled', true);
  //                   //     Navigator.of(context).pop();
  //                   //   },
  //                   // ),
  //                 ],
  //               );
  //       });
  // }

  static Future<List<BiometricType>> isBiometricAvailable() async {
    List<BiometricType> data = [];
    try {
      if (await localAuthentication.canCheckBiometrics) data = await localAuthentication.getAvailableBiometrics();

      if (data.toString().contains("BiometricType.strong")) {
        print(data.contains(BiometricType.face));
      } else {}
    } on PlatformException catch (e) {
      //print(e);
    }
    // return data;
    return data;
  }

  static marketWatchBottomSheet(context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return new StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              color: Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Market ",
                          style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Funds", style: Utils.fonts(size: 13.0, color: Utils.greyColor.withOpacity(0.7), fontWeight: FontWeight.w500)),
                                Obx(() {
                                  return Text(
                                    LimitController.limitData.value.availableMargin.toString(),
                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                                  );
                                }),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddFunds()));
                                  },
                                  child: Text("+ Add Funds", style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w500, color: Utils.mediumGreenColor)),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Portfolio", style: Utils.fonts(size: 13.0, color: Utils.greyColor.withOpacity(0.7), fontWeight: FontWeight.w500)),
                                Text("₹${HoldingController.totalVal2.value.toStringAsFixed(2)}",
                                    style: Utils.fonts(
                                      size: 18.0,
                                    )),
                                Text("37,425.7 (1.65%)", style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w500, color: Utils.mediumGreenColor)),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemCount: Dataconstants.marketWatchList.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index1) {
                            return Observer(builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: InkWell(
                                  onLongPress: () {
                                    return showModalBottomSheet(
                                      context: context,
                                      builder: (context) => ListView.builder(
                                          itemCount: Dataconstants.indicesMarketWatchListener.watchList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index2) => Column(children: [
                                                ListTile(
                                                  onTap: () {
                                                    // setState((){
                                                    //   Dataconstants.marketWatchList[index1] = (Dataconstants.indicesMarketWatchListener.watchList[index2]);
                                                    // });
                                                    Dataconstants.scripInfoModelInsert = null;
                                                    Dataconstants.scripInfoModelInsert = Dataconstants.indicesMarketWatchListener.watchList[index2];

                                                    Dataconstants.marketWatchList[index1] = Dataconstants.scripInfoModelInsert;
                                                    print(Dataconstants.marketWatchList[index1]);
                                                    print(Dataconstants.scripInfoModelInsert);
                                                    Navigator.of(context).pop();
                                                  },
                                                  // leading: Icon(
                                                  //
                                                  //
                                                  // ),
                                                  title: Text(
                                                    Dataconstants.indicesMarketWatchListener.watchList[index2].name,
                                                  ),
                                                ),
                                                Divider(
                                                  height: 1,
                                                )
                                              ])),
                                    ).then((value) => {setState(() {})});
                                  },
                                  onTap: () async {
                                    if (Dataconstants.marketWatchList[index1].name.toString() == "Nifty Bank") {
                                      CommonFunction.firebaseEvent(
                                        clientCode: "dummy",
                                        device_manufacturer: Dataconstants.deviceName,
                                        device_model: Dataconstants.devicemodel,
                                        eventId: "6.0.6.0.0",
                                        eventLocation: "body",
                                        eventMetaData: "dummy",
                                        eventName: "bank_nifty",
                                        os_version: Dataconstants.osName,
                                        location: "dummy",
                                        eventType: "Click",
                                        sessionId: "dummy",
                                        platform: Platform.isAndroid ? 'Android' : 'iOS',
                                        screenName: "guest user dashboard",
                                        serverTimeStamp: DateTime.now().toString(),
                                        source_metadata: "dummy",
                                        subType: "card",
                                      );
                                    }
                                    if (Dataconstants.marketWatchList[index1].name.toString() == "NIFTY") {
                                      CommonFunction.firebaseEvent(
                                        clientCode: "dummy",
                                        device_manufacturer: Dataconstants.deviceName,
                                        device_model: Dataconstants.devicemodel,
                                        eventId: "6.0.4.0.0",
                                        eventLocation: "body",
                                        eventMetaData: "dummy",
                                        eventName: "nifty",
                                        os_version: Dataconstants.osName,
                                        location: "dummy",
                                        eventType: "Click",
                                        sessionId: "dummy",
                                        platform: Platform.isAndroid ? 'Android' : 'iOS',
                                        screenName: "guest user dashboard",
                                        serverTimeStamp: DateTime.now().toString(),
                                        source_metadata: "dummy",
                                        subType: "card",
                                      );
                                    }
                                    if (Dataconstants.marketWatchList[index1].name.toString() == "USDINR") {
                                      CommonFunction.firebaseEvent(
                                        clientCode: "dummy",
                                        device_manufacturer: Dataconstants.deviceName,
                                        device_model: Dataconstants.devicemodel,
                                        eventId: "6.0.7.0.0",
                                        eventLocation: "body",
                                        eventMetaData: "dummy",
                                        eventName: "usd_inr",
                                        os_version: Dataconstants.osName,
                                        location: "dummy",
                                        eventType: "Click",
                                        sessionId: "dummy",
                                        platform: Platform.isAndroid ? 'Android' : 'iOS',
                                        screenName: "guest user dashboard",
                                        serverTimeStamp: DateTime.now().toString(),
                                        source_metadata: "dummy",
                                        subType: "card",
                                      );
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ScriptInfo(
                                                CommonFunction.getScripDataModel(exch: Dataconstants.marketWatchList[index1].exch, exchCode: Dataconstants.marketWatchList[index1].exchCode), false)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.circular(10.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            child: Text(Dataconstants.marketWatchList[index1].name.toString(), style: Utils.fonts(size: 13.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                          ),
                                          FittedBox(
                                            child: Observer(
                                                builder: (_) => Text(
                                                    Dataconstants.marketWatchList[index1].close == 0
                                                        ? Dataconstants.marketWatchList[index1].prevDayClose.toStringAsFixed(2)
                                                        : Dataconstants.marketWatchList[index1].close.toStringAsFixed(2),
                                                    style: Utils.fonts(
                                                      size: 15.0,
                                                    ))),
                                          ),
                                          FittedBox(
                                              child: Observer(
                                            builder: (_) => Text(
                                                Dataconstants.marketWatchList[index1].priceChangeText.toString() + " " + Dataconstants.marketWatchList[index1].percentChangeText.toString(),
                                                style: Utils.fonts(size: 13.0, color: Dataconstants.marketWatchList[index1].percentChange >= 0 ? ThemeConstants.buyColor : ThemeConstants.sellColor)),
                                          )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          // SmallSimpleLineChart(
                                          //   seriesList: Dataconstants
                                          //       .marketWatchList[index]
                                          //       .dataPoint[15],
                                          //   prevClose: Dataconstants
                                          //       .marketWatchList[index]
                                          //       .prevDayClose,
                                          //   name: Dataconstants
                                          //       .marketWatchList[index].name,
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  static getCurrencyFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Currency': []};
    var resultsCurr = Dataconstants.exchData[3].findModelsForSearchCurrencyFO(["usd"]);
    var resultsBseCurr = Dataconstants.exchData[4].findModelsForSearchCurrencyFO(["usd"]);
    final currCombined = zip(
      resultsCurr['CurrFut'],
      resultsBseCurr['CurrFut'],
    ).toList();
    stockItems['Currency'].addAll(currCombined);
    for (var i = 0; i < stockItems["Currency"].length; i++) {
      if (stockItems["Currency"][i].name.toString().toUpperCase() == "USDINR") return stockItems["Currency"][i];
    }
  }

  static getEuroCurrencyFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Currency': []};
    var resultsCurr = Dataconstants.exchData[3].findModelsForSearchCurrencyFO(["eur"]);
    var resultsBseCurr = Dataconstants.exchData[4].findModelsForSearchCurrencyFO(["eur"]);
    final currCombined = zip(
      resultsCurr['CurrFut'],
      resultsBseCurr['CurrFut'],
    ).toList();
    stockItems['Currency'].addAll(currCombined);
    for (var i = 0; i < stockItems["Currency"].length; i++) {
      if (stockItems["Currency"][i].name.toString().toUpperCase() == "EURINR") return stockItems["Currency"][i];
    }
  }

  static getGbpCurrencyFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Currency': []};
    var resultsCurr = Dataconstants.exchData[3].findModelsForSearchCurrencyFO(["gbp"]);
    var resultsBseCurr = Dataconstants.exchData[4].findModelsForSearchCurrencyFO(["gbp"]);
    final currCombined = zip(
      resultsCurr['CurrFut'],
      resultsBseCurr['CurrFut'],
    ).toList();
    stockItems['Currency'].addAll(currCombined);
    for (var i = 0; i < stockItems["Currency"].length; i++) {
      if (stockItems["Currency"][i].name.toString().toUpperCase() == "GBPINR") return stockItems["Currency"][i];
    }
  }

  static getJpyCurrencyFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Currency': []};
    var resultsCurr = Dataconstants.exchData[3].findModelsForSearchCurrencyFO(["jpy"]);
    var resultsBseCurr = Dataconstants.exchData[4].findModelsForSearchCurrencyFO(["jpy"]);
    final currCombined = zip(
      resultsCurr['CurrFut'],
      resultsBseCurr['CurrFut'],
    ).toList();
    stockItems['Currency'].addAll(currCombined);
    for (var i = 0; i < stockItems["Currency"].length; i++) {
      if (stockItems["Currency"][i].name.toString().toUpperCase() == "JPYINR") return stockItems["Currency"][i];
    }
  }

  static getGoldMCXFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Commodity': []};
    var resultsFO = Dataconstants.exchData[5].findModelsForSearch(["gold"]);
    if (resultsFO.length > 0) {
      stockItems['Commodity'].addAll(resultsFO);
    }
    for (var i = 0; i < stockItems["Commodity"].length; i++) {
      if (stockItems["Commodity"][i].name.toString().toUpperCase() == "GOLD") return stockItems["Commodity"][i];
    }
  }

  static getSilverMCXFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Commodity': []};
    var resultsFO = Dataconstants.exchData[5].findModelsForSearch(["silver"]);
    if (resultsFO.length > 0) {
      stockItems['Commodity'].addAll(resultsFO);
    }
    for (var i = 0; i < stockItems["Commodity"].length; i++) {
      if (stockItems["Commodity"][i].name.toString().toUpperCase() == "SILVER") return stockItems["Commodity"][i];
    }
  }

  static getNaturalGasMCXFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Commodity': []};
    var resultsFO = Dataconstants.exchData[5].findModelsForSearch(["natural"]);
    if (resultsFO.length > 0) {
      stockItems['Commodity'].addAll(resultsFO);
    }
    for (var i = 0; i < stockItems["Commodity"].length; i++) {
      if (stockItems["Commodity"][i].name.toString().toUpperCase() == "NATURALGAS") return stockItems["Commodity"][i];
    }
  }

  static getCrudeOilMCXFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Commodity': []};
    var resultsFO = Dataconstants.exchData[5].findModelsForSearch(["crude"]);
    if (resultsFO.length > 0) {
      stockItems['Commodity'].addAll(resultsFO);
    }
    for (var i = 0; i < stockItems["Commodity"].length; i++) {
      if (stockItems["Commodity"][i].name.toString().toUpperCase() == "CRUDEOIL") return stockItems["Commodity"][i];
    }
  }

  static getCopperMCXFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Commodity': []};
    var resultsFO = Dataconstants.exchData[5].findModelsForSearch(["copper"]);
    if (resultsFO.length > 0) {
      stockItems['Commodity'].addAll(resultsFO);
    }
    for (var i = 0; i < stockItems["Commodity"].length; i++) {
      if (stockItems["Commodity"][i].name.toString().toUpperCase() == "COPPER") return stockItems["Commodity"][i];
    }
  }

  static getBankNiftyFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'Cash': []};
    var resultsNse = Dataconstants.exchData[0].findModelsForSearchNse(["bank", "nifty"]);
    var resultsBse = Dataconstants.exchData[2].findModelsForSearchBse(["bank", "nifty"]);
    final eqCombined = zip(
      resultsNse['NseEq'],
      resultsBse['BseEq'],
    ).toList();
    stockItems['Cash'].addAll(eqCombined);
    for (var i = 0; i < stockItems["Cash"].length; i++) {
      if (stockItems["Cash"][i].name.toString().toUpperCase() == "NIFTY BANK") return stockItems["Cash"][i];
    }
  }

  static getPaymentAccessTokenFund() async {
    var header = {"application": "Intellect"};

    var stringResponse = await CommonFunction.getPaymentAccessToken(header);

    var jsonResponse = jsonDecode(stringResponse);

    print("Get access token: ${jsonResponse}");

    Dataconstants.fundstoken = await jsonResponse['data'];

    // getBankdetails();

    await Dataconstants.bankDetailsController.getBankDetails();

    // getItems();

    print(Dataconstants.fundstoken);

    // getBankdetails();

    return Dataconstants.fundstoken;
  }

  static getLastDates(int type) {
    try {
      var todayDate = DateTime.now();
      var last30Days = new DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
      var last10Days = new DateTime(todayDate.year, todayDate.month, todayDate.day - 10);
      productType = 'Last 10 Days';
      productItems = {
        'Last 30 Days': last30Days.toString(),
        'Last 10 Days': last10Days.toString(),
      };
      FundTransactionControlller.getFundTransactionListItems.clear();
      type == 1
          ? Dataconstants.fundTransactionController
              .getPayoutRequest(fromdate: last10Days.toString().split(" ")[0], todate: DateTime.now().toString().split(" ")[0], token: Dataconstants.fundstoken, payType: 3)
          : Dataconstants.payInController.getPayInRequest(fromdate: last10Days.toString().split(" ")[0], todate: DateTime.now().toString().split(" ")[0], token: Dataconstants.fundstoken, payType: 2);
    } catch (e, s) {
      print(e);
    }
  }

  static getpaymentstatus() async {
    try {
      var header = {
        "from": "2022-11-10",
        "to": "2022-11-16",
        "payType": "2",
        "token": Dataconstants.fundstoken,
      };

      var stringResponse = await CommonFunction.getPaymentStauts(header);

      var jsonResponse = jsonDecode(stringResponse);

      if (jsonResponse == null || jsonResponse == '') {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  /* ifContainsWord function used to return bool if contain the user input words and input Search */
  bool ifContainsWord(List<String> words, String inputSearch) {
    bool found = true;
    inputSearch = inputSearch.toLowerCase();
    for (int i = 0; i < words.length; i++) {
      if (!inputSearch.contains(words[i])) {
        found = false;
        break;
      }
    }
    return found;
  }

  Map<String, List<ScripStaticModel>> findModelsForSearchNse(List<String> words) {
    List<ScripStaticModel> resultEq = [];
    List<ScripStaticModel> resultRest = [];
    int counter = 0;
    for (int i = 0; i < _scripStaticData.length; i++) {
      if (counter >= 100) break;
      if (_scripStaticData[i].series == 'EQ') {
        if (ifContainsWord(words, _scripStaticData[i].name) || ifContainsWord(words, _scripStaticData[i].desc.replaceAll(' ', ''))) {
          resultEq.add(_scripStaticData[i]);
          counter++;
        }
      } else {
        if (ifContainsWord(words, _scripStaticData[i].name) || ifContainsWord(words, _scripStaticData[i].desc.replaceAll(' ', ''))) {
          resultRest.add(_scripStaticData[i]);
          counter++;
        }
      }
    }
    return {'NseEq': resultEq, 'NseRest': resultRest};
  }

  static getNiftyFirstScript() {
    Map<String, List<ScripStaticModel>> stockItems = {'FO': []};
    var resultsFO = Dataconstants.exchData[1].findModelsForSearchFO(["nifty"]);
    if (resultsFO['FutIdx'].length > 0) {
      stockItems['FO'].addAll(resultsFO['FutIdx']);
    }
    for (var i = 0; i < stockItems["FO"].length; i++) {
      if (stockItems["FO"][i].name.toString().toUpperCase() == "NIFTY") return stockItems["FO"][i];
    }
  }

  static getOtherAssets() {
    Dataconstants.otherAssets = [];
    var gold = CommonFunction.getGoldMCXFirstScript();
    var finalGold = CommonFunction.getScripDataModel(
      exch: gold.exch,
      exchCode: gold.exchCode,
      getNseBseMap: false,
      sendReq: false,
    );
    Dataconstants.otherAssets.add(finalGold);
    var silver = CommonFunction.getSilverMCXFirstScript();
    var finalSilver = CommonFunction.getScripDataModel(
      exch: silver.exch,
      exchCode: silver.exchCode,
      getNseBseMap: false,
      sendReq: false,
    );
    Dataconstants.otherAssets.add(finalSilver);
    var copper = CommonFunction.getCopperMCXFirstScript();
    var finalCopper = CommonFunction.getScripDataModel(
      exch: copper.exch,
      exchCode: copper.exchCode,
      getNseBseMap: false,
      sendReq: false,
    );
    Dataconstants.otherAssets.add(finalCopper);
    var naturalGas = CommonFunction.getNaturalGasMCXFirstScript();
    var finalNaturalGas = CommonFunction.getScripDataModel(
      exch: naturalGas.exch,
      exchCode: naturalGas.exchCode,
      getNseBseMap: false,
      sendReq: false,
    );
    Dataconstants.otherAssets.add(finalNaturalGas);
    var crudeOil = CommonFunction.getCrudeOilMCXFirstScript();
    var finalCrudeOil = CommonFunction.getScripDataModel(
      exch: crudeOil.exch,
      exchCode: crudeOil.exchCode,
      getNseBseMap: false,
      sendReq: false,
    );
    Dataconstants.otherAssets.add(finalCrudeOil);
    var euro = CommonFunction.getEuroCurrencyFirstScript();
    var finalEuro = CommonFunction.getScripDataModel(
      exch: euro.exch,
      exchCode: euro.exchCode,
      getNseBseMap: false,
      sendReq: false,
    );
    Dataconstants.otherAssets.add(finalEuro);
    var jpy = CommonFunction.getJpyCurrencyFirstScript();
    var finalJpy = CommonFunction.getScripDataModel(
      exch: jpy.exch,
      exchCode: jpy.exchCode,
      getNseBseMap: false,
      sendReq: false,
    );
    Dataconstants.otherAssets.add(finalJpy);
    var gbp = CommonFunction.getGbpCurrencyFirstScript();
    var finalGbp = CommonFunction.getScripDataModel(
      exch: gbp.exch,
      exchCode: gbp.exchCode,
      getNseBseMap: false,
      sendReq: false,
    );
    Dataconstants.otherAssets.add(finalGbp);
    return true;
  }

  static getMarketWatch() {
    Dataconstants.marketWatchList = [];
    var banknifty = CommonFunction.getBankNiftyFirstScript();
    var finalBankNifty = CommonFunction.getScripDataModel(
      exch: banknifty.exch,
      exchCode: banknifty.exchCode,
      getNseBseMap: true,
      sendReq: true,
      getChartDataTime: 15,
    );
    Dataconstants.marketWatchList.add(finalBankNifty);
    var nifty = CommonFunction.getNiftyFirstScript();
    var finalNifty = CommonFunction.getScripDataModel(
      exch: nifty.exch,
      exchCode: nifty.exchCode,
      getNseBseMap: true,
      sendReq: true,
      getChartDataTime: 15,
    );
    Dataconstants.marketWatchList.add(finalNifty);
    var currency = CommonFunction.getCurrencyFirstScript();
    var finalCurrency = CommonFunction.getScripDataModel(
      exch: currency.exch,
      exchCode: currency.exchCode,
      getNseBseMap: true,
      sendReq: true,
      getChartDataTime: 15,
    );
    Dataconstants.marketWatchList.add(finalCurrency);
    var commodity = CommonFunction.getGoldMCXFirstScript();
    var finalGold = CommonFunction.getScripDataModel(
      exch: commodity.exch,
      exchCode: commodity.exchCode,
      getNseBseMap: true,
      sendReq: true,
      getChartDataTime: 15,
    );
    Dataconstants.marketWatchList.add(finalGold);
    return true;
  }

  static getWatchList(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "Watchlistoperation", requestJson, Dataconstants.loginData.data.jwtToken);
    // //log("get watchlist response - ${response.body.toString()}");
    return response.body.toString();
  }

  static setDefault(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("defaultWatchList", index);
    Dataconstants.defaultWatchList = index;
    return true;
  }

  static unSetDefault(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("defaultWatchList", -1);
    Dataconstants.defaultWatchList = -1;
    return true;
  }

  static bottomSheetBar() {
    return Container(
      height: 2,
      width: 30,
      decoration: BoxDecoration(
        color: Utils.lightGreyColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  static bottomSheet(BuildContext context, String title, {String comingFrom}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    JsonEncoder Json = JsonEncoder();
    var selectColorMode;
    bool rating1, rating2, rating3, rating4, rating5, _isCash = true, _isFuture = false, _isOption = false;
    String orderType, productTypeEquity, productTypeDerivative;
    TextEditingController _cashQtyContoller = TextEditingController();
    TextEditingController _futureLotQtyContoller = TextEditingController();
    TextEditingController _optionLotQtyContoller = TextEditingController();
    TextEditingController _numPadController = TextEditingController();
    if (title == 'Rate Us') {
      rating1 = false;
      rating2 = false;
      rating3 = false;
      rating4 = false;
      rating5 = false;
    }
    if (title == 'Order Settings') {
      orderType = (prefs.getString('orderType') == null || prefs.getString('orderType') == '') ? 'limit' : prefs.getString('orderType');
      productTypeEquity = (prefs.getString('productTypeEquity') == null || prefs.getString('productTypeEquity') == '') ? 'CNC' : prefs.getString('productTypeEquity');
      productTypeDerivative = (prefs.getString('productTypeDerivative') == null || prefs.getString('productTypeDerivative') == '') ? 'NRML' : prefs.getString('productTypeDerivative');
      _cashQtyContoller.text = (prefs.getInt('equityDefaultQty') == null || prefs.getInt('equityDefaultQty') == -1) ? '1' : prefs.getInt('equityDefaultQty').toString();
      _futureLotQtyContoller.text = (prefs.getInt('futureDefaultQty') == null || prefs.getInt('futureDefaultQty') == -1) ? '1' : prefs.getInt('futureDefaultQty').toString();
      _optionLotQtyContoller.text = (prefs.getInt('optionDefaultQty') == null || prefs.getInt('optionDefaultQty') == -1) ? '1' : prefs.getInt('optionDefaultQty').toString();
    }

    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0)),
      ),
      context: context,
      builder: (context) {
        if (title == 'Logout') {
          return Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              bottomSheetBar(),
              const SizedBox(
                height: 30,
              ),
              SvgPicture.asset('assets/appImages/logout_blue.svg'),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Logout from Blink Trade",
                style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Are you sure you want to logout from the app? ",
                style: Utils.fonts(
                  size: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Utils.greyColor,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Divider(
                // thickness: 1,
                color: Utils.lightGreyColor,
              ),
              const SizedBox(
                height: 15,
              ),
              CommonFunction.saveAndCancelButton(
                  cancelText: 'Cancel',
                  SaveText: 'Yes',
                  cancelCall: () {
                    Navigator.pop(context);
                  },
                  saveCall: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);
                  }),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        } else if (title == 'Rate Us') {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                bottomSheetBar(),
                const SizedBox(
                  height: 30,
                ),
                SvgPicture.asset('assets/appImages/rate_us.svg'),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "How was your experience?",
                  style: Utils.fonts(
                    size: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Text(
                    "We work super had to serve you better & would love to know how you rate our app",
                    style: Utils.fonts(
                      size: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Utils.greyColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          rating1 = !rating1;
                          if (!rating1) {
                            rating2 = false;
                            rating3 = false;
                            rating4 = false;
                            rating5 = false;
                          }
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 35,
                        color: rating1 ? Utils.lightyellowColor : Utils.lightGreyColor.withOpacity(0.2),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          rating2 = !rating2;
                          if (rating2) {
                            rating1 = true;
                          } else {
                            rating3 = false;
                            rating4 = false;
                            rating5 = false;
                          }
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 35,
                        color: rating2 ? Utils.lightyellowColor : Utils.lightGreyColor.withOpacity(0.2),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          rating3 = !rating3;
                          if (rating3) {
                            rating1 = true;
                            rating2 = true;
                          } else {
                            rating4 = false;
                            rating5 = false;
                          }
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 35,
                        color: rating3 ? Utils.lightyellowColor : Utils.lightGreyColor.withOpacity(0.2),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          rating4 = !rating4;
                          if (rating4) {
                            rating1 = true;
                            rating2 = true;
                            rating3 = true;
                          } else {
                            rating5 = false;
                          }
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 35,
                        color: rating4 ? Utils.lightyellowColor : Utils.lightGreyColor.withOpacity(0.2),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          rating5 = !rating5;
                          if (rating5) {
                            rating1 = true;
                            rating2 = true;
                            rating3 = true;
                            rating4 = true;
                          }
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 35,
                        color: rating5 ? Utils.lightyellowColor : Utils.lightGreyColor.withOpacity(0.2),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                CommonFunction.saveAndCancelButton(
                    cancelText: 'Cancel',
                    SaveText: 'Rate Us',
                    cancelCall: () {
                      Navigator.pop(context);
                    },
                    saveCall: () {}),
                const SizedBox(
                  height: 15,
                ),
              ],
            );
          });
        } else if (title == 'Upgrade App') {
          return Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              bottomSheetBar(),
              const SizedBox(
                height: 30,
              ),
              SvgPicture.asset('assets/appImages/rate_us.svg'),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Update your app in Background",
                style: Utils.fonts(
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Your ',
                      style: Utils.fonts(
                        size: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Utils.greyColor,
                      ),
                      children: [
                    TextSpan(
                      text: 'Blink Trade ',
                      style: Utils.fonts(
                        size: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'app is now faster and better.',
                    ),
                  ])),
              Text(
                "Please update to the latest version",
                style: Utils.fonts(
                  size: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Utils.greyColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                // thickness: 1,
                color: Utils.lightGreyColor,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 140,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Update App",
                      style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )))),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        } else if (title == 'SETMPIN') {
          return Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              bottomSheetBar(),
              const SizedBox(
                height: 30,
              ),
              SvgPicture.asset('assets/appImages/successful.svg'),
              const SizedBox(
                height: 30,
              ),
              Text(
                "MPIN Registered",
                style: Utils.fonts(
                  size: 16.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Successfully",
                style: Utils.fonts(
                  size: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(
                      onPressed: () async {
                        // requestFingerprintAccess(context);
                        if (Dataconstants.resetMPin) {
                          CommonFunction.setUsernamePass(
                              userName: Dataconstants.feUserID, password: Dataconstants.feUserPassword1, accessPin: Dataconstants.confirmMPin, biometricCode: Dataconstants.biometriccode);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => ValidateMPIN(isSettingScreen: false),
                            ),
                          );
                          // Dataconstants.resetMPin = false;
                        } else if (Dataconstants.changeMPin) {
                          CommonFunction.setUsernamePass(
                              userName: Dataconstants.feUserID, password: Dataconstants.feUserPassword1, accessPin: Dataconstants.confirmMPin, biometricCode: Dataconstants.biometriccode);
                          Dataconstants.changeMPin = false;
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pop(context);
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if (prefs.getBool('BiometricEnabled') == null || prefs.getBool('BiometricEnabled') == false)
                            bottomSheet(context, "REGISTERBIOMETRIC", comingFrom: "setMPIN");
                          else {
                            CommonFunction.setUsernamePass(userName: Dataconstants.feUserID, password: Dataconstants.feUserPassword1, accessPin: Dataconstants.confirmMPin, biometricCode: "");
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => MainScreen(
                                    changePassword: false,
                                    message: 'SUCCESS',
                                  ),
                                ),
                                (route) => false);
                          }
                        }
                      },
                      child: Text(
                        Dataconstants.changeMPin ? "DONE" : "CONTINUE TO ${Dataconstants.resetMPin ? "RELOGIN" : "APP"}",
                        style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )))),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        } else if (title == 'REGISTERBIOMETRIC') {
          return Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              bottomSheetBar(),
              const SizedBox(
                height: 30,
              ),
              SvgPicture.asset('assets/appImages/face.svg'),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Biometric",
                style: Utils.fonts(
                  size: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Do you want to enable Biometric Login? You can change this setting later in Settings page.",
                  style: Utils.fonts(
                    size: 16.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              saveAndCancelButton(
                  SaveText: "Allow",
                  cancelText: "Cancel",
                  saveCall: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    var biometrics = await CommonFunction.isBiometricAvailable();
                    InAppSelection.isBioMetricAvailable = biometrics.isNotEmpty;

                    if (InAppSelection.isBioMetricAvailable) {
                      InAppSelection.fingerPrintEnabled = true;
                      prefs.setBool('FingerprintEnabled', true);
                    } else {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     backgroundColor: Utils.greyColor,
                      //     content: Text('Biometric is not enabled in your device.'),
                      //     duration: Duration(seconds: 2),
                      //   );
                      // );
                      CommonFunction.showBasicToast("Biometric is not enabled in your device.");
                    }

                    Navigator.pop(context);

                    CommonFunction.setUsernamePass(
                        userName: Dataconstants.feUserID, password: Dataconstants.feUserPassword1, accessPin: Dataconstants.confirmMPin, biometricCode: Dataconstants.biometriccode);
                    bottomSheet(context, "BIOMETRIC", comingFrom: comingFrom);
                    InAppSelection.isBiometricEnable = true;
                    prefs.setBool('BiometricEnabled', true);
                  },
                  cancelCall: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('BiometricEnabled', false);
                    prefs.setBool('FingerprintEnabled', false);
                    InAppSelection.isBiometricEnable = false;
                    InAppSelection.fingerPrintEnabled = false;

                    CommonFunction.setUsernamePass(
                        userName: Dataconstants.feUserID, password: Dataconstants.feUserPassword1, accessPin: Dataconstants.confirmMPin, biometricCode: Dataconstants.biometriccode);
                    // CommonFunction.bottomSheet(context,"SETMPIN");
                    Navigator.pop(context);
                    if (comingFrom != 'validateMPIN')
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => MainScreen(
                              changePassword: false,
                              message: 'SUCCESS',
                            ),
                          ),
                          (route) => false);
                  }),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        } else if (title == 'BIOMETRIC') {
          return Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              bottomSheetBar(),
              const SizedBox(
                height: 30,
              ),
              SvgPicture.asset('assets/appImages/successful.svg'),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Biometric Registered",
                style: Utils.fonts(
                  size: 16.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Successfully",
                style: Utils.fonts(
                  size: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        if (comingFrom == 'validateMPIN')
                          Navigator.of(context).pop();
                        else
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => MainScreen(
                                  changePassword: false,
                                  message: 'SUCCESS',
                                ),
                              ),
                              (route) => false);
                      },
                      child: Text(
                        comingFrom == 'validateMPIN' ? "DONE" : "CONTINUE TO APP",
                        style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )))),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          );
        } else if (title == 'Order Settings') {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: SafeArea(
                child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  final _defaultOrderController = ValueNotifier<bool>(false);
                  _defaultOrderController.addListener(() {
                    setState(() {});
                  });
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: bottomSheetBar(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              "Default Order Settings",
                              style: Utils.fonts(
                                size: 16.0,
                              ),
                            ),
                            Spacer(),
                            ToggleSwitch(
                              switchController: _defaultOrderController,
                              isBorder: false,
                              activeColor: Utils.primaryColor,
                              inactiveColor: Utils.lightGreyColor.withOpacity(0.2),
                              thumbColor: Utils.greyColor,
                            )
                            //: SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price",
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: Border.all(color: Utils.lightGreyColor.withOpacity(0.5))),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        orderType = 'limit';
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: orderType == 'limit' ? Border.all(color: Utils.primaryColor) : null),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                      child: Text(
                                        'LIMIT',
                                        style: Utils.fonts(
                                            size: 11.0, fontWeight: orderType == 'limit' ? FontWeight.w600 : FontWeight.w400, color: orderType == 'limit' ? Utils.primaryColor : Utils.lightGreyColor),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        orderType = 'market';
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: orderType == 'market' ? Border.all(color: Utils.primaryColor) : null),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                      child: Text(
                                        'MARKET',
                                        style: Utils.fonts(
                                            size: 11.0,
                                            fontWeight: orderType == 'market' ? FontWeight.w600 : FontWeight.w400,
                                            color: orderType == 'market' ? Utils.primaryColor : Utils.lightGreyColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Product for Equity",
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: Border.all(color: Utils.lightGreyColor.withOpacity(0.5))),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          productTypeEquity = 'NRML';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: productTypeEquity == 'NRML' ? Border.all(color: Utils.primaryColor) : null),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        child: Text(
                                          'NRML',
                                          style: Utils.fonts(
                                              size: 11.0,
                                              fontWeight: productTypeEquity == 'NRML' ? FontWeight.w600 : FontWeight.w400,
                                              color: productTypeEquity == 'NRML' ? Utils.primaryColor : Utils.lightGreyColor),
                                        ),
                                      ),
                                    ),
                                    if (productTypeEquity == 'MIS')
                                      VerticalDivider(
                                        color: Utils.lightGreyColor.withOpacity(0.5),
                                        thickness: 1,
                                        width: 1,
                                      ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          productTypeEquity = 'CNC';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: productTypeEquity == 'CNC' ? Border.all(color: Utils.primaryColor) : null),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        child: Text(
                                          'CNC',
                                          style: Utils.fonts(
                                              size: 11.0,
                                              fontWeight: productTypeEquity == 'CNC' ? FontWeight.w600 : FontWeight.w400,
                                              color: productTypeEquity == 'CNC' ? Utils.primaryColor : Utils.lightGreyColor),
                                        ),
                                      ),
                                    ),
                                    if (productTypeEquity == 'NRML')
                                      VerticalDivider(
                                        color: Utils.lightGreyColor.withOpacity(0.5),
                                        thickness: 1,
                                        width: 1,
                                      ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          productTypeEquity = 'MIS';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: productTypeEquity == 'MIS' ? Border.all(color: Utils.primaryColor) : null),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        child: Text(
                                          'MIS',
                                          style: Utils.fonts(
                                              size: 11.0,
                                              fontWeight: productTypeEquity == 'MIS' ? FontWeight.w600 : FontWeight.w400,
                                              color: productTypeEquity == 'MIS' ? Utils.primaryColor : Utils.lightGreyColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Product for F&O",
                              style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: Border.all(color: Utils.lightGreyColor.withOpacity(0.5))),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        productTypeDerivative = 'NRML';
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: productTypeDerivative == 'NRML' ? Border.all(color: Utils.primaryColor) : null),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                      child: Text(
                                        'NRML',
                                        style: Utils.fonts(
                                            size: 11.0,
                                            fontWeight: productTypeDerivative == 'NRML' ? FontWeight.w600 : FontWeight.w400,
                                            color: productTypeDerivative == 'NRML' ? Utils.primaryColor : Utils.lightGreyColor),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        productTypeDerivative = 'MIS';
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: productTypeDerivative == 'MIS' ? Border.all(color: Utils.primaryColor) : null),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                      child: Text(
                                        'MIS',
                                        style: Utils.fonts(
                                            size: 11.0,
                                            fontWeight: productTypeDerivative == 'MIS' ? FontWeight.w600 : FontWeight.w400,
                                            color: productTypeDerivative == 'MIS' ? Utils.primaryColor : Utils.lightGreyColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'DEFAULT QUANTITY FOR',
                          style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 55,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Utils.lightGreyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isCash = true;
                                          _isFuture = false;
                                          _isOption = false;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: _isCash ? Utils.brightGreenColor.withOpacity(0.4) : Colors.transparent,
                                        ),
                                        child: Text('EQUITY',
                                            style: Utils.fonts(
                                              size: 12.0,
                                            )),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isFuture = true;
                                          _isCash = false;
                                          _isOption = false;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: _isFuture ? Utils.brightGreenColor.withOpacity(0.4) : Colors.transparent,
                                        ),
                                        child: Text('FUTURE',
                                            style: Utils.fonts(
                                              size: 12.0,
                                            )),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isOption = true;
                                          _isCash = false;
                                          _isFuture = false;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: _isOption ? Utils.brightGreenColor.withOpacity(0.4) : Colors.transparent,
                                        ),
                                        child: Text('OPTION',
                                            style: Utils.fonts(
                                              size: 12.0,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _isCash
                            ? Text(
                                'ENTER QUANTITY',
                                style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                              )
                            : Text(
                                'ENTER LOTS',
                                style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                              ),
                        const SizedBox(
                          height: 5,
                        ),
                        Visibility(
                          visible: _isCash,
                          child: NumberField(
                            maxLength: 10,
                            numberController: _cashQtyContoller,
                            hint: 'Quantity',
                            isInteger: true,
                            isBuy: true,
                            isRupeeLogo: false,
                            isDisable: false,
                          ),
                        ),
                        Visibility(
                          visible: _isFuture,
                          child: NumberField(
                            maxLength: 10,
                            numberController: _futureLotQtyContoller,
                            hint: 'Lots',
                            isInteger: true,
                            isBuy: true,
                            isRupeeLogo: false,
                            isDisable: false,
                          ),
                        ),
                        Visibility(
                          visible: _isOption,
                          child: NumberField(
                            maxLength: 10,
                            numberController: _optionLotQtyContoller,
                            hint: 'Lots',
                            isInteger: true,
                            isBuy: true,
                            isRupeeLogo: false,
                            isDisable: false,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Visibility(
                          visible: Dataconstants.showOrderFormKeyboard,
                          child: NumPad(
                            isInt: true,
                            controller: _numPadController,
                            delete: () {
                              var cursorPos = _numPadController.selection.base.offset;
                              // //print('cursorPos -- $cursorPos');
                              _numPadController.text = _numPadController.text.substring(0, cursorPos - 1) + _numPadController.text.substring(cursorPos, _numPadController.text.length);
                              _numPadController.value = _numPadController.value.copyWith(selection: TextSelection.fromPosition(TextPosition(offset: cursorPos - 1)));
                              // _numPadController.text =
                              //     _numPadController.text.substring(0, _numPadController.text.length - 1);
                            },
                            onSubmit: () {
                              setState(() {
                                Dataconstants.showOrderFormKeyboard = false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CommonFunction.saveAndCancelButton(
                            cancelText: 'Cancel',
                            SaveText: 'Save',
                            cancelCall: () {
                              orderType = prefs.getString('orderType');
                              productTypeEquity = prefs.getString('productTypeEquity');
                              productTypeDerivative = prefs.getString('productTypeDerivative');
                              _cashQtyContoller.text = prefs.getInt('equityDefaultQty').toString();
                              _futureLotQtyContoller.text = prefs.getInt('futureDefaultQty').toString();
                              _optionLotQtyContoller.text = prefs.getInt('optionDefaultQty').toString();
                              Navigator.pop(context);
                            },
                            saveCall: () async {
                              var settingJson = jsonEncode({
                                "orderType": orderType,
                                "productTypeEquity": productTypeEquity,
                                "productTypeDerivative": productTypeDerivative,
                                "qtyCash": _cashQtyContoller.text,
                                "qtyFuture": _futureLotQtyContoller.text,
                                "qtyOption": _optionLotQtyContoller.text,
                              });
                              var jsonRequest = {
                                "LoginID": Dataconstants.feUserID,
                                "Type": "order", //order for Ordersetting
                                "Operation": Dataconstants.isUpdateOrderSettings == true ? "UPDATE" : "INSERT",
                                "Setting": settingJson,
                              };
                              // log('settings payload -- $jsonRequest');
                              var result = await CommonFunction.orderSettings(jsonRequest);
                              // //log("insert/update order settings --- $result");
                              try {
                                var response = jsonDecode(result);
                                if (response["status"] == false) {
                                  CommonFunction.showBasicToast(response["emsg"].toString());
                                } else {
                                  if (response['message'] == "Success") {
                                    if (response['data'][0]['Msg'] == 'order Setting Modified Successfully') {
                                      InAppSelection.orderType = orderType;
                                      InAppSelection.productTypeEquity = productTypeEquity;
                                      InAppSelection.productTypeDerivative = productTypeDerivative;
                                      InAppSelection.equityDefaultQty = int.tryParse(_cashQtyContoller.text);
                                      InAppSelection.futureDefaultQty = int.tryParse(_futureLotQtyContoller.text);
                                      InAppSelection.optionDefaultQty = int.tryParse(_optionLotQtyContoller.text);
                                      prefs.setString('orderType', orderType);
                                      prefs.setString('productTypeEquity', productTypeEquity);
                                      prefs.setString('productTypeDerivative', productTypeDerivative);
                                      prefs.setInt('equityDefaultQty', int.tryParse(_cashQtyContoller.text));
                                      prefs.setInt('futureDefaultQty', int.tryParse(_futureLotQtyContoller.text));
                                      prefs.setInt('optionDefaultQty', int.tryParse(_optionLotQtyContoller.text));
                                    }
                                  }
                                }
                              } catch (e) {
                                var jsons = json.decode(result);
                                CommonFunction.showBasicToast(jsons["message"].toString());
                              }
                              Navigator.pop(context);
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        } else
          return null;
      },
      backgroundColor: Utils.whiteColor,
    ).then((value) {
      if (title == 'Order Settings') Dataconstants.showOrderFormKeyboard = false;
    });
  }

  static getDefault() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dataconstants.defaultWatchList = prefs.get("defaultWatchList") ?? -1;
  }

  static createBasket(requestJson) async {
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + "api/Basket", requestJson, Dataconstants.loginData.data.jwtToken);
    // //log("create basket response - ${response.body.toString()}");
    return jsonDecode(response.body.toString());
  }

  static modifyBasket(requestJson) async {
    try {
      http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + "api/Basket", requestJson, Dataconstants.loginData.data.jwtToken);
      // //log("modify basket response - ${response.body.toString()}");
      return response.body.toString();
    } catch (e) {
      //print(e);
    }
  }

  static void setLoggedOut({
    bool isLoggedOut = false,
    bool delete = false,
  }) async {
    FirebaseCrashlytics.instance.setUserIdentifier('${BrokerInfo.brokerName}:${Dataconstants.feUserID}');
    FirebaseCrashlytics.instance.setUserIdentifier('${BrokerInfo.brokerName}:${Dataconstants.feUserID}');
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (delete) {
      pref.remove('isLoggedOut');
    } else {
      pref.setBool('isLoggedOut', isLoggedOut);
    }
  }

  static saveAndCancelButton({String cancelText, String SaveText, Function cancelCall, Function saveCall}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 40,
          child: ElevatedButton(
              onPressed: cancelCall,
              child: Text(
                "$cancelText",
                style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Utils.whiteColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    side: BorderSide(color: Utils.greyColor),
                    borderRadius: BorderRadius.circular(50.0),
                  )))),
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 140,
          height: 40,
          child: ElevatedButton(
              onPressed: saveCall,
              child: Text(
                "$SaveText",
                style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  )))),
        ),
      ],
    );
  }

  static void CustomToast(icon, message, isSvg) {
    Widget toast = Container(
      // padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Utils.whiteColor,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Utils.primaryColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSvg == 1)
              SvgPicture.asset(
                icon,
                height: 20,
                width: 20,
              ),
            if (isSvg == 2)
              Image.asset(
                icon,
                height: 20,
                width: 20,
              ),
            if (isSvg == 0)
              Icon(
                icon,
                size: 20,
              ),
            SizedBox(
              width: 12.0,
            ),
            Text(message),
          ],
        ),
      ),
    );

    Dataconstants.fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  static message(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/appImages/bellSmall.png'),
        const SizedBox(
          width: 5,
        ),
        Text(text, style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
      ],
    );
  }

  static writeLog(String fileName, String functionName, String details) async {
    try {
      var docPath = await getExternalStorageDirectory();
      var res = docPath.parent.path;
      var path = res + "/logs";
      var directoryForLog = await Directory(path).create();
      var date = new DateTime.now().toString();
      var dateParse = DateTime.parse(date);
      var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
      var fileObject = await File(directoryForLog.path + "/" + formattedDate + "-Log.txt").create();

      await fileObject.writeAsString(date.toString() + ':\n' + 'File Name:' + fileName + '\nFunction Name:' + functionName + '\nError:' + details + '\n', mode: FileMode.append, flush: true);
    } catch (ex, stackTrace) {
      await sendDataToCrashlytics(ex, stackTrace, 'CommonFunction-writeLog Exception');
    }
  }

  static bool isDevelopmentMode = false;

  static writeLogInInternalMemory(String fileName, String functionName, String details) async {
    if (!isDevelopmentMode) return;
    var docPath = await getExternalStorageDirectory();
    var res = docPath.parent.path;
    var path = res + "/SpiderErrorLogs";
    var directoryForLog = await Directory(path).create();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    // var fileObject = await File(directoryForLog.path + "/" + formattedDate + "-Log.txt").create();
    var fileObject = await File(directoryForLog.path + "/" + formattedDate + "-Log.txt").create();
    await fileObject.writeAsString(
        date.toString() +
            ':\n' +
            'File Name:' +
            fileName +
            '\nFunction Name:' +
            functionName +
            '\nDetails:' +
            details +
            '\n' +
            '-------------------------------------------------------------------------------------------\n',
        mode: FileMode.append,
        flush: true);
  }

  // JM

  static const platform = MethodChannel('samples.flutter.dev/tokens');

  static void setUsernamePass({
    String userName = "",
    String password = "",
    String accessPin = "",
    String biometricCode = "",
    bool delete = false,
  }) async {
    FirebaseCrashlytics.instance.setUserIdentifier('${BrokerInfo.brokerName}:${Dataconstants.feUserID}');
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (delete) {
      pref.remove('username');
      pref.remove('password');
      pref.remove('accessPin');
      pref.remove('biometriccode');
      /* Use this code when integrating acess code screen */
      // pref.remove('AcessCodeText');
    } else {
      pref.setString('biometriccode', biometricCode);
      pref.setString('username', userName);
      pref.setString('password', password);
      pref.setString('accessPin', accessPin);

      /* Use this code when integrating acess code screen */
      // pref.setString('AcessCodeText', accessPin);
    }
  }

  static removeAllCharts() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("predefinedChartTime");
    pref.remove("IndicesChartTime");
    pref.remove("MarketWatchChartTime");
  }

  static void firebaseCrashlytics(dynamic e, StackTrace s) {
    // FirebaseCrashlytics.instance.recordError(e, s);
  }

  // static Future<void> showNotification(RemoteMessage message) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails('your channel id', 'your channel name',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       ticker: 'ticker');
  //   const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await Dataconstants.flutterLocalNotificationsPlugin.show(
  //       0,
  //       message.notification.title,
  //       message.notification.body,
  //       platformChannelSpecifics,
  //       payload: 'item x');
  // }

  static Future<String> downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static aliceLogging({String link, var payload, var headers, Duration timeoutDuration = const Duration(seconds: 10)}) async {
    var response;
    if (headers != null) {
      await post(
        Uri.parse(link),
        headers: headers,
        body: payload,
      ).timeout(timeoutDuration).then((responses) {
        response = responses;
        // Dataconstants.alice.onHttpResponse(response);
      });
    } else {
      await post(
        Uri.parse(link),
        body: payload,
      ).timeout(timeoutDuration).then((responses) {
        response = responses;
        // Dataconstants.alice.onHttpResponse(response);
      });
    }
    return response;
  }

  static Future<String> getClientUserAgent() async {
    var deviceInfo = PlatformDeviceId.deviceInfoPlugin;
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return "(${iosDeviceInfo.utsname.machine}; iOS ${iosDeviceInfo.systemVersion})";
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return "(${androidDeviceInfo.manufacturer} ${androidDeviceInfo.model}; Android ${androidDeviceInfo.version.release} SDK${androidDeviceInfo.version.sdkInt})";
    } else {
      return "";
    }
  }

  static aliceLoggingGetMethod({String link}) async {
    var response;
    await get(Uri.parse(link)).then((responses) {
      response = responses.body.trimLeft();
    });
    return response;
  }

  static getPredefinedChartTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var checkKey = pref.containsKey('predefinedChartTime');
    var actualMin = DateTime.now();
    if (!checkKey) {
      setPredefinedChartTime(actualMin);
      return true;
    } else {
      var savedDateTime = pref.containsKey('predefinedChartTime') ? pref.getString('predefinedChartTime') : DateTime.now();
      DateTime tempDate = checkKey ? new DateFormat("yyyy-MM-dd H:mm:ss").parse(savedDateTime) : savedDateTime;
      var finalDate = tempDate.add(Duration(minutes: 15));

      var result = actualMin.isAfter(finalDate);
      if (result) setPredefinedChartTime(actualMin);
      return result;
    }
  }

  static getIndicesChartTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var checkKey = pref.containsKey('IndicesChartTime');
    var actualMin = DateTime.now();
    if (!checkKey) {
      setIndicesChartTime(actualMin);
      return true;
    } else {
      var savedDateTime = pref.containsKey('IndicesChartTime') ? pref.getString('IndicesChartTime') : DateTime.now();
      DateTime tempDate = checkKey ? new DateFormat("yyyy-MM-dd H:mm:ss").parse(savedDateTime) : savedDateTime;
      var finalDate = tempDate.add(Duration(minutes: 15));

      var result = actualMin.isAfter(finalDate);
      if (result) setIndicesChartTime(actualMin);
      return result;
    }
  }

  static getMarketWatchChartTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var checkKey = pref.containsKey('MarketWatchChartTime');
    var actualMin = DateTime.now();
    if (!checkKey) {
      setMarketWatchChartTime(actualMin);
      return true;
    } else {
      var savedDateTime = pref.containsKey('MarketWatchChartTime') ? pref.getString('MarketWatchChartTime') : DateTime.now();
      DateTime tempDate = checkKey ? new DateFormat("yyyy-MM-dd H:mm:ss").parse(savedDateTime) : savedDateTime;
      var finalDate = tempDate.add(Duration(minutes: 15));

      var result = actualMin.isAfter(finalDate);
      if (result) setMarketWatchChartTime(actualMin);
      return result;
    }
  }

  static setPredefinedChartTime(actualMin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.setString('predefinedChartTime', actualMin.toString());
  }

  static setIndicesChartTime(actualMin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.setString('IndicesChartTime', actualMin.toString());
  }

  static setMarketWatchChartTime(actualMin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.setString('MarketWatchChartTime', actualMin.toString());
  }

  static double getMarketRate(ScripInfoModel model, bool isBuy) {
    double rate = 0.00;
    if (isBuy) {
      rate = model.offerRate1;
      if (rate < 0.05) rate = model.bidRate1;
    } else {
      rate = model.bidRate1;
      if (rate < 0.05) rate = model.offerRate1;
    }
    if (rate < 0.05) rate = model.close;
    if (rate < 0.05) rate = model.prevDayClose;
    return rate;
  }

  static double getCurrencyMarketRate(ScripInfoModel model, bool isBuy) {
    double rate = 0.0000;
    if (isBuy) {
      rate = model.offerRate1;
      if (rate < 0.0005) rate = model.bidRate1;
    } else {
      rate = model.bidRate1;
      if (rate < 0.0005) rate = model.offerRate1;
    }
    if (rate < 0.0005) rate = model.lastTickRate;
    if (rate < 0.0005) rate = model.prevDayClose;
    return rate;
  }

  static Future<String> getIp() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type != InternetAddressType.IPv4) continue;
        return addr.address.trim();
      }
    }
    return '';
  }

  static Future<String> getEncryptedText(text) async {
    String instanceIdToken;
    try {
      var result;
      if (Platform.isAndroid) {
        result = await platform.invokeMethod('EncryptText', {"mobile_no": text});
        // //print('resposne from android $result');
      } else {
        result = await platform.invokeMethod('EncryptText');
        // //print('resposne from ios $result');
      }
      instanceIdToken = result;
    } on PlatformException catch (e) {
      instanceIdToken = "";
    }
    return instanceIdToken.toString().trim();
  }

  static String currencyFormat(double val) => NumberFormat.currency(
        locale: "en_IN",
        symbol: '',
      ).format(val).trim();

  static Future<void> showSnackBarKey({
    @required BuildContext context,
    @required GlobalKey<ScaffoldMessengerState> key,
    @required String text,
    Color color,
    Duration duration = const Duration(seconds: 2),
  }) {
    Completer completer = Completer();
    FocusScope.of(context).requestFocus(FocusNode());
    key.currentState?.removeCurrentSnackBar();
    if (color == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              duration: duration,
            ),
          )
          .closed
          .then((value) => completer.complete());
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              backgroundColor: color,
              duration: duration,
            ),
          )
          .closed
          .then((value) => completer.complete());
    }
    return completer.future;
  }

  static Future<void> showSnackBar({
    @required BuildContext context,
    @required String text,
    Color color,
    Duration duration = const Duration(seconds: 3),
  }) {
    Completer completer = Completer();
    if (color == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              duration: duration,
            ),
          )
          .closed
          .then((value) => completer.complete());
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              backgroundColor: color,
              duration: duration,
            ),
          )
          .closed
          .then((value) => completer.complete());
    }
    return completer.future;
  }

  static void showBasicToast(String message, [int seconds = 1]) {
    if (message.toString().toUpperCase().contains("PEAK MARGIN")) return;
    // Dataconstants.fToast.showToast(
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(25.0),
    //       color: Colors.grey,
    //     ),
    //     child: Text(message, style: TextStyle(color: Colors.black, fontSize: 16.0),),
    //
    //   ),
    //   gravity: ToastGravity.CENTER,
    //   toastDuration: Duration(seconds: seconds),
    // );
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: seconds, backgroundColor: Colors.grey, textColor: Colors.black, fontSize: 16.0);
  }

  static void showBasicKycToast(String message, [int seconds = 5]) {
    if (message.toString().toUpperCase().contains("PEAK MARGIN")) return;
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: seconds, backgroundColor: Colors.grey, textColor: Colors.black, fontSize: 16.0);
  }

  static void showDialogInternetForAll(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(""),
          content: new Text("Failed to connect to the server. This usually means there’s a network issue. If the issue persists, please try restarting the app"),
          actions: <Widget>[
            new TextButton(
              child: new Text("Retry"),
              onPressed: () {
                if (ConnectionStatusSingleton.getInstance().hasConnection)
                  Navigator.of(context).pop(false);
                else {
                  Navigator.of(context).pop(false);
                  var connection = ConnectionStatusSingleton.getInstance();
                  connection.checkConnection().then((value) async {
                    if (!value) {
                      CommonFunction.showDialogInternetForAll(context);
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void showLoader(BuildContext context, String str) {
    showDialog(context: context, barrierDismissible: false, builder: (_) => Loader(msg: str));
  }

  static Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;

    // Other data you can get:
    //
    // 	String appName = packageInfo.appName;
    // 	String packageName = packageInfo.packageName;
    //	String buildNumber = packageInfo.buildNumber;
  }

  static void dismissLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static String converToTitleCase(String s) {
    String value = s;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  static int getExchPosForAlgo(String exch, String exchType) {
    if (exch == 'N' && exchType == 'C') {
      return 0;
    }
    if (exch == 'N' && exchType == 'D') {
      return 1;
    }
    if (exch == 'B' && exchType == 'C') {
      return 2;
    }
    if (exch == 'C' && exchType == 'D') {
      return 3;
    }
    if (exch == 'E' && exchType == 'D') {
      return 4;
    }
    if (exch == 'M' && exchType == 'D') {
      return 5;
    }
  }

  static int getExchPosISec(String exch) {
    switch (exch) {
      case 'NSE':
        return 0;
        break;
      case 'BSE':
        return 2;
        break;
      case 'NFO':
        return 1;
        break;
      case 'NDX':
        return 3;
        break;
      case 'MCO':
        return 5;
        break;

      default:
        return 0;
        break;
    }
  }

  static int getExchPosOnCode(String exch, int exchCode) {
    if (exch == 'C')
      return 3;
    else if (exch == 'M')
      return 5;
    else if (exch == 'B')
      return 2;
    else if (exch == 'E')
      return 4;
    else if (isEquity(exchCode))
      return 0;
    else
      return 1;
  }

  static ScripInfoModel getScripDataModelFastForIQS({
    @required int exchPos,
    @required int exchCode,
  }) {
    if (exchPos < 0) return ScripInfoModel();
    var model = Dataconstants.exchData[exchPos].getStaticModel(exchCode);
    if (model == null) return ScripInfoModel();
    ScripInfoModel finalModel = ScripInfoModel()..setStaticData(model);
    Dataconstants.exchData[exchPos].addModel(finalModel);
    return finalModel;
  }

  static ScripInfoModel getScripDataModelForUnderlyingCurr(ScripInfoModel underlyingModel) {
    int exchPos;
    if (underlyingModel.exchCategory == ExchCategory.currenyFutures || underlyingModel.exchCategory == ExchCategory.currenyOptions)
      exchPos = 3;
    else
      exchPos = 4;
    var model = Dataconstants.exchData[exchPos].getStaticModelForCurr(underlyingModel.ulToken, underlyingModel.expiry);
    if (model == null) return ScripInfoModel();
    ScripInfoModel finalModel = ScripInfoModel()..setStaticData(model);

    Dataconstants.exchData[exchPos].addModel(finalModel);

    Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
    return finalModel;
  }

  static ScripInfoModel getScripDataModelForUnderlyingMcx(ScripInfoModel underlyingModel) {
    var model = Dataconstants.exchData[5].getStaticModelForMcx(underlyingModel.ulToken, underlyingModel.expiry);
    if (model == null) return ScripInfoModel();
    ScripInfoModel finalModel = ScripInfoModel()..setStaticData(model);

    Dataconstants.exchData[5].addModel(finalModel);

    Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
    return finalModel;
  }

  static ScripInfoModel getScripDataModelForCommoFromIsecName(
      {@required String exch,
      @required String isecName,
      @required String expiryDate,
      @required bool isOption,
      double strikePrice,
      bool isCE,
      String ulToken,
      bool sendReq = true,
      bool getNseBseMap = false,
      String ltp = '0.00'}) {
    int exchPos = getExchPosISec(exch);
    int intDateFromExpiryDate = DateUtil.getMcxformattedDateFromIsec(expiryDate);
    //print("int date => $intDateFromExpiryDate");
    if (exchPos < 0) return ScripInfoModel();
    var model = Dataconstants.exchData[exchPos].getStaticCommModelForIsec(
      isecName: isecName,
      expiryDate: intDateFromExpiryDate,
      strikePrice: strikePrice,
      isCall: isCE,
    );

    if (model == null) {
      return ScripInfoModel()
        ..setApiData(
            isecApiName: isecName,
            exchApi: exch,
            exchCategory: isOption ? ExchCategory.mcxOptions : ExchCategory.mcxFutures,
            expiryDate: intDateFromExpiryDate,
            isOPtion: isOption,
            cptype: isCE ? 3 : 4,
            strikePrice: strikePrice,
            ltp: ltp);
    }
    int scPos = Dataconstants.exchData[exchPos].scripPos(model.exchCode);
    ScripInfoModel finalModel;
    if (scPos < 0) {
      finalModel = ScripInfoModel()..setStaticData(model);
      Dataconstants.exchData[exchPos].addModel(finalModel);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
    } else {
      finalModel = Dataconstants.exchData[exchPos].getModel(scPos);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
    }
    if (sendReq) Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
    return finalModel;
  }

  static ScripInfoModel getScripDataModelForCurrPositionFromIsecName(
      {@required String exch,
      @required String isecName,
      @required String expiryDate,
      @required bool isOption,
      double strikePrice,
      bool isCE,
      bool sendReq = true,
      bool getNseBseMap = false,
      String ltp = '0.00',
      String fromPage = "portfolio"}) {
    // //print("exch fro curr ->$exch");
    int exchPos = getExchPosISec(exch);
    // //print("exchpos fro curr ->$exchPos");
    if (exchPos < 0) return ScripInfoModel();
    var model = Dataconstants.exchData[exchPos].getStaticCurrModelfromIsec(
      isecName: isecName,
      expiryDate: expiryDate.length > 5 ? DateUtil.getIntFromDate(expiryDate) : 0,
      strikePrice: strikePrice,
      isCall: isCE,
    );

    // var model = Dataconstants.exchData[3].getStaticModelForCurrFno(isecName);

    var newIsecName = "";
    if (fromPage == "portfolio" && isOption) {
      // strikePrice = strikePrice / 10000000;
      newIsecName = isecName;
    } else {
      if (isecName.contains("CE") || isecName.contains("PE")) {
        strikePrice = strikePrice / 10000000;
        newIsecName = isecName;
      } else {
        var replacedDate = expiryDate.replaceAll("-", " ");
        newIsecName = isecName.replaceAll(replacedDate, "").trim();
      }
    }

    if (model == null) {
      // //print("-----------");
      // //print(
      //     "this is exch  code from currency from isec api  and expiry date  => $exch $expiryDate ${DateUtil.getIntFromDate(expiryDate).toString()}");
      // //print('this is currency strike pice => $strikePrice $isOption $isCE');
      // //print("-----------");
      if (isOption) {
        strikePrice = strikePrice / 10000000;
      }
      return ScripInfoModel()
        ..setApiData(
            isecApiName: newIsecName,
            exchApi: exch,
            exchCategory: isOption ? ExchCategory.currenyOptions : ExchCategory.currenyFutures,
            // exchCategory: isCE
            //     ? ExchCategory.currenyOptions
            //     : ExchCategory.currenyFutures,
            expiryDate: expiryDate.length > 5 ? DateUtil.getIntFromDate(expiryDate) : 0,
            isOPtion: isOption,
            cptype: isCE ? 3 : 0,
            strikePrice: strikePrice,
            ltp: ltp);
    }
    int scPos = Dataconstants.exchData[exchPos].scripPos(model.exchCode);
    ScripInfoModel finalModel;
    if (scPos < 0) {
      finalModel = ScripInfoModel()..setStaticData(model);
      Dataconstants.exchData[exchPos].addModel(finalModel);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
    } else {
      // var newIsecName = "";
      // if (isecName.contains("CE") || isecName.contains("PE")) {
      //   strikePrice = strikePrice / 10000000;
      //   newIsecName = isecName;
      // } else {
      //   var replacedDate = expiryDate.replaceAll("-", " ");
      //   newIsecName = isecName.replaceAll(replacedDate, "").trim();
      // }

      finalModel = Dataconstants.exchData[exchPos].getModel(scPos);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
    }
    if (sendReq) Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
    return finalModel;
  }

  static ScripInfoModel getScripDataModelForFnoFromIsecName(
      {@required String exch,
      @required String isecName,
      @required String expiryDate,
      @required bool isOption,
      double strikePrice,
      bool isCE,
      bool sendReq = true,
      bool getNseBseMap = false,
      String ltp = '0.00'}) {
    int exchPos = getExchPosISec(exch);
    if (exchPos < 0) return ScripInfoModel();
    var model = Dataconstants.exchData[exchPos].getStaticFOModelForIsec(
      isecName: isecName,
      expiryDate: DateUtil.getIntFromDate(expiryDate),
      strikePrice: strikePrice,
      isCall: isCE,
    );
    if (model == null) {
      // //print("this is exch code from api => $exch");
      // //print('this is fno strike pice => $strikePrice $isOption $isCE');
      return ScripInfoModel()
        ..setApiData(
            isecApiName: isecName,
            exchApi: exch,
            exchCategory: isOption ? ExchCategory.nseOptions : ExchCategory.nseFuture,
            expiryDate: DateUtil.getIntFromDate(expiryDate),
            isOPtion: isOption,
            cptype: isCE ? 3 : 4,
            strikePrice: strikePrice,
            ltp: ltp);
    }
    int scPos = Dataconstants.exchData[exchPos].scripPos(model.exchCode);
    ScripInfoModel finalModel;
    if (scPos < 0) {
      finalModel = ScripInfoModel()..setStaticData(model);
      Dataconstants.exchData[exchPos].addModel(finalModel);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
    } else {
      finalModel = Dataconstants.exchData[exchPos].getModel(scPos);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
    }
    if (sendReq) Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
    return finalModel;
  }

  static ScripInfoModel getScripDataModelForCurrFromIsecName(
      {@required String exch,
      @required String isecName,
      @required String expiryDate,
      @required bool isOption,
      double strikePrice,
      bool isCE,
      bool sendReq = true,
      bool getNseBseMap = false,
      String ltp = '0.00',
      String underlying,
      String fromPage}) {
    // //print("exch fro curr ->$exch");
    int exchPos = getExchPosISec(exch);
    // //print("exchpos fro curr ->$exchPos");
    if (exchPos < 0) return ScripInfoModel();
    var model;
    if (fromPage == "openposition") {
      if (isOption) {
        strikePrice = strikePrice / 10000000;
      }
      // model = Dataconstants.exchData[3].getStaticModelForCurrFno(isecName);
      model = Dataconstants.exchData[exchPos].getStaticCurrModelfromIsec(
        isecName: isecName,
        expiryDate: expiryDate.length > 5 ? DateUtil.getIntFromDate(expiryDate) : 0,
        strikePrice: strikePrice,
        isCall: isCE,
      );
    } else if (fromPage == "research") {
      // if (isOption) {
      //   strikePrice = strikePrice / 10000000;
      // }

      model = Dataconstants.exchData[exchPos].getStaticCurrModelfromIsec(
        isecName: underlying,
        expiryDate: expiryDate.length > 5 ? DateUtil.getIntFromDate(expiryDate) : 0,
        strikePrice: strikePrice,
        isCall: isCE,
      );
    } else {
      if (isOption) {
        strikePrice = strikePrice / 10000000;
      }

      model = Dataconstants.exchData[exchPos].getStaticCurrModelfromIsec(
        isecName: underlying,
        expiryDate: expiryDate.length > 5 ? DateUtil.getIntFromDate(expiryDate) : 0,
        strikePrice: strikePrice,
        isCall: isCE,
      );
    }
    // model = Dataconstants.exchData[3].getStaticModelForCurrFno(isecName);

    if (model == null) {
      // //print("-----------");
      // //print(
      //     "this is exch  code from currency from isec api  and expiry date  => $exch $expiryDate ${DateUtil.getIntFromDate(expiryDate).toString()}");
      // //print('this is currency strike pice => $strikePrice $isOption $isCE');
      // //print("-----------");
      var newIsecName = "";
      if (fromPage == "openposition" && isOption) {
        // strikePrice = strikePrice / 10000000;
        newIsecName = isecName;
      } else {
        if (isecName.contains("CE") || isecName.contains("PE")) {
          strikePrice = strikePrice / 10000000;
          newIsecName = underlying;
        } else {
          var replacedDate = expiryDate.replaceAll("-", " ");
          newIsecName = isecName.replaceAll(replacedDate, "").trim();
        }
      }

      return ScripInfoModel()
        ..setApiData(
            isecApiName: newIsecName,
            exchApi: exch,
            exchCategory: isCE ? ExchCategory.currenyOptions : ExchCategory.currenyFutures,
            // exchCategory: isOption
            //     ? ExchCategory.currenyOptions
            //     : ExchCategory.currenyFutures,
            expiryDate: expiryDate.length > 5 ? DateUtil.getIntFromDate(expiryDate) : 0,
            isOPtion: isOption,
            cptype: isCE ? 3 : 0,
            strikePrice: strikePrice,
            ltp: ltp);
    }
    int scPos = Dataconstants.exchData[exchPos].scripPos(model.exchCode);
    ScripInfoModel finalModel;
    if (scPos < 0) {
      finalModel = ScripInfoModel()..setStaticData(model);
      Dataconstants.exchData[exchPos].addModel(finalModel);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
    } else {
      finalModel = Dataconstants.exchData[exchPos].getModel(scPos);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      } else {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
    }
    if (sendReq) Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
    return finalModel;
  }

  static ScripInfoModel getScripDataModelFromIsecName(
      {@required String exch, @required String isecName, @required String expiryDate, bool sendReq = true, bool getNseBseMap = false, String ltp = '0.00'}) {
    int exchPos = getExchPosISec(exch);
    if (exchPos < 0) return ScripInfoModel();
    int scripPos = Dataconstants.exchData[exchPos].scripPosForIsec(isecName) ?? -1;
    if (scripPos < 0) {
      var model = Dataconstants.exchData[exchPos].getStaticModelForIsec(isecName);
      if (model == null) {
        return ScripInfoModel()
          ..setApiData(
              isecApiName: isecName, exchApi: '', isOPtion: false, expiryDate: DateUtil.getIntFromDate(DateFormat('dd-MMM-yyyy').format(DateTime.now())), cptype: null, strikePrice: null, ltp: ltp);
      }
      ScripInfoModel finalModel = ScripInfoModel()..setStaticData(model);

      Dataconstants.exchData[exchPos].addModel(finalModel);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
      if (sendReq) Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
      return finalModel;
    } else {
      var result = Dataconstants.exchData[exchPos].getModel(scripPos);

      if (result.alternateModel == null && getNseBseMap && result.exchCategory == ExchCategory.nseEquity || result.exchCategory == ExchCategory.bseEquity) {
        ScripInfoModel alternateModel = getBseNseMapModel(result.name, result.exchCategory);
        if (alternateModel != null) result.addAlternateModel(alternateModel);
      }
      if (sendReq) Dataconstants.iqsClient.sendLTPRequest(result, true);
      return result;
    }
  }

  static ScripInfoModel getAlgoScripDataModelFromIsecName({
    @required String exch,
    @required String isecName,
    @required int exchCode,
    @required String exchType,
    bool sendReq = true,
    bool getNseBseMap = false,
  }) {
    // int exchPos = getExchPosISec(exch);
    int exchPos = getExchPosForAlgo(exch, exchType);
    if (exchPos < 0) return ScripInfoModel();
    int scripPos = Dataconstants.exchData[exchPos].scripPos(exchCode) ?? -1;
    if (scripPos < 0) {
      var model = Dataconstants.exchData[exchPos].getStaticModel(exchCode);
      if (model == null) {
        // //print("this is exch code from api => $exch");
        return ScripInfoModel()
          ..setApiData(
            isecApiName: isecName,
            exchApi: '',
            isOPtion: false,
            expiryDate: DateUtil.getIntFromDate(DateFormat('dd-MMM-yyyy').format(DateTime.now())),
            cptype: null,
            strikePrice: null,
          );
      }
      ScripInfoModel finalModel = ScripInfoModel()..setStaticData(model);

      Dataconstants.exchData[exchPos].addModel(finalModel);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
      if (sendReq) Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
      return finalModel;
    } else {
      var result = Dataconstants.exchData[exchPos].getModel(scripPos);

      if (result.alternateModel == null && getNseBseMap && result.exchCategory == ExchCategory.nseEquity || result.exchCategory == ExchCategory.bseEquity) {
        ScripInfoModel alternateModel = getBseNseMapModel(result.name, result.exchCategory);
        if (alternateModel != null) result.addAlternateModel(alternateModel);
      }
      if (sendReq) Dataconstants.iqsClient.sendLTPRequest(result, true);
      // //log("Algo running model => $result");
      return result;
    }
  }

  static ScripInfoModel getScripDataModel({
    @required String exch,
    @required int exchCode,
    bool sendReq = true,
    bool getNseBseMap = false,
    int getChartDataTime = 0,
  }) {
    int counter = 0;
    var fmt = DateFormat('dd-MMM-yyyy');
    var fmt1 = DateFormat('dd-MMM-yyyy HH:mm:ss');
    // //print(fmt.format(DateTime.now()));
    var fmtdate = fmt.format(DateTime.now().subtract(Duration(days: 1)));
    String openDate = fmtdate + ' 09:15:00';
    int exchPos = getExchPosOnCode(exch, exchCode);
    if (exchPos < 0) return ScripInfoModel();
    int scripPos = Dataconstants.exchData[exchPos].scripPos(exchCode);
    if (scripPos < 0) {
      var model = Dataconstants.exchData[exchPos].getStaticModel(exchCode);
      if (model == null) return ScripInfoModel();
      ScripInfoModel finalModel = ScripInfoModel()..setStaticData(model);

      Dataconstants.exchData[exchPos].addModel(finalModel);
      if (getNseBseMap && (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)) {
        ScripInfoModel alternateModel = getBseNseMapModel(model.name, model.exchCategory);
        if (alternateModel != null) finalModel.addAlternateModel(alternateModel);
      }
      if (sendReq) Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
      if (getChartDataTime > 0) Dataconstants.itsClient.getChartData(timeInterval: getChartDataTime, chartPeriod: "I", model: finalModel);
      return finalModel;
    } else {
      var result = Dataconstants.exchData[exchPos].getModel(scripPos);

      if (result.alternateModel == null && getNseBseMap && result.exchCategory == ExchCategory.nseEquity || result.exchCategory == ExchCategory.bseEquity) {
        ScripInfoModel alternateModel = getBseNseMapModel(result.name, result.exchCategory);
        if (alternateModel != null) result.addAlternateModel(alternateModel);
      }
      if (sendReq) Dataconstants.iqsClient.sendLTPRequest(result, true);
      if (getChartDataTime > 0)
        result.getChartData(
          timeInterval: getChartDataTime,
          chartPeriod: "I",
        );
      return result;
    }
  }

  static ScripInfoModel getBseNseMapModel(String name, ExchCategory exchCategory) {
    if (exchCategory != ExchCategory.nseEquity && exchCategory != ExchCategory.bseEquity) return null;
    ScripInfoModel resultModel;
    ScripStaticModel staticModel;
    if (exchCategory == ExchCategory.nseEquity)
      staticModel = Dataconstants.exchData[2].getStaticModelFromName(name);
    else
      staticModel = Dataconstants.exchData[0].getStaticModelFromName(name);
    if (staticModel == null) return null;
    resultModel = ScripInfoModel()..setStaticData(staticModel);

    int exchPos = getExchPosOnCode(resultModel.exch, resultModel.exchCode);
    if (exchPos < 0) return null;
    int scripPos = Dataconstants.exchData[exchPos].scripPos(resultModel.exchCode);
    if (scripPos < 0) {
      Dataconstants.exchData[exchPos].addModel(resultModel);
      return resultModel;
    } else
      return Dataconstants.exchData[exchPos].getModel(scripPos);
  }

  // static ScripInfoModel getBseNseMapModel(@required String isecName,
  //     String name, ExchCategory exchCategory) {
  //   if (exchCategory != ExchCategory.nseEquity &&
  //       exchCategory != ExchCategory.bseEquity) return null;
  //   ScripInfoModel resultModel;
  //   ScripStaticModel staticModel;
  //   if (exchCategory == ExchCategory.nseEquity)
  //     staticModel = Dataconstants.exchData[2]
  //         .getStaticModelFromName(name, exchCategory, isecName);
  //   else
  //     staticModel = Dataconstants.exchData[0]
  //         .getStaticModelFromName(name, exchCategory, isecName);
  //   if (staticModel == null) return null;
  //   resultModel = ScripInfoModel()
  //     ..setStaticData(staticModel);
  //
  //   int exchPos = getExchPosOnCode(resultModel.exch, resultModel.exchCode);
  //   if (exchPos < 0) return null;
  //   int scripPos =
  //   Dataconstants.exchData[exchPos].scripPos(resultModel.exchCode);
  //   if (scripPos < 0) {
  //     Dataconstants.exchData[exchPos].addModel(resultModel);
  //     return resultModel;
  //   } else
  //     return Dataconstants.exchData[exchPos].getModel(scripPos);
  // }

  static String makeDerivDesc(dynamic reply, String exch) {
    String result;
    if (exch == 'M')
      result = '${reply.scripName.getValue().substring(0, reply.scripNameLength.getValue())} ${DateUtil.getAnyFormattedExchDateMCX(reply.expiryDate.getValue(), "dd MMM yyyy")}';
    else
      result = '${reply.scripName.getValue().substring(0, reply.scripNameLength.getValue())} ${DateUtil.getAnyFormattedExchDate(reply.expiryDate.getValue(), "dd MMM yyyy")}';
    if (reply.cpType.getValue() > 0) {
      if (exch == 'C')
        result += ' ${Dataconstants.array_option_type[reply.cpType.getValue()]} ${reply.strikePrice.getValue().toStringAsFixed(4)}';
      else
        result += ' ${Dataconstants.array_option_type[reply.cpType.getValue()]} ${reply.strikePrice.getValue().toStringAsFixed(2)}';
    }
    return result;
  }

  static bool isIndicesScrip(String exch, int exchCode) {
    if ((exch == 'N' && exchCode >= Dataconstants.nseCashIndexCodeStart && exchCode <= Dataconstants.nseCashIndexCodeEnd) ||
        (exch == 'B' && exchCode >= Dataconstants.bseCashIndexCodeStart && exchCode <= Dataconstants.bseCashIndexCodeEnd))
      return true;
    else
      return false;
  }

  static bool rateWithin(double low, double high, double check) {
    int high1, low1, check1;
    bool result = false;

    low1 = (low * 100).round();
    high1 = (high * 100).round();
    check1 = (check * 100).round();
    result = false;
    if ((low1 <= check1) && (check1 <= high1)) result = true;
    return result;
  }

  static List<ScripInfoModel> getIndices({
    @required int indicesMode,
    String searchText = '',
    bool sendRequest = true,
    int getChartDataTime = 0,
  }) {
    //0-all,1-nse,2-bse
    List<ScripInfoModel> finalNseList = [], finalBseList = [];
    if (indicesMode == 0 || indicesMode == 1) {
      finalNseList = Dataconstants.exchData[0].getNseIndices(searchText).map((e) {
        int pos = Dataconstants.exchData[0].scripPos(e.exchCode);
        if (pos < 0) {
          ScripInfoModel finalModel = ScripInfoModel()..setStaticData(e);
          Dataconstants.exchData[0].addModel(finalModel);
          if (sendRequest) Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
          if (getChartDataTime > 0) Dataconstants.itsClient.getChartData(timeInterval: getChartDataTime, chartPeriod: "I", model: finalModel);
          return finalModel;
        } else {
          var model = Dataconstants.exchData[0].getModel(pos);
          if (sendRequest) Dataconstants.iqsClient.sendLTPRequest(model, true);
          if (getChartDataTime > 0) Dataconstants.itsClient.getChartData(timeInterval: getChartDataTime, chartPeriod: "I", model: model);
          return model;
        }
      }).toList();
    }
    if (indicesMode == 0 || indicesMode == 2) {
      finalBseList = Dataconstants.exchData[2].getBseIndices(searchText).map((e) {
        int pos = Dataconstants.exchData[2].scripPos(e.exchCode);
        if (pos < 0) {
          ScripInfoModel finalModel = ScripInfoModel()..setStaticData(e);
          Dataconstants.exchData[2].addModel(finalModel);
          if (sendRequest) Dataconstants.iqsClient.sendLTPRequest(finalModel, true);
          if (getChartDataTime > 0) Dataconstants.itsClient.getChartData(timeInterval: getChartDataTime, chartPeriod: "I", model: finalModel);
          return finalModel;
        } else {
          var model = Dataconstants.exchData[2].getModel(pos);
          if (sendRequest) Dataconstants.iqsClient.sendLTPRequest(model, true);
          if (getChartDataTime > 0) Dataconstants.itsClient.getChartData(timeInterval: getChartDataTime, chartPeriod: "I", model: model);
          return model;
        }
      }).toList();
    }
    return finalNseList + finalBseList;
  }

  static ExchCategory getExchCategory(String exch, int exchCode, [int cpType = 0]) {
    try {
      if (exch == 'C') {
        if (cpType == 0)
          return ExchCategory.currenyFutures;
        else
          return ExchCategory.currenyOptions;
      } else if (exch == 'M') {
        if (cpType == 0)
          return ExchCategory.mcxFutures;
        else
          return ExchCategory.mcxOptions;
      } else if (exch == 'E') {
        if (cpType == 0)
          return ExchCategory.bseCurrenyFutures;
        else
          return ExchCategory.bseCurrenyOptions;
      } else if (exch == 'B')
        return ExchCategory.bseEquity;
      else if (isEquity(exchCode))
        return ExchCategory.nseEquity;
      else if (cpType == 0)
        return ExchCategory.nseFuture;
      else
        return ExchCategory.nseOptions;
    } catch (e) {
      // //print(e);
    }
    return ExchCategory.nseEquity;
  }

  static bool isEquity(int exchCode) {
    if ((exchCode > 0 && exchCode < 34999) || (exchCode >= 888801 && exchCode < 888820)) return true;
    return false;
  }

  static void reconnect() {
    try {
      Dataconstants.iqsClient.disconnect();
      Dataconstants.newsClient.disconnect();
      Dataconstants.iqsClient.iqsReconnect = true;
      Dataconstants.iqsClient.connect();
      Dataconstants.newsClient.connect();
    } catch (e) {
      // //print(e);
    }
  }

  static void saveRecentSearchData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (Dataconstants.recentSearchQueries.length > 0) {
      sp.setStringList('recentSearchQueries', Dataconstants.recentSearchQueries);
    }
    if (Dataconstants.recentViewedScrips.length > 0) {
      await sp.setStringList(
        'recentSearchScripsExch',
        Dataconstants.recentViewedScrips.map((e) => e.exch).toList(),
      );
      await sp.setStringList(
        'recentSearchScripsCode',
        Dataconstants.recentViewedScrips.map((e) => e.exchCode.toString()).toList(),
      );
    }
  }

  static bool isTradingAllowed(ExchCategory category) {
    if (!Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].allowTrading) {
      CommonFunction.showBasicToast('Trading is disabled for this account.');
      return false;
    }
    switch (category) {
      case ExchCategory.nseEquity:
      case ExchCategory.bseEquity:
        if (!Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].allowNseCash) {
          CommonFunction.showBasicToast('Trading in Equity segment is disabled for this account.');
          return false;
        }
        break;
      case ExchCategory.nseFuture:
      case ExchCategory.nseOptions:
        if (!Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].allowNseDeriv) {
          CommonFunction.showBasicToast('Trading in F&O segment is disabled for this account.');
          return false;
        }
        break;
      case ExchCategory.currenyFutures:
      case ExchCategory.currenyOptions:
      case ExchCategory.bseCurrenyFutures:
      case ExchCategory.bseCurrenyOptions:
        if (!Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].allowNseCurr) {
          CommonFunction.showBasicToast('Trading in Currency segment is disabled for this account.');
          return false;
        }
        break;
      case ExchCategory.mcxFutures:
      case ExchCategory.mcxOptions:
        return true;
      default:
        return true;
    }
    return true;
  }

  static void startupTasks() async {
    if (Dataconstants.indicesListener == null) Dataconstants.indicesListener = IndicesListener();
    Dataconstants.indicesListener.getIndicesFromPref();
    for (var list in Dataconstants.marketWatchListeners) list.loadMarketwatchListener();
    Dataconstants.predefinedMarketWatchListener.loadMarketwatchListener();
    Dataconstants.indicesMarketWatchListener.loadMarketwatchListener();
    Dataconstants.summaryMarketWatchListener.loadMarketwatchListener();
    SharedPreferences sp = await SharedPreferences.getInstance();
    var searchQueries = sp.getStringList('recentSearchQueries');
    if (searchQueries != null) Dataconstants.recentSearchQueries = searchQueries;
    var recentSearchScripsExch = sp.getStringList('recentSearchScripsExch');
    var recentSearchScripsCode = sp.getStringList('recentSearchScripsCode');
    if (recentSearchScripsExch != null && recentSearchScripsCode != null) {
      for (int i = 0; i < recentSearchScripsCode.length; i++) {
        int scripCode = int.tryParse(recentSearchScripsCode[i]);
        if (scripCode != null)
          Dataconstants.recentViewedScrips.add(
            CommonFunction.getScripDataModel(
              exch: recentSearchScripsExch[i],
              exchCode: scripCode,
              sendReq: false,
            ),
          );
      }
    }
    /*region added to resolve other assets - 31/01/23*/
    CommonFunction.getMarketWatch();
    CommonFunction.getOtherAssets();
    /*end region*/
  }

  static void firebaseCrash(e, s) {
    try {
      // FirebaseCrashlytics.instance.recordError(e, s);
    } catch (e, s) {}
  }

  static Future<bool> showAlert(BuildContext context, String title, String msg, [String buttonText = 'OK', bool dismissible = true]) {
    return showDialog<bool>(
        barrierDismissible: dismissible,
        context: context,
        builder: (BuildContext context) {
          var theme = Theme.of(context);
          return Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text(title),
                  content: SingleChildScrollView(
                    child: Text(msg, style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                  ),
                  //content: ChangelogScreen(),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text(title),
                  content: SingleChildScrollView(
                    child: Text(
                      msg,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  //content: ChangelogScreen(),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
        });
  }

  static Map<String, List<ScripStaticModel>> globalSearch(String scrip) {
    Map<String, List<ScripStaticModel>> stockItems = {'All': [], 'Cash': [], 'FO': [], 'Currency': [], 'Commodity': []};
    var tempQuery = scrip.split(' ');
    String specialSearch = '';

    for (int i = tempQuery.length - 1; i >= 0; i--) {
      if (tempQuery[i].length == 0) continue;
      if (tempQuery[i].toLowerCase() == "fut" || tempQuery[i].toLowerCase() == "future" || tempQuery[i].toLowerCase() == "futures") {
        specialSearch = "fut";
        tempQuery.removeAt(i);
        break;
      }
      if (tempQuery[i].toLowerCase() == "futidx") {
        specialSearch = "futidx";
        tempQuery.removeAt(i);
        break;
      }
      if (tempQuery[i].toLowerCase() == "futstk") {
        specialSearch = "futstk";
        tempQuery.removeAt(i);
        break;
      } else if (tempQuery[i].toLowerCase() == "option" || tempQuery[i].toLowerCase() == "opt" || tempQuery[i].toLowerCase() == "options") {
        specialSearch = "opt";
        tempQuery.removeAt(i);
        break;
      } else if (tempQuery[i].toLowerCase() == "curr" || tempQuery[i].toLowerCase() == "currency") {
        specialSearch = "curr";
        tempQuery.removeAt(i);
        break;
      } else if (tempQuery[i].toLowerCase() == "optstk") {
        specialSearch = "optstk";
        tempQuery.removeAt(i);
        break;
      } else if (tempQuery[i].toLowerCase() == "optidx") {
        specialSearch = "optidx";
        tempQuery.removeAt(i);
        break;
      } else if (tempQuery[i].toLowerCase() == "eq" || tempQuery[i].toLowerCase() == "equity") {
        specialSearch = "eq";
        tempQuery.removeAt(i);
        break;
      } else if (tempQuery[i].toLowerCase() == "nse") {
        specialSearch = "nse";
        tempQuery.removeAt(i);
        break;
      } else if (tempQuery[i].toLowerCase() == "bse") {
        specialSearch = "bse";
        tempQuery.removeAt(i);
        break;
      } else if (tempQuery[i].toLowerCase() == "mcx") {
        specialSearch = "mcx";
        tempQuery.removeAt(i);
        break;
      }
    }
    if (specialSearch == "") {
      specialSearch = "all";
    }
    switch (specialSearch) {
      case 'all':
        var resultsNse = Dataconstants.exchData[0].ISECfindModelsForSearchNse(tempQuery, scrip);
        var resultsBse = Dataconstants.exchData[2].ISECfindModelsForSearchBse(tempQuery, scrip);
        var eqCombined;
        if (!Dataconstants.isFromAlgo || !Dataconstants.isFromBasketOrder) {
          eqCombined = zip(
            resultsNse['NseEq'],
            resultsBse['BseEq'],
          ).toList();
          stockItems['Cash'].addAll(eqCombined);
          stockItems['All'].addAll(eqCombined);
        } else if (Dataconstants.isFromBasketOrder) {
          eqCombined = resultsNse['NseEq'];
        } else {
          eqCombined = resultsNse['NseEq'];
          List<dynamic> tempList = eqCombined;
          for (int i = 0; i < tempList.length; i++) {
            if (tempList[i].exch == 'N' && tempList[i].exchCode >= Dataconstants.nseCashIndexCodeStart && tempList[i].exchCode <= Dataconstants.nseCashIndexCodeEnd) {
              //print("indices condition");
              stockItems['Cash'].clear();
              stockItems['All'].clear();
              stockItems['FO'].clear();
              stockItems['Currency'].clear();
            } else {
              stockItems['Cash'].addAll(eqCombined);
              stockItems['All'].addAll(eqCombined);
            }
          }
        }

        var eqRestCombined;
        if (!Dataconstants.isFromAlgo) {
          eqRestCombined = zip(
            resultsNse['NseRest'],
            resultsBse['BseRest'],
          ).toList();
        } else {
          eqRestCombined = resultsNse['NseRest'];

          List<dynamic> tempList = eqCombined;
          for (int i = 0; i < tempList.length; i++) {
            if (tempList[i].exch == 'N' && tempList[i].exchCode >= Dataconstants.nseCashIndexCodeStart && tempList[i].exchCode <= Dataconstants.nseCashIndexCodeEnd) {
              //print("indices condition");
              stockItems['Cash'].clear();
              stockItems['All'].clear();
              stockItems['FO'].clear();
              stockItems['Currency'].clear();
            } else {
              stockItems['Cash'].addAll(eqRestCombined);
              stockItems['All'].addAll(eqRestCombined);
            }
          }
        }
        // stockItems['Cash'].addAll(eqRestCombined);
        // stockItems['All'].addAll(eqRestCombined);

        var resultsFO = Dataconstants.exchData[1].findModelsForSearchFO(tempQuery);
        if (resultsFO['FutIdx'].length > 0) {
          stockItems['All'].addAll(resultsFO['FutIdx']);
          stockItems['FO'].addAll(resultsFO['FutIdx']);
        }
        if (resultsFO['FutStx'].length > 0) {
          stockItems['All'].addAll(resultsFO['FutStx']);
          stockItems['FO'].addAll(resultsFO['FutStx']);
        }
        if (resultsFO['OptIdx'].length > 0) {
          stockItems['All'].addAll(resultsFO['OptIdx']);
          stockItems['FO'].addAll(resultsFO['OptIdx']);
        }
        if (resultsFO['OptStx'].length > 0) {
          stockItems['FO'].addAll(resultsFO['OptStx']);
          stockItems['All'].addAll(resultsFO['OptStx']);
        }

        if (Dataconstants.isFromAlgo) break;
        var resultsCurr = Dataconstants.exchData[3].findModelsForSearchCurrencyFO(tempQuery);
        var resultsBseCurr = Dataconstants.exchData[4].findModelsForSearchCurrencyFO(tempQuery);
        var currCombined;
        if (!Dataconstants.isFromAlgo) {
          currCombined = zip(
            resultsCurr['CurrFut'],
            resultsBseCurr['CurrFut'],
          ).toList();
        } else
          currCombined = resultsCurr['CurrFut'];
        stockItems['Currency'].addAll(currCombined);
        stockItems['All'].addAll(currCombined);

        var currOptCombined;
        if (!Dataconstants.isFromAlgo) {
          currOptCombined = zip(
            resultsCurr['CurrOpt'],
            resultsBseCurr['CurrOpt'],
          ).toList();
        } else
          currOptCombined = resultsCurr['CurrOpt'];
        stockItems['Currency'].addAll(currOptCombined);
        stockItems['All'].addAll(currOptCombined);
        var resultsMCX = Dataconstants.exchData[5].findModelsForSearch(tempQuery);
        if (resultsMCX.length > 0) {
          stockItems['All'].addAll(resultsMCX);
          stockItems['Commodity'].addAll(resultsMCX);
        }
        break;
      case 'eq':
        if (Dataconstants.isFromBasketOrder) break;
        var resultsNse = Dataconstants.exchData[0].ISECfindModelsForSearchNse(tempQuery, scrip);
        var resultsBse = Dataconstants.exchData[2].ISECfindModelsForSearchBse(tempQuery, scrip);
        var eqCombined;
        if (!Dataconstants.isFromAlgo) {
          eqCombined = zip(
            resultsNse['NseEq'],
            resultsBse['BseEq'],
          ).toList();
          stockItems['Cash'].addAll(eqCombined);
          stockItems['All'].addAll(eqCombined);
        }
        {
          eqCombined = resultsNse['NseEq'];
          List<dynamic> tempList = eqCombined;
          for (int i = 0; i < tempList.length; i++) {
            if (tempList[i].exch == 'N' && tempList[i].exchCode >= Dataconstants.nseCashIndexCodeStart && tempList[i].exchCode <= Dataconstants.nseCashIndexCodeEnd) {
              stockItems['Cash'].clear();
              stockItems['All'].clear();
              stockItems['FO'].clear();
              stockItems['Currency'].clear();
            } else {
              // stockItems['Cash'].addAll(eqCombined);
              // stockItems['All'].addAll(eqCombined);
            }
          }
        }

        // else
        //   eqCombined = resultsNse['NseEq'];
        // stockItems['Cash'].addAll(eqCombined);
        // stockItems['All'].addAll(eqCombined);

        var eqRestCombined;
        if (!Dataconstants.isFromAlgo) {
          eqRestCombined = zip(
            resultsNse['NseRest'],
            resultsBse['BseRest'],
          ).toList();
          stockItems['Cash'].addAll(eqRestCombined);
          stockItems['All'].addAll(eqRestCombined);
        } else {
          eqRestCombined = resultsNse['NseRest'];
          List<dynamic> tempList = eqCombined;
          for (int i = 0; i < tempList.length; i++) {
            if (tempList[i].exch == 'N' && tempList[i].exchCode >= Dataconstants.nseCashIndexCodeStart && tempList[i].exchCode <= Dataconstants.nseCashIndexCodeEnd) {
              //print("indices condition");
              stockItems['Cash'].clear();
              stockItems['All'].clear();
              stockItems['FO'].clear();
              stockItems['Currency'].clear();
            } else {
              // stockItems['Cash'].addAll(eqRestCombined);
              // stockItems['All'].addAll(eqRestCombined);
            }
          }
        }

        // else
        //   eqRestCombined = resultsNse['NseRest'];
        // stockItems['Cash'].addAll(eqRestCombined);
        // stockItems['All'].addAll(eqRestCombined);
        break;
      case 'nse eq':
        if (Dataconstants.isFromBasketOrder) break;
        var resultsNse = Dataconstants.exchData[0].ISECfindModelsForSearchNse(tempQuery, scrip);
        if (resultsNse['NseEq'].length > 0) {
          // stockItems['All'].addAll(resultsNse['NseEq']);
          // stockItems['Cash'].addAll(resultsNse['NseEq']);

          var eqRestCombined;
          if (!Dataconstants.isFromAlgo) {
            if (resultsNse['NseEq'].length > 0) {
              stockItems['All'].addAll(resultsNse['NseEq']);
              stockItems['Cash'].addAll(resultsNse['NseEq']);
            }
          } else {
            eqRestCombined = resultsNse['NseEq'];
            List<dynamic> tempList = eqRestCombined;
            for (int i = 0; i < tempList.length; i++) {
              if (tempList[i].exch == 'N' && tempList[i].exchCode >= Dataconstants.nseCashIndexCodeStart && tempList[i].exchCode <= Dataconstants.nseCashIndexCodeEnd) {
                stockItems['Cash'].clear();
                stockItems['All'].clear();
              } else {
                // stockItems['Cash'].addAll(eqRestCombined);
                // stockItems['All'].addAll(eqRestCombined);
              }
            }
          }
        }
        if (resultsNse['NseRest'].length > 0) {
          // stockItems['Cash'].addAll(resultsNse['NseRest']);
          // stockItems['All'].addAll(resultsNse['NseRest']);

          var eqRestCombined;
          if (!Dataconstants.isFromAlgo) {
            if (resultsNse['NseRest'].length > 0) {
              stockItems['All'].addAll(resultsNse['NseRest']);
              stockItems['Cash'].addAll(resultsNse['NseRest']);
            }
          } else {
            eqRestCombined = resultsNse['NseRest'];
            List<dynamic> tempList = eqRestCombined;
            for (int i = 0; i < tempList.length; i++) {
              if (tempList[i].exch == 'N' && tempList[i].exchCode >= Dataconstants.nseCashIndexCodeStart && tempList[i].exchCode <= Dataconstants.nseCashIndexCodeEnd) {
                stockItems['Cash'].clear();
                stockItems['All'].clear();
              } else {
                // stockItems['Cash'].addAll(eqRestCombined);
                // stockItems['All'].addAll(eqRestCombined);
              }
            }
          }
        }
        break;
      case 'bse':
      case 'bse eq':
        if (Dataconstants.isFromAlgo) break;
        if (Dataconstants.isFromBasketOrder) break;
        var resultsBse = Dataconstants.exchData[2].ISECfindModelsForSearchBse(tempQuery, scrip);
        if (resultsBse['BseEq'].length > 0) {
          stockItems['All'].addAll(resultsBse['BseEq']);
          stockItems['Cash'].addAll(resultsBse['BseEq']);
        }
        if (resultsBse['BseRest'].length > 0) {
          stockItems['Cash'].addAll(resultsBse['BseRest']);
          stockItems['All'].addAll(resultsBse['BseRest']);
        }
        break;
      case 'nse':
        if (Dataconstants.isFromBasketOrder) break;
        var resultsNse = Dataconstants.exchData[0].ISECfindModelsForSearchNse(tempQuery, scrip);
        if (resultsNse['NseEq'].length > 0) {
          var eqRestCombined;
          if (!Dataconstants.isFromAlgo) {
            if (resultsNse['NseEq'].length > 0) {
              stockItems['All'].addAll(resultsNse['NseEq']);
              stockItems['Cash'].addAll(resultsNse['NseEq']);
            }
          } else {
            eqRestCombined = resultsNse['NseEq'];
            List<dynamic> tempList = eqRestCombined;
            for (int i = 0; i < tempList.length; i++) {
              if (tempList[i].exch == 'N' && tempList[i].exchCode >= Dataconstants.nseCashIndexCodeStart && tempList[i].exchCode <= Dataconstants.nseCashIndexCodeEnd) {
                stockItems['Cash'].clear();
                stockItems['All'].clear();
              } else {
                // stockItems['Cash'].addAll(eqRestCombined);
                // stockItems['All'].addAll(eqRestCombined);
              }
            }
          }
        }
        if (resultsNse['NseRest'].length > 0) {
          // stockItems['All'].addAll(resultsNse['NseRest']);
          // stockItems['Cash'].addAll(resultsNse['NseRest']);
          var eqRestCombined;
          if (!Dataconstants.isFromAlgo) {
            if (resultsNse['NseRest'].length > 0) {
              stockItems['All'].addAll(resultsNse['NseRest']);
              stockItems['Cash'].addAll(resultsNse['NseRest']);
            }
          } else {
            eqRestCombined = resultsNse['NseRest'];
            List<dynamic> tempList = eqRestCombined;
            for (int i = 0; i < tempList.length; i++) {
              if (tempList[i].exch == 'N' && tempList[i].exchCode >= Dataconstants.nseCashIndexCodeStart && tempList[i].exchCode <= Dataconstants.nseCashIndexCodeEnd) {
                stockItems['Cash'].clear();
                stockItems['All'].clear();
              } else {
                // stockItems['Cash'].addAll(eqRestCombined);
                // stockItems['All'].addAll(eqRestCombined);
              }
            }
          }
        }

        var resultsFO = Dataconstants.exchData[1].findModelsForSearchFO(tempQuery);
        if (resultsFO['FutIdx'].length > 0) {
          stockItems['All'].addAll(resultsFO['FutIdx']);
          stockItems['FO'].addAll(resultsFO['FutIdx']);
        }
        if (resultsFO['FutStx'].length > 0) {
          stockItems['All'].addAll(resultsFO['FutStx']);
          stockItems['FO'].addAll(resultsFO['FutStx']);
        }
        if (resultsFO['OptIdx'].length > 0) {
          stockItems['FO'].addAll(resultsFO['OptIdx']);
          stockItems['All'].addAll(resultsFO['OptIdx']);
        }
        if (resultsFO['OptStx'].length > 0) {
          stockItems['All'].addAll(resultsFO['OptStx']);
          stockItems['FO'].addAll(resultsFO['OptStx']);
        }

        if (Dataconstants.isFromAlgo) break;

        var resultsCurr = Dataconstants.exchData[3].findModelsForSearchCurrencyFO(tempQuery);
        if (resultsCurr['CurrFut'].length > 0) {
          stockItems['All'].addAll(resultsCurr['CurrFut']);
          stockItems['Currency'].addAll(resultsCurr['CurrFut']);
        }
        if (resultsCurr['CurrOpt'].length > 0) {
          stockItems['All'].addAll(resultsCurr['CurrOpt']);
          stockItems['Currency'].addAll(resultsCurr['CurrOpt']);
        }
        break;
      case 'fut':
        var resultsFO = Dataconstants.exchData[1].findModelsForSearchFO(tempQuery);
        if (resultsFO['FutIdx'].length > 0) {
          stockItems['All'].addAll(resultsFO['FutIdx']);
          stockItems['FO'].addAll(resultsFO['FutIdx']);
        }
        if (resultsFO['FutStx'].length > 0) {
          stockItems['All'].addAll(resultsFO['FutStx']);
          stockItems['FO'].addAll(resultsFO['FutStx']);
        }
        var resultsCurr = Dataconstants.exchData[3].findModelsForSearchCurrencyFO(tempQuery);
        var resultsBseCurr = Dataconstants.exchData[4].findModelsForSearchCurrencyFO(tempQuery);
        final currCombined = zip(
          resultsCurr['CurrFut'],
          resultsBseCurr['CurrFut'],
        ).toList();
        stockItems['Currency'].addAll(currCombined);
        stockItems['All'].addAll(currCombined);
        break;
      case 'futidx':
        var resultsFO = Dataconstants.exchData[1].findModelsForSearchFO(tempQuery);
        if (resultsFO['FutIdx'].length > 0) {
          stockItems['All'].addAll(resultsFO['FutIdx']);
          stockItems['FO'].addAll(resultsFO['FutIdx']);
        }

        break;
      case 'futstx':
        var resultsFO = Dataconstants.exchData[1].findModelsForSearchFO(tempQuery);
        if (resultsFO['FutStx'].length > 0) {
          stockItems['All'].addAll(resultsFO['FutStx']);
          stockItems['FO'].addAll(resultsFO['FutStx']);
        }

        break;
      case 'opt':
        var resultsFO = Dataconstants.exchData[1].findModelsForSearchFO(tempQuery);
        if (resultsFO['OptIdx'].length > 0) {
          stockItems['All'].addAll(resultsFO['OptIdx']);
          stockItems['FO'].addAll(resultsFO['OptIdx']);
        }
        if (resultsFO['OptStx'].length > 0) {
          stockItems['All'].addAll(resultsFO['OptStx']);
          stockItems['FO'].addAll(resultsFO['OptStx']);
        }
        if (Dataconstants.isFromAlgo) break;
        var resultsCurr = Dataconstants.exchData[3].findModelsForSearchCurrencyFO(tempQuery);
        var resultsBseCurr = Dataconstants.exchData[4].findModelsForSearchCurrencyFO(tempQuery);
        var currOptCombined;
        if (!Dataconstants.isFromAlgo) {
          currOptCombined = zip(
            resultsCurr['CurrOpt'],
            resultsBseCurr['CurrOpt'],
          ).toList();
        } else
          currOptCombined = resultsCurr['CurrOpt'];
        stockItems['Currency'].addAll(currOptCombined);
        stockItems['All'].addAll(currOptCombined);

        break;
      case 'optidx':
        var resultsFO = Dataconstants.exchData[1].findModelsForSearchFO(tempQuery);
        if (resultsFO['OptIdx'].length > 0) {
          stockItems['All'].addAll(resultsFO['OptIdx']);
          stockItems['FO'].addAll(resultsFO['OptIdx']);
        }

        break;
      case 'optstx':
        var resultsFO = Dataconstants.exchData[1].findModelsForSearchFO(tempQuery);
        if (resultsFO['OptStx'].length > 0) {
          stockItems['All'].addAll(resultsFO['OptStx']);
          stockItems['FO'].addAll(resultsFO['OptStx']);
        }

        break;
      case 'curr':
        if (Dataconstants.isFromAlgo) break;
        if (Dataconstants.isFromBasketOrder) break;
        var resultsCurr = Dataconstants.exchData[3].findModelsForSearchCurrencyFO(tempQuery);
        var resultsBseCurr = Dataconstants.exchData[4].findModelsForSearchCurrencyFO(tempQuery);

        var currCombined;
        if (!Dataconstants.isFromAlgo) {
          currCombined = zip(
            resultsCurr['CurrFut'],
            resultsBseCurr['CurrFut'],
          ).toList();
        } else
          currCombined = resultsCurr['CurrFut'];
        stockItems['Currency'].addAll(currCombined);
        stockItems['All'].addAll(currCombined);

        var currOptCombined;
        if (!Dataconstants.isFromAlgo) {
          currOptCombined = zip(
            resultsCurr['CurrOpt'],
            resultsBseCurr['CurrOpt'],
          ).toList();
        } else
          currOptCombined = resultsCurr['CurrOpt'];
        stockItems['Currency'].addAll(currOptCombined);
        stockItems['All'].addAll(currOptCombined);
        break;
      case 'mcx':
        if (Dataconstants.isFromAlgo) break;
        if (Dataconstants.isFromBasketOrder) break;
        var resultsFO = Dataconstants.exchData[5].findModelsForSearch(tempQuery);
        if (resultsFO.length > 0) {
          stockItems['All'].addAll(resultsFO);
          stockItems['Commodity'].addAll(resultsFO);
        }

        break;
    }
    return stockItems;
  }

  static JMFirebaseLogging(eventName, parameters) {
    FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters);
  }

  // #region icici login

  static String get timeStamp => DateFormat('dd-MMM-yyyy H:mm:ss').format(DateTime.now());

  static String istTime() {
    tz.initializeTimeZones();
    var location = tz.getLocation('Asia/Kolkata');
    var m = tz.TZDateTime.from(DateTime.now(), location);
    final df = new DateFormat('dd-MMM-yyyy H:mm:ss');
    // //print(df.format(m));
    var time = df.format(m);
    return time;
  }

  static String get date => DateFormat('dd-MMM-yyyy').format(DateTime.now());

  static String checksum(String data) => sha256.convert(utf8.encode(data)).toString();

  // #endregion
  static String getDateTimeFromInt(int value, ExchCategory exchCategory) {
    if (value <= 0) return '--';
    if (exchCategory == ExchCategory.mcxFutures || exchCategory == ExchCategory.mcxOptions)
      return DateUtil.getMcxDateWithFormat(value, 'dd MMM yyyy');
    else
      return DateUtil.getDateWithFormat(value, 'dd MMM yyyy');
  }

  static getRandomIp() {
    Random random = new Random();
    int randomNumber = random.nextInt(3);
    // //print("randomNumber $randomNumber");
    // //print("randomIP ${BrokerInfo.servers[randomNumber]}");
    return BrokerInfo.servers[randomNumber];
  }

  // static Future<List<BiometricType>> isBiometricAvailableLocalAuth() async {
  //   List<BiometricType> data = [];
  //   var _localAuthentication = LocalAuthentication();
  //   try {
  //     if (await _localAuthentication.canCheckBiometrics) data = await _localAuthentication.getAvailableBiometrics();
  //   } on PlatformException catch (e, s) {
  //     // FirebaseCrashlytics.instance.recordError(e, s);
  //   }
  //   return data;
  // }

  static bool isValidTickSize(
    String value,
    ScripInfoModel model,
  ) {
    List<String> val = value.split('.');
    if (val.length <= 1 || model.tickSize == 1) return true;
    var lastCharacter = val[1].substring(val.length - 1);
    if (model.exch == 'NDX' || model.exch == 'C') {
      if (val[1].length == 4) return true;
    }
    if (lastCharacter == '0' || lastCharacter == model.tickSize.toString()) return true;

    return false;
  }

  static Future<void> changePasswordPopUp(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          var theme = Theme.of(context);
          return AlertDialog(
            title: Text('Change Password'),
            content: Text(text),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: theme.primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: theme.primaryColor,
                  ),
                ),
                onPressed: () async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.setBool("showPasswordPopup", false);
                  Dataconstants.showPasswordPopup = false;
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePassword(true)));
                  // Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  static void showBasicToastForChar(String message, int seconds) {
    // chart Tick By Tick
    if (message.toString().toUpperCase().contains("PEAK MARGIN")) return;
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        //Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: seconds,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  static alertDiealougeForChart(ThemeData theme, int productType, TextEditingController limitController, int limitOrder, TextEditingController qtyContoller, BuildContext context, double yPixel,
      ScripInfoModel model, bool buy, GlobalKey<ScaffoldMessengerState> scaffoldKey) {
    limitController.text = yPixel.toStringAsFixed(2);
    qtyContoller.text = model.minimumLotQty.toString();
    return AlertDialog(
      title: const Text('Order Placement Setting'),
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PRODUCT',
                  style: TextStyle(fontSize: 14),
                ),
                (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity)
                    ? CupertinoSlidingSegmentedControl(
                        thumbColor: theme.accentColor,
                        children: {
                          0: Container(
                            height: 12,
                            width: 30,
                            child: Center(
                              child: Text(
                                'NRML',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: productType == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                          ),
                          1: Container(
                            height: 12,
                            width: 30,
                            child: Center(
                              child: Text(
                                'CNC',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: productType == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                          ),
                          2: Container(
                            height: 12,
                            width: 30,
                            child: Center(
                              child: Text(
                                'MIS',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: productType == 2 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                          ),
                        },
                        groupValue: productType,
                        onValueChanged: (newValue) {
                          setState(() {
                            productType = newValue;
                            //print("product Type :$productType");
                          });
                        })
                    : CupertinoSlidingSegmentedControl(
                        thumbColor: theme.accentColor,
                        children: {
                          0: Container(
                            height: 12,
                            width: 30,
                            child: Center(
                              child: Text(
                                'NRML',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: productType == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                          ),
                          1: Container(
                            height: 12,
                            width: 30,
                            child: Center(
                              child: Text(
                                'MIS',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: productType == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                          ),
                        },
                        groupValue: productType,
                        onValueChanged: (newValue) {
                          setState(() {
                            productType = newValue;
                            //print("product Type :$productType");
                          });
                        }),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QUANTITY',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                NumberField(
                  defaultValue: 1,
                  maxLength: 10,
                  numberController: qtyContoller,
                  increment: model.minimumLotQty,
                  hint: 'Quantity',
                  isInteger: true,
                  isBuy: buy,
                  isRupeeLogo: false,
                  isDisable: false,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORDER TYPE',
                  style: TextStyle(fontSize: 14),
                ),
                CupertinoSlidingSegmentedControl(
                    thumbColor: theme.accentColor,
                    children: {
                      0: Container(
                        height: 12,
                        width: 45,
                        child: Center(
                          child: Text(
                            'MARKET',
                            style: TextStyle(
                              fontSize: 10,
                              color: limitOrder == 0 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                            ),
                          ),
                        ),
                      ),
                      1: Container(
                        height: 12,
                        width: 45,
                        child: Center(
                          child: Text(
                            'LIMIT',
                            style: TextStyle(
                              fontSize: 10,
                              color: limitOrder == 1 ? theme.primaryColor : theme.textTheme.bodyText1.color,
                            ),
                          ),
                        ),
                      ),
                    },
                    groupValue: limitOrder,
                    onValueChanged: (newValue) {
                      setState(() {
                        limitOrder = newValue;
                        //print("order type Type :$limitOrder");
                      });
                    }),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)).animate(animation);
                return ClipRect(
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
              duration: const Duration(milliseconds: 250),
              child: limitOrder == 1
                  ? NumberField(
                      isBuy: buy,
                      doubleDefaultValue: yPixel ?? 0.00,
                      doubleIncrement: 0.5,
                      maxLength: 10,
                      numberController: limitController,
                      hint: 'Limit',
                      isRupeeLogo: false,
                      isDisable: false,
                    )
                  : SizedBox.shrink(),
            ),
          ],
        );
      }),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Color(0xFFD75B1F)),
          ),
        ),
        TextButton(
          onPressed: () async {
            var responseJson;

            ///-----------order API--------------------
            if (model.exchCategory == ExchCategory.nseEquity || model.exchCategory == ExchCategory.bseEquity) {
              var jsons = {
                "variety": Dataconstants.exchData[0].exchangeStatus != ExchangeStatus.nesAHOpen ? "AMO" : "NORMAL",
                "tradingsymbol": model.tradingSymbol,
                "symboltoken": model.exchCode.toString(),
                "transactiontype": buy ? "BUY" : "SELL",
                "exchange": model.exch == "N" ? "NSE" : "BSE",
                "ordertype": limitOrder == 1 ? "LIMIT" : "MARKET",
                "producttype": productType == 0
                    ? 'NRML'
                    : productType == 1
                        ? 'CNC'
                        : 'MIS',
                "duration": 'DAY',
                "price": limitOrder == 1 ? limitController.text : "0",
                "squareoff": "0",
                "stoploss": "0",
                "quantity": qtyContoller.text,
                "disclosedquantity": '0',
                "triggerprice": "0.00"
              };
              io.log(jsons.toString());
              var response = await CommonFunction.placeOrder(jsons);
              responseJson = json.decode(response.toString());

              // io.//log("Order Response => $response");
            } else if (model.exchCategory == ExchCategory.nseFuture || model.exchCategory == ExchCategory.nseOptions) {
              var jsons = {
                "variety": Dataconstants.exchData[1].exchangeStatus != ExchangeStatus.nesAHOpen ? "AMO" : "NORMAL",
                "tradingsymbol": model.tradingSymbol,
                "symboltoken": model.exchCode.toString(),
                "transactiontype": buy ? "BUY" : "SELL",
                "exchange": "NFO",
                "ordertype": limitOrder == 1 ? "LIMIT" : "MARKET",
                "producttype": productType == 0 ? 'NRML' : 'MIS',
                "duration": 'DAY',
                "price": limitOrder == 1 ? limitController.text : "0",
                "squareoff": "0",
                "stoploss": "0",
                "quantity": qtyContoller.text,
                "triggerprice": "0.00"
              };
              // io.log(jsons.toString());
              var response = await CommonFunction.placeOrder(jsons);
              responseJson = json.decode(response.toString());
              // io.//log("fno Order Response => $response");
            } else if (model.exchCategory == ExchCategory.mcxFutures || model.exchCategory == ExchCategory.mcxOptions) {
              var jsons = {
                "variety": Dataconstants.exchData[5].exchangeStatus != ExchangeStatus.nesAHOpen ? "AMO" : "NORMAL",
                "tradingsymbol": model.tradingSymbol,
                "symboltoken": model.exchCode.toString(),
                "transactiontype": buy ? "BUY" : "SELL",
                "exchange": "MCX",
                "ordertype": limitOrder == 1 ? "LIMIT" : "MARKET",
                "producttype": productType == 0 ? 'NRML' : 'MIS',
                "duration": 'DAY',
                "price": limitOrder == 1 ? limitController.text : "0",
                "squareoff": "0",
                "stoploss": "0",
                "quantity": qtyContoller.text,
                "disclosedquantity": '0',
                "triggerprice": "0.00"
              };
              io.log(jsons.toString());
              var response = await CommonFunction.placeOrder(jsons);
              responseJson = json.decode(response.toString());
              // io.//log("fno Order Response => $response");
            } else {
              var jsons = {
                "variety": Dataconstants.exchData[3].exchangeStatus != ExchangeStatus.nesAHOpen ? "AMO" : "NORMAL",
                "tradingsymbol": model.tradingSymbol,
                "symboltoken": model.exchCode.toString(),
                "transactiontype": buy ? "BUY" : "SELL",
                "exchange": "CDS",
                "ordertype": limitOrder == 1 ? "LIMIT" : "MARKET",
                "producttype": productType == 0 ? 'NRML' : 'MIS',
                "duration": 'DAY',
                "price": limitOrder == 1 ? limitController.text : "0",
                "squareoff": "0",
                "stoploss": "0",
                "quantity": qtyContoller.text,
                "disclosedquantity": '0',
                "triggerprice": "0.00"
              };
              io.log(jsons.toString());
              var response = await CommonFunction.placeOrder(jsons);
              responseJson = json.decode(response.toString());
              // io.//log("fno Order Response => $response");
            }
            // await Dataconstants.itsClient.placeEquityOrder(
            //   reportCalledFrom: Dataconstants.reportCalledFrom,
            //   exch: model.exchName,
            //   isecName: model.isecName,
            //   product: productType == 1 ? "CASH" : "MARGIN",
            //   type: limitOrder == 1 ? 'L' : 'M',
            //   validity: "T",
            //   //'I' ,
            //   interopsExch: model.exchName,
            //   vtcDate: null,
            //   qty: qtyContoller.text,
            //   rate: limitOrder == 1 ? limitController.text : "0",
            //   buySell: buy == true ? 'B' : 'S',
            //   slRate: '0',
            //   squareOffMode: null,
            //   disclosedQty: "0",
            //   password: null,
            // );
            ///------------ Api end------------
            // var status = Dataconstants.responseForChart["Status"];
            // var success = Dataconstants.responseForChart["Success"];
            // var indicator = success["Indicator"];
            // var message = success["Message"];
            // Dataconstants.indicatorChart = indicator;
            //
            // if (indicator == "0") {
            //   Dataconstants.y1.add(Dataconstants.ltpTickByTick);
            //   Dataconstants.timerChart.add(DateTime.now().millisecondsSinceEpoch);
            //   Dataconstants.createdFromFlashTrade.add(false);
            //   buy == true ? Dataconstants.isBuyColorFlashTrade.add(true) : Dataconstants.isBuyColorFlashTrade.add(false);
            //   // buy==true?   Dataconstants.placedOrderLineTickByTick.add(true)
            //   //     :Dataconstants.placedOrderLineTickByTick.add(false);
            //   //print(DateTime.now().millisecondsSinceEpoch);
            // // }
            // if (indicator == "-1") {
            //   CommonFunction.showBasicToastForChar(message, 5);
            // }
            // Dataconstants.defaultBuySellChartSetting = true;
            var indicator;
            if (responseJson['status'] == true)
              indicator = '0';
            else
              indicator = '-1';
            if (indicator == "-1") {
              if (responseJson['emsg'] == 'Session Invalid')
                CommonFunction.showBasicToastForChar(responseJson['message'], 5);
              else
                CommonFunction.showBasicToastForChar(responseJson['emsg'], 5);
            }
            scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: indicator == "0" ? Color(0xff66ff33) : Color(0xffff3333),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Image.asset(
                        indicator == "0" ? "assets/appImages/right_mark_success.gif" : "assets/appImages/cross_mark_failure.gif",
                        // "assets/images/chart/cross_mark_failure.gif",
                        height: 40,
                        width: 70,
                        fit: BoxFit.fill,
                        color: theme.textTheme.bodyText1.color, //cross_mark_failure.gif
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      height: 40,
                      // width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          indicator == "0" ? "Order Submitted" : 'Order Rejected',
                          style: TextStyle(color: theme.textTheme.bodyText1.color, fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              duration: Duration(seconds: 3),
            ));
            // Dataconstants.drawLineOnBuySell.add(true);
            Navigator.pop(context, 'Confirm');

            // Fluttertoast.showToast(
            // msg: "message",
            // toastLength: Toast.LENGTH_SHORT,
            // gravity: ToastGravity.CENTER,
            // timeInSecForIosWeb: 5,
            // backgroundColor: Colors.grey,
            // textColor: Colors.black,
            // fontSize: 16.0);
          },
          child: const Text(
            'Confirm',
            style: TextStyle(color: Color(0xFFD75B1F)),
          ),
        ),
      ],
    );
  }

  // static Future<void> launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     // //print('Could not launch $url');
  //   }
  // }

  static Iterable<T> zip<T>(Iterable<T> a, Iterable<T> b) sync* {
    final ita = a.iterator;
    final itb = b.iterator;
    bool hasa, hasb;
    while ((hasa = ita.moveNext()) | (hasb = itb.moveNext())) {
      if (hasa) yield ita.current;
      if (hasb) yield itb.current;
    }
  }

  static Map<String, int> countChars(String value) {
    String s1;
    var alpha = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
    ];
    var number = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
    ];
    var special = [
      '!',
      '@',
      '#',
      '\$',
      '%',
      '^',
      '&',
      '*',
      '(',
      ')',
    ];
    var alphaCount = 0;
    var numericCount = 0;
    var otherCount = 0;
    var specialCount = 0;
    s1 = value.trim().toUpperCase();
    for (int i = 0; i < s1.length; i++) {
      if (alpha.contains(s1[i]))
        alphaCount++;
      else if (number.contains(s1[i]))
        numericCount++;
      else if (special.contains(s1[i]))
        specialCount++;
      else
        otherCount++;
    }
    return {
      'alpha': alphaCount,
      'number': numericCount,
      'special': specialCount,
      'other': otherCount,
    };
  }

  static tPlusDialog(isAndroid, context) {
    showDialog(
      context: context,
      builder: (context) => isAndroid
          ? AlertDialog(
              title: Row(
                children: [
                  Text('Stock Settlement'),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.clear,
                        size: 20,
                      ))
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Please note from 25th February 2022, NSE and BSE have started migrating stocks to T+1 settlement cycle in phased manner. Hence, the settlement type i.e T+1 and T+2 is displayed against each stocks.'),
                ],
              ),
            )
          : CupertinoAlertDialog(
              title: Text('Stock Settlement'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Please note from 25th February 2022, NSE and BSE have started migrating stocks to T+1 settlement cycle in phased manner. Hence, the settlement type i.e T+1 and T+2 is displayed against each stocks.'),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Close',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
    );
  }

  static callLimits() {
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      // Dataconstants.itsClient.getTnc();
      // Dataconstants.itsClient.getTncText();
      // checkRekyc(Dataconstants.context);
      // Dataconstants.itsClient.requestEquityLimit();
      // Dataconstants.itsClient.requestFnoLimit();
      // Dataconstants.itsClient.requestCommoLimit();
      // Dataconstants.itsClient.getAllocation();
      // Dataconstants.itsClient.requestCurrLimit();
    });
  }

  static firebaseEvent(
      {String sessionId,
      String screenName,
      String subType,
      String eventLocation,
      String eventName,
      String platform,
      String eventId,
      String clientCode,
      String eventMetaData,
      String os_version,
      String eventType,
      String device_manufacturer,
      String device_model,
      String location,
      String source_metadata,
      String serverTimeStamp}) {
    try {
      var payload = {
        "session_id": sessionId,
        "screen_name": screenName,
        "content_source": "dummy",
        "build_release": Dataconstants.fileVersion,
        "event_sub_type": subType,
        "jmID": "dummy",
        "event_type": eventType,
        "event_location": eventLocation,
        "event_name": eventName,
        "event_id": eventId,
        "event_metadata": eventMetaData,
        "server_timestamp": serverTimeStamp,
        "platform": platform,
        "source_metadata": source_metadata,
        "location": 'dummy',
        "source_url": "dummy",
        "os_version": os_version,
        "utm_source": "dummy",
        "device_manufacturer": device_manufacturer,
        "device_model": device_model,
        "utm_medium": "dummy",
        "utm_campaign": "dummy",
        "utm_metadata": "dummy",
        "app_version_id": Dataconstants.fileVersion,
        "clientCode": clientCode
      };
      // io.//log("This is payload response => $payload");
      // FirebaseAnalytics.instance.logEvent(name: eventName, parameters: payload);
    } catch (e, s) {}
  }

  static void zipDecoder({String path, String dbpath}) {
    // Read the Zip file from disk.
    final bytes = File(path).readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(dbpath + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('out/' + filename).create(recursive: true);
      }
    }

    // Encode the archive as a BZip2 compressed Tar file.
    final tarData = TarEncoder().encode(archive);
    final tarBz2 = BZip2Encoder().encode(tarData);

    // Write the compressed tar file to disk.
    final fp = File('test.tbz');
    fp.writeAsBytesSync(tarBz2);

    // Zip a directory to out.zip using the zipDirectory convenience method
    var encoder = ZipFileEncoder();
    encoder.zipDirectory(Directory('out'), filename: 'out.zip');

    // Manually create a zip of a directory and individual files.
    encoder.create('out2.zip');
    encoder.addDirectory(Directory('out'));
    encoder.addFile(File(path));
    encoder.close();
  }
}

class HomeWidgets {
  static ScrollController controller = ScrollController();
  static int otherAssetTab = 1,
      topPerformingIndustriesTab = 1,
      circuitBreakersTab = 1,
      topGainersTab = 1,
      topLosersTab = 2,
      mostActiveTab = 1,
      eventsTab = 1,
      touchedIndex = -1,
      ipoTab = 1,
      optionChainVar = 1;
  static List globalTopGainersVariable = [], globalTopLosersVariable = [], globalMostActiveVariable = [];
  static DateFormat formatter = DateFormat('dd/MM/yyyy');
  static var totalMarketValueNifty, totalMarketValueSensex;
  static bool topGainersExpanded = false,
      topLosersExpanded = false,
      eventsExpanded = false,
      mostActiveExpanded = false,
      ipoExpanded = false,
      globalIndicesExpanded = false,
      topPerformingIndustriesExpanded = false,
      nifty = true;
  static List<int> optionDates;
  static var searchList = [], newData = <Widget>[];
  static var searchValue = "";
  static BuildContext context;
  static bool marketBreadthNifty50 = true;
  static bool marketBreadthSensex = false;

  static void scrollTop() {
    controller.animateTo(
      controller.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  static assignWidgets(BuildContext context) {
    var theme = Theme.of(context);
    var dashboardElements = [
      ["1", "Key Indices", true],
      ["2", "Trending Stocks", true],
      ["3", "Top Performing Industries", true],
      ["4", "Top Gainers", true],
      ["5", "Most Active", true],
      ["6", "Top Losers", true],
      ["7", "Global Indices", true]
    ];

    var dashboardJsonElements = jsonEncode(dashboardElements);
    var dashboardData = Dataconstants.isGuestUser ? dashboardJsonElements : InAppSelection.dashboardSettings.toString();

    var decodedlist = jsonDecode(dashboardData);
    newData = [];
    newData.add(Container(
      height: 2.0,
      width: MediaQuery.of(context).size.width,
      color: Utils.greyColor.withOpacity(0.2),
    ));
    if (searchValue.isNotEmpty) {
      for (int i = 0; i < searchList.length; i++) {
        if (searchList[i][1].toString().toUpperCase().contains(searchValue.toString().toUpperCase())) {
          switch (searchList[i][1].toString()) {
            case "Limits":
              newData.add(limits(Dataconstants.navigatorKey.currentContext));
              break;
            case "Positions":
              newData.add(position());
              break;
            case "Trending Stocks":
              newData.add(trendingStocks(Dataconstants.navigatorKey.currentContext));
              break;
            case "Other Assets":
              newData.add(otherAsset());
              break;
            case "Market Breadth":
              newData.add(marketBreadth());
              break;
            case "Top Performing Industries":
              newData.add(topPerformingIndus());
              break;
            case "Orders":
              newData.add(orders());
              break;
            case "Top Gainers":
              newData.add(topGrainers());
              break;
            case "Events":
              newData.add(events());
              break;
            case "Most Active":
              newData.add(mostActive());
              break;
            case "Key Indices":
              newData.add(keyIndices(Dataconstants.navigatorKey.currentContext));
              break;
            case "JM Baskets":
              newData.add(jmBasket(Dataconstants.navigatorKey.currentContext));
              break;
            case "My Ongoing SIPs":
              newData.add(myOngoingSip(Dataconstants.navigatorKey.currentContext));
              break;
            case "Research":
              newData.add(research(Dataconstants.navigatorKey.currentContext));
              break;
            case "Top Losers":
              newData.add(topLosers());
              break;
            case "News":
              newData.add(news(Dataconstants.navigatorKey.currentContext));
              break;
            case "Orders":
              newData.add(orders());
              break;
            case "Global Indices":
              newData.add(globalIndices());
              break;
            case "Circuit Breakers":
              newData.add(circuitBreakers(Dataconstants.navigatorKey.currentContext));
              break;
            case "Option Chain":
              optionDates = Dataconstants.exchData[1].getDatesForOptions(Dataconstants.indicesListener.indices1);
              newData.add(optionChain());
              break;
            case "OI Analysis":
              newData.add(openInterest(Dataconstants.navigatorKey.currentContext));
              break;
            case "Backoffice":
              // newData.add(value);
              break;
            case "IPO":
              newData.add(ipo());
              break;
            case "NFO":
              newData.add(nfo(Dataconstants.navigatorKey.currentContext));
              break;
            case "NCD":
              // newData.add(value);
              break;
            case "DP Holdings":
              newData.add(DpHoldings());
              break;
          }
        }
      }
    } else {
      searchList = [];
      for (var i = 0; i < decodedlist.length; i++) {
        if (decodedlist[i][2] == true) {
          searchList.add(decodedlist[i]);
          switch (decodedlist[i][1].toString()) {
            case "Limits":
              newData.add(limits(Dataconstants.navigatorKey.currentContext));
              break;
            case "Positions":
              newData.add(position());
              break;
            case "Trending Stocks":
              newData.add(trendingStocks(Dataconstants.navigatorKey.currentContext));
              break;
            case "Other Assets":
              newData.add(otherAsset());
              break;
            case "Market Breadth":
              newData.add(marketBreadth());
              break;
            case "Top Performing Industries":
              newData.add(topPerformingIndus());
              break;
            case "Orders":
              newData.add(orders());
              break;
            case "Top Gainers":
              newData.add(topGrainers());
              break;
            case "Events":
              newData.add(events());
              break;
            case "Most Active":
              newData.add(mostActive());
              break;
            case "Key Indices":
              newData.add(keyIndices(Dataconstants.navigatorKey.currentContext));
              break;
            case "JM Baskets":
              newData.add(jmBasket(Dataconstants.navigatorKey.currentContext));
              break;
            case "My Ongoing SIPs":
              newData.add(myOngoingSip(Dataconstants.navigatorKey.currentContext));
              break;
            case "Research":
              newData.add(research(Dataconstants.navigatorKey.currentContext));
              break;
            case "Top Losers":
              newData.add(topLosers());
              break;
            case "News":
              newData.add(news(Dataconstants.navigatorKey.currentContext));
              break;
            case "Orders":
              newData.add(orders());
              break;
            case "Global Indices":
              newData.add(globalIndices());
              break;
            case "Circuit Breakers":
              newData.add(circuitBreakers(Dataconstants.navigatorKey.currentContext));
              break;
            case "Option Chain":
              optionDates = Dataconstants.exchData[1].getDatesForOptions(Dataconstants.indicesListener.indices1);
              newData.add(optionChain());
              break;
            case "OI Analysis":
              newData.add(openInterest(Dataconstants.navigatorKey.currentContext));
              break;
            case "Backoffice":
              // newData.add(value);
              break;
            case "IPO":
              newData.add(ipo());
              break;
            case "NFO":
              newData.add(nfo(Dataconstants.navigatorKey.currentContext));
              break;
            case "NCD":
              // newData.add(value);
              break;
            case "DP Holdings":
              newData.add(DpHoldings());
              break;
          }
        }
      }
    }
    return newData;
  }

  static Color categoryColor(String category) {
    switch (category) {
      case 'Stocks':
        return Colors.lightBlue;
      case 'Commentary':
        return Colors.pink;
      case 'Global':
        return Colors.deepOrange;
      case 'Block Details':
        return Colors.blue;
      case 'Result':
        return Colors.purple;
      case 'Commodities':
        return Colors.amber;
      case 'Fixed income':
        return Colors.lightGreen;
      case 'Special Coverage':
        return Colors.teal;
      default:
        return Colors.lightBlue;
    }
  }

  static Widget keyIndices(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Key Indices",
                    style: Utils.fonts(size: 16.0),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 14.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {

                            ScripInfoModel scripinfo = CommonFunction.getScripDataModel(
                              exch: "B",
                              exchCode: 999901,
                            );

                            await Dataconstants.iqsClient.sendLTPRequest(scripinfo,true);
                            Dataconstants.iqsClient.sendMarketDepthRequest("B",999901, true);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScriptInfo(
                                        scripinfo,
                                        true)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.36,
                              decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 12.0, bottom: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sensex",
                                      style: Utils.fonts(
                                        size: 12.0,
                                      ),
                                    ),
                                    Observer(
                                      builder: (_) => Text(
                                        Dataconstants.indicesListener.indices2.close == 0.0
                                            ? Dataconstants.indicesListener.indices2.prevDayClose.toStringAsFixed(2)
                                            : Dataconstants.indicesListener.indices2.close.toStringAsFixed(2),
                                        style: Utils.fonts(
                                          size: 12.0,
                                        ),
                                      ),
                                    ),
                                    Observer(
                                      builder: (_) => Row(
                                        children: [
                                          Text(
                                            Dataconstants.indicesListener.indices2.close == 0.0
                                                ? "0.0"
                                                : (Dataconstants.indicesListener.indices2.close - Dataconstants.indicesListener.indices2.prevDayClose).toStringAsFixed(2),
                                            style: Utils.fonts(
                                              size: 10.0,
                                              color: Dataconstants.indicesListener.indices2.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "${Dataconstants.indicesListener.indices2.percentChange.toStringAsFixed(2)}%",
                                              style: Utils.fonts(
                                                size: 10.0,
                                                color: Dataconstants.indicesListener.indices2.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Dataconstants.indicesListener.indices2.percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                            color: Dataconstants.indicesListener.indices2.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {

                            ScripInfoModel scripinfo = CommonFunction.getScripDataModel(
                              exch: "N",
                              exchCode: 26000,
                            );

                            Dataconstants.iqsClient.sendLTPRequest(scripinfo,true);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScriptInfo(
                                      scripinfo, true,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.36,
                              decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 12.0, bottom: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nifty",
                                      style: Utils.fonts(
                                        size: 12.0,
                                      ),
                                    ),
                                    Observer(
                                      builder: (_) => Text(
                                        Dataconstants.indicesListener.indices1.close == 0.0
                                            ? Dataconstants.indicesListener.indices1.prevDayClose.toStringAsFixed(2)
                                            : Dataconstants.indicesListener.indices1.close.toStringAsFixed(2),
                                        style: Utils.fonts(
                                          size: 12.0,
                                        ),
                                      ),
                                    ),
                                    Observer(
                                      builder: (_) => Row(
                                        children: [
                                          Text(
                                            Dataconstants.indicesListener.indices1.close == 0.0
                                                ? "0.0"
                                                : (Dataconstants.indicesListener.indices1.close - Dataconstants.indicesListener.indices1.prevDayClose).toStringAsFixed(2),
                                            style: Utils.fonts(
                                              size: 10.0,
                                              color: Dataconstants.indicesListener.indices1.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "${Dataconstants.indicesListener.indices1.percentChange.toStringAsFixed(2)}%",
                                              style: Utils.fonts(
                                                size: 10.0,
                                                color: Dataconstants.indicesListener.indices1.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Dataconstants.indicesListener.indices1.percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                            color: Dataconstants.indicesListener.indices1.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {

                            ScripInfoModel scripinfo = CommonFunction.getScripDataModel(
                              exch: "N",
                              exchCode: 26009,
                            );

                            Dataconstants.iqsClient.sendLTPRequest(scripinfo,true);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScriptInfo(
                                      scripinfo,
                                          true,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.36,
                              decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 12.0, bottom: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Bank Nifty",
                                      style: Utils.fonts(size: 12.0),
                                    ),
                                    Observer(
                                      builder: (_) => Text(
                                        Dataconstants.indicesListener.indices3.close == 0.0
                                            ? Dataconstants.indicesListener.indices3.prevDayClose.toStringAsFixed(2)
                                            : Dataconstants.indicesListener.indices3.close.toStringAsFixed(2),
                                        style: Utils.fonts(
                                          size: 12.0,
                                        ),
                                      ),
                                    ),
                                    Observer(
                                      builder: (_) => Row(
                                        children: [
                                          Text(
                                            Dataconstants.indicesListener.indices3.close == 0.0
                                                ? "0.0"
                                                : (Dataconstants.indicesListener.indices3.close - Dataconstants.indicesListener.indices3.prevDayClose).toStringAsFixed(2),
                                            style: Utils.fonts(
                                              size: 10.0,
                                              color: Dataconstants.indicesListener.indices3.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "${Dataconstants.indicesListener.indices3.percentChange.toStringAsFixed(2)}%",
                                              style: Utils.fonts(
                                                size: 10.0,
                                                color: Dataconstants.indicesListener.indices3.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Dataconstants.indicesListener.indices3.percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                            color: Dataconstants.indicesListener.indices3.percentChange > 0 ? Utils.mediumGreenColor : Utils.lightRedColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  static Widget portfolio(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0, bottom: 20.0),
          child: Container(
            color: Utils.darkGreenColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Portfolio Value",
                            style: Utils.fonts(
                              size: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "1,489,540.2",
                            style: Utils.fonts(size: 20.0, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LimitScreen()));
                        },
                        child: Text(
                          "Add Funds",
                          style: Utils.fonts(size: 12.0, color: Utils.primaryColor),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(
                        "assets/appImages/dashboard/Group_11921.svg",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invested",
                            style: Utils.fonts(size: 12.0, color: Utils.greyColor),
                          ),
                          Text(
                            "10,84,325.9",
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Day’s P/L",
                            style: Utils.fonts(size: 12.0, color: Utils.greyColor),
                          ),
                          Text(
                            "32,25,251.5",
                            style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "3.49%",
                            style: Utils.fonts(size: 12.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unrealised P/L",
                            style: Utils.fonts(size: 12.0, color: Utils.greyColor),
                          ),
                          Text(
                            "21,54,325.9",
                            style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "47.49%",
                            style: Utils.fonts(size: 12.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(child: Image.asset("assets/appImages/start_sip.png")),
        SizedBox(
          height: 20.0,
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  static Widget limits(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LimitScreen()));
                    },
                    child: Text(
                      "Limits",
                      style: Utils.fonts(size: 17.0),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LimitScreen()));
                      },
                      child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg")),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddFunds()));
                    },
                    child: Text(
                      "Add Funds",
                      style: Utils.fonts(size: 12.0, color: Utils.primaryColor),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/appImages/dashboard/Group 11921.svg")
                ],
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LimitScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Utils.primaryColor.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Available Margin",
                              style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() {
                              return LimitController.isLoading.value
                                  ? CircularProgressIndicator()
                                  : Text(
                                      LimitController.limitData.value.availableMargin.toStringAsFixed(2),
                                      style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600),
                                    );
                            }),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Margin Used",
                              style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() {
                              return LimitController.isLoading.value
                                  ? CircularProgressIndicator()
                                  : LimitController.limitData.value == null
                                      ? Text(
                                          " ",
                                          style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600),
                                        )
                                      : Text(
                                          LimitController.limitData.value.marginUsed.toStringAsFixed(2),
                                          style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600),
                                        );
                            }),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() {
                              return Text(
                                "(${LimitController.limitData.value.marginUsedPercentage} used)".toString(),
                                style: Utils.fonts(size: 12.0, color: Colors.red, fontWeight: FontWeight.w600),
                              );
                            }),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  static Widget position() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      var theme = Theme.of(context);
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Positions",
                      style: Utils.fonts(size: 17.0),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          //
                          // Dataconstants.ordersScreenIndex = 3;
                          // setState(() {});
                          setState(() {
                            InAppSelection.mainScreenIndex = 3;
                            Dataconstants.ordersScreenIndex = 2;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => MainScreen(
                                        toChangeTab: false,
                                      )),
                              (route) => false);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => JMOrdersScreen(2)));
                        },
                        child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg")),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          HomeWidgets.scrollTop();
                        },
                        child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  if (NetPositionController.isLoading.value)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else
                    return NetPositionController.openPositionList.length == 0
                        ? Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset('assets/appImages/noPositions.svg'),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "You have no Open Positions",
                                    style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // MaterialButton(
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(18.0),
                                  //       side: BorderSide(
                                  //         color: theme.primaryColor,
                                  //       ),
                                  //     ),
                                  //     color: theme.primaryColor,
                                  //     padding: EdgeInsets.symmetric(horizontal: 50),
                                  //     child: Text(
                                  //       'GO TO WATCHLIST',
                                  //       style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.white),
                                  //     ),
                                  //     onPressed: () {
                                  //       InAppSelection.mainScreenIndex = 1;
                                  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  //           builder: (_) => MainScreen(
                                  //                 toChangeTab: false,
                                  //               )));
                                  //     })
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Observer(builder: (context) {
                                    double totalUnrealisedPL = 0.0;
                                    double pl = 0.0;
                                    for (int i = 0; i < NetPositionController.openPositionList.length; i++) {
                                      if (int.parse(NetPositionController.openPositionList[i].netqty) == 0)
                                        pl = 0.00;
                                      else if (int.parse(NetPositionController.openPositionList[i].netqty) < 0)
                                        pl = (NetPositionController.openPositionList[i].model.prevDayClose -
                                                double.tryParse(NetPositionController.openPositionList[i].sellavgprice.replaceAll(',', ''))) *
                                            int.parse(NetPositionController.openPositionList[i].netqty).abs();
                                      else
                                        pl = (NetPositionController.openPositionList[i].model.prevDayClose - double.parse(NetPositionController.openPositionList[i].buyavgprice.replaceAll(',', ''))) *
                                            int.parse(NetPositionController.openPositionList[i].netqty).abs();
                                      if (NetPositionController.openPositionList[i].model.exch == 'M' && NetPositionController.openPositionList[i].model.exchType == 'D')
                                        pl = NetPositionController.openPositionList[i].pl *
                                            NetPositionController.openPositionList[i].model.factor *
                                            NetPositionController.openPositionList[i].model.minimumLotQty;
                                      totalUnrealisedPL += pl;
                                    }
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: totalUnrealisedPL > 0 ? Utils.lightGreenColor.withOpacity(0.2) : Utils.lightRedColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text("MTM: " + totalUnrealisedPL.toStringAsFixed(2),
                                            style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w700, color: totalUnrealisedPL > 0 ? Utils.mediumGreenColor : Utils.mediumRedColor)),
                                      ),
                                    );
                                  }),
                                  Observer(builder: (context) {
                                    double totalUnrealisedPL = 0.0;
                                    double pl = 0.0;
                                    for (int i = 0; i < NetPositionController.openPositionList.length; i++) {
                                      if (int.parse(NetPositionController.openPositionList[i].netqty) == 0)
                                        pl = 0.00;
                                      else if (int.parse(NetPositionController.openPositionList[i].netqty) < 0)
                                        pl = (NetPositionController.openPositionList[i].model.close - double.tryParse(NetPositionController.openPositionList[i].sellavgprice.replaceAll(',', ''))) *
                                            int.parse(NetPositionController.openPositionList[i].netqty).abs();
                                      else
                                        pl = (NetPositionController.openPositionList[i].model.close - double.parse(NetPositionController.openPositionList[i].buyavgprice.replaceAll(',', ''))) *
                                            int.parse(NetPositionController.openPositionList[i].netqty).abs();
                                      if (NetPositionController.openPositionList[i].model.exch == 'M' && NetPositionController.openPositionList[i].model.exchType == 'D')
                                        pl = NetPositionController.openPositionList[i].pl *
                                            NetPositionController.openPositionList[i].model.factor *
                                            NetPositionController.openPositionList[i].model.minimumLotQty;
                                      totalUnrealisedPL += pl;
                                    }
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: totalUnrealisedPL > 0 ? Utils.lightGreenColor.withOpacity(0.2) : Utils.lightRedColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text("P/L: " + totalUnrealisedPL.toStringAsFixed(2),
                                            style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w700, color: totalUnrealisedPL > 0 ? Utils.mediumGreenColor : Utils.mediumRedColor)),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: NetPositionController.openPositionList.length < 3 ? NetPositionController.openPositionList.length : 3,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap : () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ScriptInfo(
                                            CommonFunction.getScripDataModel(
                                                exch: NetPositionController.openPositionList[index].model.exch,
                                                exchCode: NetPositionController.openPositionList[index].model.exchCode
                                            ),false
                                        )));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  /* Displaying the Script name */
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                                        color: int.parse(NetPositionController.openPositionList[index].netqty) > 0
                                                            ? Utils.brightGreenColor
                                                            : int.parse(NetPositionController.openPositionList[index].netqty) < 0
                                                                ? Utils.brightRedColor
                                                                : Utils.greyColor),
                                                    child: Text(
                                                      int.parse(NetPositionController.openPositionList[index].netqty) > 0
                                                          ? "BUY"
                                                          : int.parse(NetPositionController.openPositionList[index].netqty) < 0
                                                              ? "SELL"
                                                              : 'CLOSE',
                                                      style: Utils.fonts(color: Utils.whiteColor, size: 10.0, fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                  /* Displaying the Script Description */
                                                  Observer(
                                                    builder: (_) => Row(
                                                      children: [
                                                        Text("LTP", style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400)),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          NetPositionController.openPositionList[index].model.close.toStringAsFixed(NetPositionController.openPositionList[index].model.precision),
                                                          style: Utils.fonts(color: theme.errorColor, size: 14.0, fontWeight: FontWeight.w600),
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets.all(0.0),
                                                          child: Icon(
                                                            NetPositionController.openPositionList[index].model.close > NetPositionController.openPositionList[index].model.prevTickRate
                                                                ? Icons.arrow_drop_up_rounded
                                                                : Icons.arrow_drop_down_rounded,
                                                            color: NetPositionController.openPositionList[index].model.close > NetPositionController.openPositionList[index].model.prevTickRate
                                                                ? ThemeConstants.buyColor
                                                                : ThemeConstants.sellColor,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(NetPositionController.openPositionList[index].tradingsymbol.split("-")[0],
                                                      style: Utils.fonts(
                                                        size: 16.0,
                                                        fontWeight: FontWeight.bold,
                                                      )
                                                      // TextStyle(fontSize: 13, color: Colors.grey[600]),
                                                      ),
                                                  Text(NetPositionController.openPositionList[index].netqty + ' @ ' + NetPositionController.openPositionList[index].avgnetprice,
                                                      style: Utils.fonts(
                                                        size: 16.0,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                ],
                                              ),
                                              // /* Displaying the Script Description */
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(NetPositionController.openPositionList[index].exchange.toUpperCase(),
                                                          style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(height: 3, width: 3, decoration: BoxDecoration(color: Utils.greyColor, shape: BoxShape.circle)),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(NetPositionController.openPositionList[index].producttype.toUpperCase(),
                                                          style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                                    ],
                                                  ),
                                                  /* Displaying the price change and percentage change of the script */
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      /* Displaying the price change of the script */
                                                      Observer(
                                                        builder: (_) => Text(
                                                            /* If the LTP is zero before or after market time, it is showing zero instead of price change */
                                                            NetPositionController.openPositionList[index].model.close == 0.00
                                                                ? "0.00"
                                                                : NetPositionController.openPositionList[index].model.priceChangeText,
                                                            style: Utils.fonts(
                                                              size: 12.0,
                                                              fontWeight: FontWeight.w600,
                                                              color: NetPositionController.openPositionList[index].model.priceChange > 0
                                                                  ? ThemeConstants.buyColor
                                                                  : NetPositionController.openPositionList[index].model.priceChange < 0
                                                                      ? ThemeConstants.sellColor
                                                                      : theme.textTheme.bodyText1.color,
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      /* Displaying the percentage change of the script */
                                                      Observer(
                                                        builder: (_) => Text(
                                                            /* If the LTP is zero before or after market time, it is showing zero instead of percentof price change */
                                                            NetPositionController.openPositionList[index].model.close == 0.00
                                                                ? "(0.00%)"
                                                                : NetPositionController.openPositionList[index].model.percentChangeText,
                                                            style: Utils.fonts(
                                                              size: 12.0,
                                                              fontWeight: FontWeight.w600,
                                                              color: NetPositionController.openPositionList[index].model.percentChange > 0
                                                                  ? ThemeConstants.buyColor
                                                                  : NetPositionController.openPositionList[index].model.percentChange < 0
                                                                      ? ThemeConstants.sellColor
                                                                      : theme.textTheme.bodyText1.color,
                                                            )),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              // /* Displaying the Script buy sell status */
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          const Divider(
                                            thickness: 1.5,
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          );
                }),
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget DpHoldings() {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(body: JMOrdersScreen(1))));
              },
              child: InkWell(
                onTap: () {
                  setState(() {
                    InAppSelection.mainScreenIndex = 3;
                    Dataconstants.ordersScreenIndex = 3;
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => MainScreen(
                                toChangeTab: false,
                              )),
                      (route) => false);
                },
                child: Row(
                  children: [
                    Text(
                      "DP Holdings",
                      style: Utils.fonts(
                        size: 17.0,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(height: 200, width: MediaQuery.of(context).size.width, child: Holdings()),
        ],
      ),
    );
  }

  static Widget jmBasket(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "JM Baskets",
                    style: Utils.fonts(
                      size: 17.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        HomeWidgets.scrollTop();
                      },
                      child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(color: Utils.darkGreenColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Electric Vehicles",
                                      style: Utils.fonts(
                                        size: 14.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Min. Amt ",
                                          style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          "1000",
                                          style: Utils.fonts(
                                            size: 13.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(color: Utils.primaryColor, borderRadius: BorderRadius.circular(5.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "Invest Now",
                                          style: Utils.fonts(size: 12.0, color: Utils.whiteColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  "assets/appImages/dashboard/Group 11915.svg",
                                  height: 70,
                                  width: 70,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  static Widget myOngoingSip(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "My Ongoing SIPs",
                    style: Utils.fonts(
                      size: 17.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.lightyellowColor.withOpacity(0.5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                      child: Text(
                        "5 SIPs",
                        style: Utils.fonts(size: 12.0, color: Utils.darkyellowColor),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Obx(() {
                return EquitySipController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (EquitySipController.getEquitySipListItems.isEmpty)
                              Text("No Data Available")
                            else
                              for (var i = 0; i < EquitySipController.getEquitySipListItems.length; i++)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.4)), borderRadius: BorderRadius.circular(10.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    EquitySipController.getEquitySipListItems[i].companyname,
                                                    style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Text(
                                                    "NSE",
                                                    style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: ThemeConstants.buyColor),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                                                  child: Text(
                                                    EquitySipController.getEquitySipListItems[i].sipReturn.toStringAsFixed(2),
                                                    style: Utils.fonts(size: 12.0, color: Utils.whiteColor),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            height: 1.0,
                                            width: 150,
                                            color: Utils.greyColor.withOpacity(0.5),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Amount",
                                                    style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "1000",
                                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Next SIP",
                                                    style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "15 May",
                                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          ],
                        ),
                      );
              })
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  static Widget trendingStocks(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TrendingStocksPage()));
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            "Trending Stocks",
                            style: Utils.fonts(
                              size: 17.0,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        HomeWidgets.scrollTop();
                      },
                      child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Obx(() {
                return MostActiveVolumeController.getMostActiveVolumeListItems.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ScriptInfo(
                                              CommonFunction.getScripDataModel(
                                                  exch: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode) >= 500000 ? "B" : "N",
                                                  exchCode: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode.toString())),
                                              false)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          MostActiveVolumeController.getMostActiveVolumeListItems[index].symbol.toString(),
                                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Observer(
                                          builder: (context) => CommonFunction.getScripDataModel(
                                                          exchCode: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode),
                                                          exch: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode) > 500000 ? "B" : "N")
                                                      .chartMinClose[15]
                                                      .length >
                                                  0
                                              ? SmallSimpleLineChart(
                                                  seriesList: CommonFunction.getScripDataModel(
                                                          exchCode: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode),
                                                          exch: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode) > 500000 ? "B" : "N")
                                                      .dataPoint[15],
                                                  prevClose: MostActiveVolumeController.getMostActiveVolumeListItems[index].closePrice,
                                                  name: MostActiveVolumeController.getMostActiveVolumeListItems[index].symbol,
                                                )
                                              : SizedBox.shrink()),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  MostActiveVolumeController.getMostActiveVolumeListItems[index].closePrice.toString(),
                                                  style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RotatedBox(
                                                          quarterTurns: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? 4 : 2,
                                                          child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg",
                                                              color: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor)),
                                                    ),
                                                    Text(
                                                      "${MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg.toStringAsFixed(2)} %",
                                                      style: Utils.fonts(
                                                          size: 14.0,
                                                          color: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 2,
                              )
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Available",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                            ),
                          ],
                        ),
                      );
              })
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  static Widget otherAsset() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Other Assets",
                      style: Utils.fonts(
                        size: 17.0,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          HomeWidgets.scrollTop();
                        },
                        child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  otherAssetTab = 1;
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Commodities",
                                        style: Utils.fonts(size: 12.0, color: otherAssetTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  otherAssetTab = 2;
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Currencies",
                                        style: Utils.fonts(size: 12.0, color: otherAssetTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  otherAssetTab = 4;
                                  setState(() {});
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                            color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          ),
                                          top: BorderSide(
                                            color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                            width: 1,
                                          )),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "IPOs",
                                        style: Utils.fonts(size: 12.0, color: otherAssetTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    otherAssetTab == 1
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ScriptInfo(
                                                CommonFunction.getScripDataModel(
                                                  exch: "M",
                                                  exchCode: Dataconstants.otherAssets[0].exchCode,
                                                ),
                                                false)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      width: 190,
                                      decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Dataconstants.otherAssets[0].name.toString(),
                                                      style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      Dataconstants.otherAssets[0].expiryDateString,
                                                      style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Observer(builder: (context) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        Dataconstants.otherAssets[0].close == 0.0
                                                            ? Dataconstants.otherAssets[0].prevDayClose.toStringAsFixed(2)
                                                            : "${Dataconstants.otherAssets[0].close.toStringAsFixed(2)}",
                                                        style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Dataconstants.otherAssets[0].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Dataconstants.otherAssets[0].percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                            color: Dataconstants.otherAssets[0].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                          ),
                                                          Text(
                                                            "${Dataconstants.otherAssets[0].percentChange.toStringAsFixed(2)}%",
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                color: Dataconstants.otherAssets[0].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                })
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Observer(
                                                builder: (context) => Dataconstants.otherAssets[0].dataPoint[15].length > 0
                                                    ? SmallSimpleLineChart(
                                                        seriesList: Dataconstants.otherAssets[0].dataPoint[15],
                                                        prevClose: Dataconstants.otherAssets[0].prevDayClose,
                                                        name: Dataconstants.otherAssets[0].name,
                                                      )
                                                    : SizedBox.shrink())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ScriptInfo(
                                                CommonFunction.getScripDataModel(
                                                  exch: "M",
                                                  exchCode: Dataconstants.otherAssets[1].exchCode,
                                                ),
                                                false)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      width: 190,
                                      decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Dataconstants.otherAssets[1].name.toString(),
                                                      style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      Dataconstants.otherAssets[1].expiryDateString,
                                                      style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Observer(builder: (_) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        Dataconstants.otherAssets[1].close == 0.0
                                                            ? Dataconstants.otherAssets[1].prevDayClose.toStringAsFixed(2)
                                                            : "${Dataconstants.otherAssets[1].close.toStringAsFixed(2)}",
                                                        style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Dataconstants.otherAssets[1].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Dataconstants.otherAssets[1].percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                            color: Dataconstants.otherAssets[1].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                          ),
                                                          Text(
                                                            "${Dataconstants.otherAssets[1].percentChange.toStringAsFixed(2)}%",
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                color: Dataconstants.otherAssets[1].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                })
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Observer(
                                                builder: (context) => Dataconstants.otherAssets[1].dataPoint[15].length > 0
                                                    ? SmallSimpleLineChart(
                                                        seriesList: Dataconstants.otherAssets[1].dataPoint[15],
                                                        prevClose: Dataconstants.otherAssets[1].prevDayClose,
                                                        name: Dataconstants.otherAssets[1].name,
                                                      )
                                                    : SizedBox.shrink())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ScriptInfo(
                                                CommonFunction.getScripDataModel(
                                                  exch: "M",
                                                  exchCode: Dataconstants.otherAssets[2].exchCode,
                                                ),
                                                false)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      width: 190,
                                      decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Dataconstants.otherAssets[2].name,
                                                      style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      Dataconstants.otherAssets[2].expiryDateString,
                                                      style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Observer(builder: (_) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        Dataconstants.otherAssets[2].close == 0.0
                                                            ? Dataconstants.otherAssets[2].prevDayClose.toStringAsFixed(2)
                                                            : "${Dataconstants.otherAssets[2].close.toStringAsFixed(2)}",
                                                        style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Dataconstants.otherAssets[2].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Dataconstants.otherAssets[2].percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                            color: Dataconstants.otherAssets[2].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                          ),
                                                          Text(
                                                            "${Dataconstants.otherAssets[2].percentChange.toStringAsFixed(2)}%",
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                color: Dataconstants.otherAssets[2].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                })
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Observer(
                                                builder: (context) => Dataconstants.otherAssets[2].dataPoint[15].length > 0
                                                    ? SmallSimpleLineChart(
                                                        seriesList: Dataconstants.otherAssets[2].dataPoint[15],
                                                        prevClose: Dataconstants.otherAssets[2].prevDayClose,
                                                        name: Dataconstants.otherAssets[2].name,
                                                      )
                                                    : SizedBox.shrink())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ScriptInfo(
                                                CommonFunction.getScripDataModel(
                                                  exch: "M",
                                                  exchCode: Dataconstants.otherAssets[3].exchCode,
                                                ),
                                                false)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      width: 190,
                                      decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Dataconstants.otherAssets[3].name,
                                                      style: Utils.fonts(size: 10.0, fontWeight: FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      Dataconstants.otherAssets[3].expiryDateString,
                                                      style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Observer(builder: (_) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${Dataconstants.otherAssets[3].close.toStringAsFixed(2)}",
                                                        style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Dataconstants.otherAssets[3].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Dataconstants.otherAssets[3].percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                            color: Dataconstants.otherAssets[3].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                          ),
                                                          Text(
                                                            "${Dataconstants.otherAssets[3].percentChange.toStringAsFixed(2)}%",
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                color: Dataconstants.otherAssets[3].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                })
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Observer(
                                                builder: (context) => Dataconstants.otherAssets[3].dataPoint[15].length > 0
                                                    ? SmallSimpleLineChart(
                                                        seriesList: Dataconstants.otherAssets[3].dataPoint[15],
                                                        prevClose: Dataconstants.otherAssets[3].prevDayClose,
                                                        name: Dataconstants.otherAssets[3].name,
                                                      )
                                                    : SizedBox.shrink())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ScriptInfo(
                                                CommonFunction.getScripDataModel(
                                                  exch: "M",
                                                  exchCode: Dataconstants.otherAssets[4].exchCode,
                                                ),
                                                false)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(
                                      width: 190,
                                      decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Dataconstants.otherAssets[4].name,
                                                      style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      Dataconstants.otherAssets[4].expiryDateString,
                                                      style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Observer(builder: (_) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${Dataconstants.otherAssets[4].close.toStringAsFixed(2)}",
                                                        style: Utils.fonts(
                                                            size: 12.0,
                                                            color: Dataconstants.otherAssets[4].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Dataconstants.otherAssets[4].percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                            color: Dataconstants.otherAssets[4].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                          ),
                                                          Text(
                                                            "${Dataconstants.otherAssets[4].percentChange.toStringAsFixed(2)}%",
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                color: Dataconstants.otherAssets[4].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                })
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Observer(
                                                builder: (context) => Dataconstants.otherAssets[4].dataPoint[15].length > 0
                                                    ? SmallSimpleLineChart(
                                                        seriesList: Dataconstants.otherAssets[4].dataPoint[15],
                                                        prevClose: Dataconstants.otherAssets[4].prevDayClose,
                                                        name: Dataconstants.otherAssets[4].name,
                                                      )
                                                    : SizedBox.shrink())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : otherAssetTab == 2
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ScriptInfo(
                                                    CommonFunction.getScripDataModel(
                                                      exch: "C",
                                                      exchCode: Dataconstants.otherAssets[5].exchCode,
                                                    ),
                                                    false)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: Container(
                                          width: 190,
                                          decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          Dataconstants.otherAssets[5].name,
                                                          style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          Dataconstants.otherAssets[5].expiryDateString,
                                                          style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w600),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Observer(builder: (_) {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            "${Dataconstants.otherAssets[5].close.toStringAsFixed(2)}",
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                color: Dataconstants.otherAssets[5].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Dataconstants.otherAssets[5].percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                                color: Dataconstants.otherAssets[5].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                              ),
                                                              Text(
                                                                "${Dataconstants.otherAssets[5].percentChange.toStringAsFixed(2)}%",
                                                                style: Utils.fonts(
                                                                    size: 12.0,
                                                                    color: Dataconstants.otherAssets[5].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                                    fontWeight: FontWeight.w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    })
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Observer(
                                                    builder: (context) => Dataconstants.otherAssets[5].dataPoint[15].length > 0
                                                        ? SmallSimpleLineChart(
                                                            seriesList: Dataconstants.otherAssets[5].dataPoint[15],
                                                            prevClose: Dataconstants.otherAssets[5].prevDayClose,
                                                            name: Dataconstants.otherAssets[5].name,
                                                          )
                                                        : SizedBox.shrink())
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ScriptInfo(
                                                    CommonFunction.getScripDataModel(
                                                      exch: "C",
                                                      exchCode: Dataconstants.otherAssets[6].exchCode,
                                                    ),
                                                    false)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: Container(
                                          width: 190,
                                          decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          Dataconstants.otherAssets[6].name,
                                                          style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          Dataconstants.otherAssets[6].expiryDateString,
                                                          style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w600),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Observer(builder: (_) {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            "${Dataconstants.otherAssets[6].close.toStringAsFixed(2)}",
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                color: Dataconstants.otherAssets[6].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Dataconstants.otherAssets[6].percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                                color: Dataconstants.otherAssets[6].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                              ),
                                                              Text(
                                                                "${Dataconstants.otherAssets[6].percentChange.toStringAsFixed(2)}%",
                                                                style: Utils.fonts(
                                                                    size: 12.0,
                                                                    color: Dataconstants.otherAssets[6].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                                    fontWeight: FontWeight.w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    })
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Observer(
                                                    builder: (context) => Dataconstants.otherAssets[6].dataPoint[15].length > 0
                                                        ? SmallSimpleLineChart(
                                                            seriesList: Dataconstants.otherAssets[6].dataPoint[15],
                                                            prevClose: Dataconstants.otherAssets[6].prevDayClose,
                                                            name: Dataconstants.otherAssets[6].name,
                                                          )
                                                        : SizedBox.shrink())
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ScriptInfo(
                                                    CommonFunction.getScripDataModel(
                                                      exch: "C",
                                                      exchCode: Dataconstants.otherAssets[7].exchCode,
                                                    ),
                                                    false)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: Container(
                                          width: 190,
                                          decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          Dataconstants.otherAssets[7].name,
                                                          style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          Dataconstants.otherAssets[7].expiryDateString,
                                                          style: Utils.fonts(size: 11.0, color: Utils.greyColor, fontWeight: FontWeight.w600),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Observer(builder: (_) {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            "${Dataconstants.otherAssets[7].close.toStringAsFixed(2)}",
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                color: Dataconstants.otherAssets[7].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Dataconstants.otherAssets[7].percentChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                                color: Dataconstants.otherAssets[7].percentChange > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                              ),
                                                              Text(
                                                                "${Dataconstants.otherAssets[7].percentChange.toStringAsFixed(2)}%",
                                                                style: Utils.fonts(
                                                                    size: 12.0,
                                                                    color: Dataconstants.otherAssets[7].percentChange > 0 ? Utils.darkGreenColor : Utils.lightRedColor,
                                                                    fontWeight: FontWeight.w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    })
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Observer(
                                                    builder: (context) => Dataconstants.otherAssets[7].dataPoint[15].length > 0
                                                        ? SmallSimpleLineChart(
                                                            seriesList: Dataconstants.otherAssets[7].dataPoint[15],
                                                            prevClose: Dataconstants.otherAssets[7].prevDayClose,
                                                            name: Dataconstants.otherAssets[7].name,
                                                          )
                                                        : SizedBox.shrink())
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (var i = 0; i < OpenIpoController.getIpoDetailListItems.length; i++)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: Container(
                                          width: 160,
                                          decoration: BoxDecoration(border: Border.all(color: Utils.greyColor.withOpacity(0.5)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          OpenIpoController.getIpoDetailListItems[i].lname.split(" ")[0].toString(),
                                                          style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              formatter.format(OpenIpoController.getIpoDetailListItems[i].opendate),
                                                              style: Utils.fonts(size: 10.0, fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              formatter.format(OpenIpoController.getIpoDetailListItems[i].closdate),
                                                              style: Utils.fonts(
                                                                size: 10.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(children: [
                                                  Text(
                                                    OpenIpoController.getIpoDetailListItems[i].issueprice.toString(),
                                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w600),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    OpenIpoController.getIpoDetailListItems[i].issuepri2.toString(),
                                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w600),
                                                  )
                                                ])
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget research(BuildContext context) {
    return Column(
      children: [
        Observer(builder: (BuildContext context) {
          return Dataconstants.researchCallsModel.fetchingData
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Research",
                            style: Utils.fonts(
                              size: 17.0,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.lightyellowColor.withOpacity(0.5)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                              child: Text(
                                "0 Calls",
                                style: Utils.fonts(size: 12.0, color: Utils.darkyellowColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        color: Utils.primaryColor,
                      ),
                    ],
                  ),
                )
              : Dataconstants.researchCallsModel.researchCalls.data.length == 0
                  ? Center(child: Text("No Data available", style: Utils.fonts()))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ResearchScreen()));
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Research",
                                  style: Utils.fonts(
                                    size: 17.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                                Spacer(),
                                Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.lightyellowColor.withOpacity(0.5)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                    child: Text(
                                      "${Dataconstants.researchCallsModel.researchCalls.data.length.toString()} Calls",
                                      style: Utils.fonts(size: 12.0, color: Utils.darkyellowColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              // Dataconstants.researchCallsModel.intradayList.length > 0
                              //     ?
                              Column(
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: Text(
                                        'Symbol',
                                        textAlign: TextAlign.start,
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 3.5,
                                      child: Text(
                                        'Target',
                                        textAlign: TextAlign.center,
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 3.5,
                                      child: Text(
                                        'Exp.Return',
                                        textAlign: TextAlign.end,
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                      ),
                                    ),
                                  ]),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: Dataconstants.researchCallsModel.researchCalls.data.length >= 4 ? 4 : Dataconstants.researchCallsModel.researchCalls.data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) => ScriptInfo(CommonFunction.getScripDataModel(
                                                  //             exch: Dataconstants.researchCallsModel.researchCalls.data[index].model.exchCode >= 500000 ? "B" : "N",
                                                  //             exchCode: int.parse(Dataconstants.researchCallsModel.researchCalls.data[index].model.exchCode.toString())))));

                                                  showModalBottomSheet(
                                                      backgroundColor: Utils.containerColor,
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (builder) {
                                                        return OrderPlacementBottomSheet(
                                                          segment: Dataconstants.researchCallsModel.researchCalls.data[index].exchsegment,
                                                          stockName: Dataconstants.researchCallsModel.researchCalls.data[index].model.name,
                                                          isBuy: Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Buy" ? true : false,
                                                          currentModel: Dataconstants.researchCallsModel.researchCalls.data[index].model,
                                                        );
                                                      });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width / 3,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 0),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                  color: Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Buy"
                                                                      ? ThemeConstants.buyColor
                                                                      : Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Sell"
                                                                          ? ThemeConstants.sellColor
                                                                          : Utils.greyColor),
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                                                child: Text(
                                                                  Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Buy"
                                                                      ? "BUY"
                                                                      : Dataconstants.researchCallsModel.researchCalls.data[index].buysell == "Sell"
                                                                          ? "SELL"
                                                                          : "",
                                                                  style: Utils.fonts(size: 10.0, color: Utils.whiteColor),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text('${Dataconstants.researchCallsModel.researchCalls.data[index].model.name}',
                                                                style: Utils.fonts(
                                                                  size: 12.0,
                                                                ),
                                                                textAlign: TextAlign.center),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width / 3.5,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 0),
                                                        child: Text('${Dataconstants.researchCallsModel.researchCalls.data[index].targetprice}',
                                                            style: Utils.fonts(size: 14.0, color: Utils.greyColor), textAlign: TextAlign.center),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width / 3.5,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                                                        child: Container(
                                                          // constraints: const BoxConstraints(
                                                          //   maxWidth: 10,
                                                          // ),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Utils.lightGreenColor.withOpacity(0.2)),
                                                          child: Text(
                                                            "",
                                                            textAlign: TextAlign.end,
                                                            style: Utils.fonts(size: 14.0, color: Utils.darkGreenColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                              Divider(thickness: 1)
                                            ],
                                          ),
                                        );
                                      })
                                ],
                              )
                              // : Text(
                              //     "No Research Information Available",
                              //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                              //   )

                              // else
                              //   Dataconstants.researchCallsModel.momentumList.length > 0
                              //       ? Text("JM FINANCIALS")
                              //       : Text(
                              //           "No Research Information Available",
                              //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                              //         )
                            ],
                          )
                        ],
                      ),
                    );
        }),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  static List showingSections(marketBreadthNifty50) {
    // totalMarketValueNifty = (Dataconstants.indicesListener.indices1.totalBuyQty + Dataconstants.indicesListener.indices1.totalSellQty);
    // totalMarketValueSensex = (Dataconstants.indicesListener.indices2.totalBuyQty + Dataconstants.indicesListener.indices2.totalSellQty);
    return List<PieChartSectionData>.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Utils.primaryColor,
            value: marketBreadthNifty50 ? NseAdvanceController.nseAdvanceLength.toDouble() : BseAdvanceController.bseAdvanceLength.toDouble(),
            // (gettingNiftyModel.totalSellQty / totalMarketValue) == null
            //     ? 0.0
            //     : (gettingNiftyModel.totalSellQty / totalMarketValue),
            title: " ",
            //"${gettingNiftyModel.totalSellQty / totalMarketValue}",
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: marketBreadthNifty50 ? 50.0 - NseAdvanceController.nseAdvanceLength.toDouble() : 30 - BseAdvanceController.bseAdvanceLength.toDouble(),
            //gettingNiftyModel.totalBuyQty / totalMarketValue ?? 0,
            title: " ",
            //"${gettingNiftyModel.totalBuyQty / totalMarketValue}",
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }

  static Widget marketBreadth() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Market Breadth",
                        style: Utils.fonts(
                          size: 17.0,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          // InkWell(
                          //   onTap: () async {
                          //     String deviceName, osName, devicemodel;
                          //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                          //
                          //     if (Platform.isIOS) {
                          //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                          //       //print("${iosInfo.name}");
                          //       deviceName = iosInfo.name;
                          //       osName = iosInfo.systemVersion;
                          //       devicemodel = iosInfo.model;
                          //     } else {
                          //       AndroidDeviceInfo androidInfo =
                          //       await deviceInfo.androidInfo;
                          //       //print("${androidInfo.brand}");
                          //       deviceName = androidInfo.brand.replaceAll(' ', '');
                          //       osName = 'Android${androidInfo.version.release}';
                          //       devicemodel = androidInfo.model;
                          //     }
                          //
                          //     CommonFunction.firebaseEvent(
                          //       clientCode: "dummy",
                          //       device_manufacturer: deviceName,
                          //       device_model: devicemodel,
                          //       eventId: "6.0.4.0.0",
                          //       eventLocation: "body",
                          //       eventMetaData: "dummy",
                          //       eventName: "nifty",
                          //       os_version: osName,
                          //       location: "dummy",
                          //       eventType:"Click",
                          //       sessionId: "dummy",
                          //       platform: Platform.isAndroid ? 'Android' : 'iOS',
                          //       screenName: "guest user dashboard",
                          //       serverTimeStamp: DateTime.now().toString(),
                          //       source_metadata: "dummy",
                          //       subType: "card",
                          //     );
                          //
                          //   },
                          //   child: Container(
                          //       decoration: BoxDecoration(
                          //         border: Border(
                          //             left: BorderSide(
                          //               color: Utils.primaryColor,
                          //               width: 1,
                          //             ),
                          //             top: BorderSide(
                          //               color: Utils.primaryColor,
                          //               width: 1,
                          //             ),
                          //             bottom: BorderSide(
                          //               color: Utils.primaryColor,
                          //               width: 1,
                          //             ),
                          //             right: BorderSide(
                          //               color: Utils.primaryColor,
                          //               width: 1,
                          //             )),
                          //       ),
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Text(
                          //           "Nifty 50",
                          //           style: Utils.fonts(size: 12.0, color: Utils.primaryColor, fontWeight: FontWeight.w500),
                          //         ),
                          //       )),
                          // ),
                          InkWell(
                            onTap: () async {
                              CommonFunction.firebaseEvent(
                                clientCode: "dummy",
                                device_manufacturer: Dataconstants.deviceName,
                                device_model: Dataconstants.devicemodel,
                                eventId: "6.0.4.0.0",
                                eventLocation: "body",
                                eventMetaData: "dummy",
                                eventName: "nifty",
                                os_version: Dataconstants.osName,
                                location: "dummy",
                                eventType: "Click",
                                sessionId: "dummy",
                                platform: Platform.isAndroid ? 'Android' : 'iOS',
                                screenName: "guest user dashboard",
                                serverTimeStamp: DateTime.now().toString(),
                                source_metadata: "dummy",
                                subType: "card",
                              );
                              setState(() {
                                marketBreadthNifty50 = true;
                                marketBreadthSensex = false;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: marketBreadthNifty50 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: marketBreadthNifty50 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: marketBreadthNifty50 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: marketBreadthNifty50 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Nifty 50",
                                    style: Utils.fonts(size: 12.0, color: marketBreadthNifty50 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () async {
                              CommonFunction.firebaseEvent(
                                clientCode: "dummy",
                                device_manufacturer: Dataconstants.deviceName,
                                device_model: Dataconstants.devicemodel,
                                eventId: "6.0.5.0.0",
                                eventLocation: "body",
                                eventMetaData: "dummy",
                                eventName: "sensex",
                                os_version: Dataconstants.osName,
                                location: "dummy",
                                eventType: "Click",
                                sessionId: "dummy",
                                platform: Platform.isAndroid ? 'Android' : 'iOS',
                                screenName: "guest user dashboard",
                                serverTimeStamp: DateTime.now().toString(),
                                source_metadata: "dummy",
                                subType: "card",
                              );
                              setState(() {
                                marketBreadthSensex = true;
                                marketBreadthNifty50 = false;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                        color: marketBreadthSensex ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: marketBreadthSensex ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: marketBreadthSensex ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sensex",
                                    style: Utils.fonts(size: 12.0, color: marketBreadthSensex ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(alignment: Alignment.center, children: [
                        Container(
                          height: 200,
                          width: 200,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                                    });
                                  }),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingSections(marketBreadthNifty50)),
                            ),
                          ),
                        ),
                        Stack(alignment: Alignment.center, children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      height: 20,
                                      child: Text(
                                          marketBreadthNifty50
                                              ? "${((NseAdvanceController.nseAdvanceLength / 50) * 100).toStringAsFixed(2)}%"
                                              : "${((BseAdvanceController.bseAdvanceLength / 30) * 100).toStringAsFixed(2)}%",
                                          style: Utils.fonts(size: 10.0))),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    height: 20,
                                    child: Text(
                                        marketBreadthNifty50
                                            ? "${(((NseAdvanceController.nseAdvanceLength / 50) * 100) - 100).abs().toStringAsFixed(2)}%"
                                            : "${(((BseAdvanceController.bseAdvanceLength / 30) * 100) - 100).abs().toStringAsFixed(2)}%",
                                        style: Utils.fonts(size: 10.0)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Transform.rotate(
                            angle: 1,
                            child: Container(height: 50, width: 1, decoration: BoxDecoration(border: Border.all())),
                          )
                        ])
                      ]),
                      Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Utils.primaryColor),
                                ),
                              ),
                              Text(
                                "ADV: ${marketBreadthNifty50 ? NseAdvanceController.nseAdvanceLength : BseAdvanceController.bseAdvanceLength}",
                                // "ADV: ${Dataconstants.marketWatchList[0].adv.toString()}",
                                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.orange),
                                ),
                              ),
                              Text(
                                "DEC: ${marketBreadthNifty50 ? (50.0 - NseAdvanceController.nseAdvanceLength.toDouble()).toInt() : (30.0 - BseAdvanceController.bseAdvanceLength.toDouble()).toInt()}",
                                // "DEC: ${Dataconstants.marketWatchList[0].dec.toString()}",
                                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 4.0,
              width: MediaQuery.of(context).size.width,
              color: Utils.greyColor.withOpacity(0.2),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      });
    });
  }

  static Widget topPerformingIndus() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TopPerformingIndustriesPage()));
                  },
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            topPerformingIndustriesExpanded ? topPerformingIndustriesExpanded = false : topPerformingIndustriesExpanded = true;
                          });
                        },
                        child: Text(
                          "Top Performing Industries",
                          style: Utils.fonts(
                            size: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      SvgPicture.asset("assets/appImages/markets/up_arrow.svg")
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       InkWell(
                //         onTap: () {
                //           topPerformingIndustriesTab = 1;
                //           setState(() {});
                //         },
                //         child: Container(
                //             decoration: BoxDecoration(
                //               border: Border(
                //                   left: BorderSide(
                //                     color: topPerformingIndustriesTab == 1 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   top: BorderSide(
                //                     color: topPerformingIndustriesTab == 1 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   bottom: BorderSide(
                //                     color: topPerformingIndustriesTab == 1 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   right: BorderSide(
                //                     color: topPerformingIndustriesTab == 1 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   )),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(
                //                 "1 Day",
                //                 style: Utils.fonts(size: 12.0, color: topPerformingIndustriesTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                //               ),
                //             )),
                //       ),
                //       InkWell(
                //         onTap: () {
                //           topPerformingIndustriesTab = 2;
                //           setState(() {});
                //         },
                //         child: Container(
                //             decoration: BoxDecoration(
                //               border: Border(
                //                   left: BorderSide(
                //                     color: topPerformingIndustriesTab == 2 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   top: BorderSide(
                //                     color: topPerformingIndustriesTab == 2 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   bottom: BorderSide(
                //                     color: topPerformingIndustriesTab == 2 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   right: BorderSide(
                //                     color: topPerformingIndustriesTab == 2 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   )),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(
                //                 "6 Days",
                //                 style: Utils.fonts(size: 12.0, color: topPerformingIndustriesTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                //               ),
                //             )),
                //       ),
                //       InkWell(
                //         onTap: () {
                //           topPerformingIndustriesTab = 3;
                //           setState(() {});
                //         },
                //         child: Container(
                //             decoration: BoxDecoration(
                //               border: Border(
                //                   left: BorderSide(
                //                     color: topPerformingIndustriesTab == 3 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   top: BorderSide(
                //                     color: topPerformingIndustriesTab == 3 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   bottom: BorderSide(
                //                     color: topPerformingIndustriesTab == 3 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   right: BorderSide(
                //                     color: topPerformingIndustriesTab == 3 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   )),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(
                //                 "1 Month",
                //                 style: Utils.fonts(size: 12.0, color: topPerformingIndustriesTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                //               ),
                //             )),
                //       ),
                //       InkWell(
                //         onTap: () {
                //           topPerformingIndustriesTab = 4;
                //           setState(() {});
                //         },
                //         child: Container(
                //             decoration: BoxDecoration(
                //               border: Border(
                //                   left: BorderSide(
                //                     color: topPerformingIndustriesTab == 4 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   top: BorderSide(
                //                     color: topPerformingIndustriesTab == 4 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   bottom: BorderSide(
                //                     color: topPerformingIndustriesTab == 4 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   right: BorderSide(
                //                     color: topPerformingIndustriesTab == 4 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   )),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(
                //                 "3 Months",
                //                 style: Utils.fonts(size: 12.0, color: topPerformingIndustriesTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                //               ),
                //             )),
                //       ),
                //       InkWell(
                //         onTap: () {
                //           topPerformingIndustriesTab = 5;
                //           setState(() {});
                //         },
                //         child: Container(
                //             decoration: BoxDecoration(
                //               border: Border(
                //                   left: BorderSide(
                //                     color: topPerformingIndustriesTab == 5 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   top: BorderSide(
                //                     color: topPerformingIndustriesTab == 5 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   bottom: BorderSide(
                //                     color: topPerformingIndustriesTab == 5 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   right: BorderSide(
                //                     color: topPerformingIndustriesTab == 5 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   )),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(
                //                 "6 Months",
                //                 style: Utils.fonts(size: 12.0, color: topPerformingIndustriesTab == 5 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                //               ),
                //             )),
                //       ),
                //       InkWell(
                //         onTap: () {
                //           topPerformingIndustriesTab = 6;
                //           setState(() {});
                //         },
                //         child: Container(
                //             decoration: BoxDecoration(
                //               border: Border(
                //                   left: BorderSide(
                //                     color: topPerformingIndustriesTab == 6 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   top: BorderSide(
                //                     color: topPerformingIndustriesTab == 6 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   bottom: BorderSide(
                //                     color: topPerformingIndustriesTab == 6 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   ),
                //                   right: BorderSide(
                //                     color: topPerformingIndustriesTab == 6 ? Utils.primaryColor : Utils.greyColor,
                //                     width: 1,
                //                   )),
                //             ),
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(
                //                 "1 Year",
                //                 style: Utils.fonts(size: 12.0, color: topPerformingIndustriesTab == 6 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                //               ),
                //             )),
                //       ),
                //     ],
                //   ),
                // ),
                Obx(() {
                  return TopPerformingIndustriesController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : TopPerformingIndustriesController.getTopPerformingIndustriesListItems.isEmpty
                          ? Text("No Data available")
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        child: Text(
                                          TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].sectorName,
                                          overflow: TextOverflow.clip,
                                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 15,
                                                width:
                                                    TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].deliveryPerChange * 0.09 >= MediaQuery.of(context).size.height * 0.15
                                                        ? MediaQuery.of(context).size.height * 0.15
                                                        : TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].deliveryPerChange * 0.08,
                                                decoration:
                                                    BoxDecoration(color: Utils.lightGreenColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].deliveryPerChange.toStringAsFixed(2)}%",
                                        style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                );
                              });
                })
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget orders() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      var theme = Theme.of(context);
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          InAppSelection.mainScreenIndex = 3;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => MainScreen(
                                        toChangeTab: false,
                                      )),
                              (route) => false);
                        });
                      },
                      child: Text(
                        "Orders",
                        style: Utils.fonts(size: 17.0),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            InAppSelection.mainScreenIndex = 3;
                            Dataconstants.ordersScreenIndex = 1;
                            setState(() {});
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => MainScreen(
                                          toChangeTab: false,
                                        )),
                                (route) => false);
                          });
                        },
                        child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg")),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          HomeWidgets.scrollTop();
                        },
                        child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  if (OrderBookController.isLoading.value)
                    return Center(child: CircularProgressIndicator());
                  else
                    return OrderBookController.executedList.length == 0
                        ? Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset('assets/appImages/noOrders.svg'),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "You have no Executed Orders in Order Book",
                                    style: Utils.fonts(
                                      size: 15.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // MaterialButton(
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(18.0),
                                  //       side: BorderSide(
                                  //         color: theme.primaryColor,
                                  //       ),
                                  //     ),
                                  //     color: theme.primaryColor,
                                  //     padding: EdgeInsets.symmetric(horizontal: 50),
                                  //     child: Text(
                                  //       'GO TO WATCHLIST',
                                  //       style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.white),
                                  //     ),
                                  //     onPressed: () {
                                  //       InAppSelection.mainScreenIndex = 1;
                                  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  //           builder: (_) => MainScreen(
                                  //                 toChangeTab: false,
                                  //               )));
                                  //     })
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: OrderBookController.executedList.length < 3 ? OrderBookController.executedList.length : 3,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap : () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScriptInfo(
                                    CommonFunction.getScripDataModel(
                                      exch: OrderBookController.executedList[index].model.exch,
                                      exchCode: OrderBookController.executedList[index].model.exchCode
                                    ),false
                                  )));
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            /* Displaying the Script name */
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  color: OrderBookController.executedList[index].transactiontype == 'BUY' ? ThemeConstants.buyColor : ThemeConstants.sellColor),
                                              child: Text(
                                                OrderBookController.executedList[index].transactiontype,
                                                style: Utils.fonts(color: Utils.whiteColor, size: 10.0, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            /* Displaying the Script Description */
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  color: OrderBookController.executedList[index].status == 'complete' || OrderBookController.executedList[index].status == 'open'
                                                      ? ThemeConstants.buyColor.withOpacity(0.2)
                                                      : OrderBookController.executedList[index].status == 'rejected'
                                                          ? ThemeConstants.sellColor.withOpacity(0.2)
                                                          : Utils.greyColor.withOpacity(0.2)),
                                              child: Text(
                                                OrderBookController.executedList[index].status == 'complete' || OrderBookController.executedList[index].status == 'open'
                                                    ? 'EXECUTED'
                                                    : OrderBookController.executedList[index].status.toUpperCase(),
                                                style: Utils.fonts(
                                                    color: OrderBookController.executedList[index].status == 'complete' || OrderBookController.executedList[index].status == 'open'
                                                        ? ThemeConstants.buyColor
                                                        : OrderBookController.executedList[index].status == 'rejected'
                                                            ? ThemeConstants.sellColor
                                                            : Utils.greyColor,
                                                    size: 10.0,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(OrderBookController.executedList[index].model.name.toUpperCase(),
                                                style: Utils.fonts(
                                                  size: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                )
                                                // TextStyle(fontSize: 13, color: Colors.grey[600]),
                                                ),
                                            Text(
                                                "${OrderBookController.executedList[index].status == 'open' ? OrderBookController.executedList[index].filledshares : OrderBookController.executedList[index].quantity}" +
                                                    ' @ ' +
                                                    '${OrderBookController.executedList[index].ordertype == 'MARKET' ? OrderBookController.executedList[index].averageprice : OrderBookController.executedList[index].price}',
                                                style: Utils.fonts(
                                                  size: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                        // /* Displaying the Script Description */
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                      text: OrderBookController.executedList[index].exchange == 'NSE'
                                                          ? OrderBookController.executedList[index].exchange.toUpperCase()
                                                          : OrderBookController.executedList[index].exchange == 'BSE'
                                                              ? OrderBookController.executedList[index].exchange.toUpperCase()
                                                              : OrderBookController.executedList[index].expirydate.split(',')[0].toUpperCase(),
                                                      style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                                                      children: [
                                                        if (OrderBookController.executedList[index].model.exchCategory != ExchCategory.nseEquity ||
                                                            OrderBookController.executedList[index].model.exchCategory != ExchCategory.bseEquity)
                                                          TextSpan(text: ' '),
                                                        if (OrderBookController.executedList[index].model.exchCategory != ExchCategory.nseEquity ||
                                                            OrderBookController.executedList[index].model.exchCategory != ExchCategory.bseEquity)
                                                          TextSpan(
                                                            text: OrderBookController.executedList[index].model.exchCategory == ExchCategory.nseFuture ||
                                                                    OrderBookController.executedList[index].model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                                                    OrderBookController.executedList[index].model.exchCategory == ExchCategory.currenyFutures ||
                                                                    OrderBookController.executedList[index].model.exchCategory == ExchCategory.mcxFutures
                                                                ? 'FUT'
                                                                : OrderBookController.executedList[index].model.exchCategory == ExchCategory.nseOptions ||
                                                                        OrderBookController.executedList[index].model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                                                        OrderBookController.executedList[index].model.exchCategory == ExchCategory.currenyOptions ||
                                                                        OrderBookController.executedList[index].model.exchCategory == ExchCategory.mcxOptions
                                                                    ? OrderBookController.executedList[index].strikeprice.split('.')[0]
                                                                    : '',
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                fontWeight: FontWeight.w400,
                                                                color: OrderBookController.executedList[index].model.exchCategory == ExchCategory.nseFuture ||
                                                                        OrderBookController.executedList[index].model.exchCategory == ExchCategory.bseCurrenyFutures ||
                                                                        OrderBookController.executedList[index].model.exchCategory == ExchCategory.currenyFutures ||
                                                                        OrderBookController.executedList[index].model.exchCategory == ExchCategory.mcxFutures
                                                                    ? Utils.primaryColor
                                                                    : Utils.greyColor),
                                                          ),
                                                        if (OrderBookController.executedList[index].model.exchCategory == ExchCategory.nseOptions ||
                                                            OrderBookController.executedList[index].model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                                            OrderBookController.executedList[index].model.exchCategory == ExchCategory.currenyOptions ||
                                                            OrderBookController.executedList[index].model.exchCategory == ExchCategory.mcxOptions)
                                                          TextSpan(text: ' '),
                                                        if (OrderBookController.executedList[index].model.exchCategory == ExchCategory.nseOptions ||
                                                            OrderBookController.executedList[index].model.exchCategory == ExchCategory.bseCurrenyOptions ||
                                                            OrderBookController.executedList[index].model.exchCategory == ExchCategory.currenyOptions ||
                                                            OrderBookController.executedList[index].model.exchCategory == ExchCategory.mcxOptions)
                                                          TextSpan(
                                                            text: OrderBookController.executedList[index].model.cpType == 3 ? 'CE' : 'PE',
                                                            style: Utils.fonts(
                                                                size: 12.0,
                                                                fontWeight: FontWeight.w400,
                                                                color: OrderBookController.executedList[index].model.cpType == 3 ? Utils.lightGreenColor : Utils.lightRedColor),
                                                          )
                                                      ]),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Container(height: 3, width: 3, decoration: BoxDecoration(color: Utils.greyColor, shape: BoxShape.circle)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(OrderBookController.executedList[index].producttype.toUpperCase(),
                                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                                              ],
                                            ),
                                            /* Displaying the price change and percentage change of the script */
                                            Observer(
                                              builder: (_) => Row(
                                                children: [
                                                  Text("LTP", style: Utils.fonts(color: Utils.greyColor, size: 12.0, fontWeight: FontWeight.w400)),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    OrderBookController.executedList[index].model.close.toStringAsFixed(OrderBookController.executedList[index].model.precision),
                                                    style: Utils.fonts(
                                                        color: OrderBookController.executedList[index].model.close > OrderBookController.executedList[index].model.prevTickRate
                                                            ? ThemeConstants.buyColor
                                                            : OrderBookController.executedList[index].model.close < OrderBookController.executedList[index].model.prevTickRate
                                                                ? ThemeConstants.sellColor
                                                                : theme.errorColor,
                                                        size: 14.0,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(0.0),
                                                    child: Icon(
                                                      OrderBookController.executedList[index].model.close > OrderBookController.executedList[index].model.prevTickRate
                                                          ? Icons.arrow_drop_up_rounded
                                                          : Icons.arrow_drop_down_rounded,
                                                      color: OrderBookController.executedList[index].model.close > OrderBookController.executedList[index].model.prevTickRate
                                                          ? ThemeConstants.buyColor
                                                          : ThemeConstants.sellColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        // /* Displaying the Script buy sell status */
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(
                                      thickness: 1.5,
                                    )
                                  ],
                                ),
                              );
                            });
                }),
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget topGrainers() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    // if (topGainersExpanded == false) {
                    //   topGainersExpanded = true;
                    // } else if (topGainersExpanded == true) {
                    //   topGainersExpanded = false;
                    // }
                    // setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MarketStatsNext(
                                  name: "Top Gainers",
                                  currentTabIndex: 0,
                                )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Top Gainers",
                        style: Utils.fonts(
                          size: 17.0,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            HomeWidgets.scrollTop();
                          },
                          child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              topGainersTab = 1;
                              Dataconstants.topGainersController.getTopGainers("nse", "nifty", "day");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "1 Day",
                                    style: Utils.fonts(size: 12.0, color: topGainersTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topGainersTab = 3;
                              Dataconstants.topGainersController.getTopGainers("nse", "nifty", "week");

                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Weekly",
                                    style: Utils.fonts(size: 12.0, color: topGainersTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topGainersTab = 2;
                              Dataconstants.topGainersController.getTopGainers("nse", "nifty", "month");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Monthly",
                                    style: Utils.fonts(size: 12.0, color: topGainersTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topGainersTab = 4;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "My Holdings",
                                    style: Utils.fonts(size: 12.0, color: topGainersTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                topGainersTab == 4
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Available",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                            ),
                          ],
                        ),
                      )
                    : Obx(() {
                        return TopGainersController.isLoading.value
                            ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Align(alignment: Alignment.center, child: Center(child: CircularProgressIndicator())))
                            : TopGainersController.getTopGainersListItems.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: TopGainersController.getTopGainersListItems.length <= 4 ? TopGainersController.getTopGainersListItems.length : 4,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ScriptInfo(
                                                            CommonFunction.getScripDataModel(
                                                                exch: int.parse(TopGainersController.getTopGainersListItems[index].scCode) >= 500000 ? "B" : "N",
                                                                exchCode: int.parse(TopGainersController.getTopGainersListItems[index].scCode.toString())),
                                                            false)));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        TopGainersController.getTopGainersListItems[index].symbol,
                                                        style: Utils.fonts(),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 8.0),
                                                            child: RotatedBox(
                                                              quarterTurns: TopGainersController.getTopGainersListItems[index].perchg > 0 ? 4 : 2,
                                                              child: SvgPicture.asset(
                                                                "assets/appImages/inverted_rectangle.svg",
                                                                color: Utils.lightGreenColor,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "${TopGainersController.getTopGainersListItems[index].perchg.toStringAsFixed(2)} %",
                                                            style: Utils.fonts(
                                                              color: Utils.mediumGreenColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          SizedBox(),
                                                          Text(
                                                            TopGainersController.getTopGainersListItems[index].prevClose.toString(),
                                                            style: Utils.fonts(
                                                              color: Utils.greyColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            )
                                          ],
                                        );
                                      },
                                    ))
                                : Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Data Available",
                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                        ),
                                      ],
                                    ),
                                  );
                      }),
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget events() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      // print(DateFormat.yMd(EventsDividendController.getEventsDividendListItems[0].divDate.toString()));
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EventsPage()));
                  },
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // setState(() {
                          //   eventsExpanded
                          //       ? eventsExpanded = false
                          //       : eventsExpanded = true;
                          // });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => MarketStatsNext(
                          //               name: "Events",
                          //               currentTabIndex: 3,
                          //             )));
                        },
                        child: Text(
                          "Events",
                          style: Utils.fonts(
                            size: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            HomeWidgets.scrollTop();
                          },
                          child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          eventsTab = 1;
                          setState(() {
                            Dataconstants.eventsDividendController.getEventsDividend();
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                    color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  top: BorderSide(
                                    color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Dividend",
                                style: Utils.fonts(size: 12.0, color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          eventsTab = 2;
                          setState(() {
                            Dataconstants.eventsBonusController.getEventsBonus();
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                    color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  top: BorderSide(
                                    color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Bonus",
                                style: Utils.fonts(size: 12.0, color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          eventsTab = 3;
                          setState(() {
                            Dataconstants.eventsRightsController.getEventsRights();
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                    color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  top: BorderSide(
                                    color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Rights",
                                style: Utils.fonts(size: 12.0, color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          eventsTab = 4;
                          Dataconstants.eventsSplitsController.getEventsSplits();
                          setState(() {});
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                    color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  top: BorderSide(
                                    color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Splits",
                                style: Utils.fonts(size: 12.0, color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          eventsTab = 5;
                          setState(() {
                            Dataconstants.boardMeetController.getEventsBoardMeet();
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                    color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  top: BorderSide(
                                    color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Board Meet",
                                style: Utils.fonts(size: 12.0, color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          eventsTab = 6;
                          setState(() {});
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                    color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  top: BorderSide(
                                    color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Earnings",
                                style: Utils.fonts(size: 12.0, color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Row(children: [
                //   Container(
                //     width: MediaQuery.of(context).size.width * 0.3,
                //     child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                //   ),
                //   mostActiveTab == 2
                //       ? Container(width: MediaQuery.of(context).size.width * 0.3, child: Text("Value Traded(Cr)", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                //       : mostActiveTab == 1
                //           ? Container(
                //               width: MediaQuery.of(context).size.width * 0.3,
                //               child: Text("Ex-Date", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                //           : mostActiveTab == 3 || mostActiveTab == 4 || mostActiveTab == 5
                //               ? Container(
                //                   width: MediaQuery.of(context).size.width * 0.3,
                //                   child: Text("Traded Qty", textAlign: TextAlign.center, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                //               : Container(
                //                   width: MediaQuery.of(context).size.width * 0.3,
                //                   child: Text("Volume", textAlign: TextAlign.center, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))),
                //   mostActiveTab == 3 || mostActiveTab == 4 || mostActiveTab == 5
                //       ? Container(width: MediaQuery.of(context).size.width * 0.3, child: Text("Turnover", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                //       : Column(
                //           crossAxisAlignment: CrossAxisAlignment.end,
                //           children: [
                //             mostActiveTab == 1
                //                 ? Container(
                //                     width: MediaQuery.of(context).size.width * 0.3,
                //                     child: Text("Dividend", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                //                 : mostActiveTab == 2
                //                     ? Container(
                //                         width: MediaQuery.of(context).size.width * 0.3,
                //                         child: Text("Bonus Ratio", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                //                     : Container(
                //                         decoration: BoxDecoration(border: Border.all()),
                //                         width: MediaQuery.of(context).size.width * 0.3,
                //                         child: Text("LTP", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))),
                //             mostActiveTab == 1
                //                 ? SizedBox.shrink()
                //                 : Container(
                //                     width: MediaQuery.of(context).size.width * 0.3,
                //                     child: Text("%Chg", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))),
                //           ],
                //         ),
                // ]),
                // SizedBox(height: 10),
                Obx(() {
                  return eventsTab == 1
                      ? EventsDividendController.isLoading.value
                          ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Center(child: CircularProgressIndicator()))
                          : EventsDividendController.getEventsDividendListItems.isEmpty
                              ? Center(child: Text("No Data available"))
                              : Column(
                                  children: [
                                    Row(children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: Text("Ex-Date", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: Text("Dividend", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                      ),
                                    ]),
                                    Divider(thickness: 1),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: EventsDividendController.getEventsDividendListItems.length <= 4 ? EventsDividendController.getEventsDividendListItems.length : 4,
                                      itemBuilder: (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ScriptInfo(
                                                        CommonFunction.getScripDataModel(
                                                            exch: int.parse(EventsDividendController.getEventsDividendListItems[index].scCode) >= 500000 ? "B" : "N",
                                                            exchCode: int.parse(EventsDividendController.getEventsDividendListItems[index].scCode.toString())),
                                                        false)));
                                          },
                                          child: Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                    child: Text(EventsDividendController.getEventsDividendListItems[index].coName,
                                                        style: Utils.fonts(
                                                          fontWeight: FontWeight.w500,
                                                          size: 14.0,
                                                        )),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                    child: Text(
                                                        "${EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[2]} ${EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "01" ? "Jan ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "02" ? "Feb ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "03" ? "Mar ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "04" ? "Apr ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "05" ? "May ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "06" ? "Jun ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "07" ? "Jul ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "08" ? "Aug ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "09" ? "Sep ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "10" ? "Oct ," : EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "11" ? "Nov ," : "Dec ,"} ${EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[0]}",
                                                        textAlign: TextAlign.end,
                                                        style: Utils.fonts(
                                                          fontWeight: FontWeight.w400,
                                                          size: 14.0,
                                                        )),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text("${EventsDividendController.getEventsDividendListItems[index].divamt.toStringAsFixed(2)}",
                                                            style: Utils.fonts(
                                                              fontWeight: FontWeight.w400,
                                                              size: 14.0,
                                                            )),
                                                        Text("/ share",
                                                            style: Utils.fonts(
                                                              fontWeight: FontWeight.w500,
                                                              size: 14.0,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(
                                              thickness: 2,
                                              color: Colors.grey[350],
                                            ),
                                          ]),
                                        );
                                      },
                                    )
                                  ],
                                )
                      : eventsTab == 2
                          ? EventsBonusController.isLoading.value
                              ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Center(child: CircularProgressIndicator()))
                              : EventsBonusController.getEventsBonusListItems.isEmpty
                                  ? Center(child: Text("No Data available"))
                                  : Column(
                                      children: [
                                        Row(children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child: Text("Ex-Date", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child: Text("Bonus", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                          ),
                                        ]),
                                        Divider(thickness: 1),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: EventsBonusController.getEventsBonusListItems.length <= 4 ? EventsBonusController.getEventsBonusListItems.length : 4,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              //   child: Row(
                                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //     children: [
                                              //       Container(
                                              //           width: MediaQuery.of(context).size.width * 0.3,
                                              //           child: Text(EventsBonusController.getEventsBonusListItems[index].symbol,
                                              //               style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, ))),
                                              //       Container(
                                              //         width: MediaQuery.of(context).size.width * 0.3,
                                              //         child: Text(EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0],
                                              //             style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                              //       ),
                                              //       Container(
                                              //         width: MediaQuery.of(context).size.width * 0.3,
                                              //         child: Text(EventsBonusController.getEventsBonusListItems[index].bonusRatio,
                                              //             style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ScriptInfo(
                                                              CommonFunction.getScripDataModel(
                                                                  exch: int.parse(EventsBonusController.getEventsBonusListItems[index].scCode) >= 500000 ? "B" : "N",
                                                                  exchCode: int.parse(EventsBonusController.getEventsBonusListItems[index].scCode.toString())),
                                                              false)));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.3,
                                                        child: Text(EventsBonusController.getEventsBonusListItems[index].coName,
                                                            style: Utils.fonts(
                                                              fontWeight: FontWeight.w400,
                                                              size: 14.0,
                                                            )),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.3,
                                                        child: Text(
                                                            "${EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[2]} ${EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0].split("-")[1] == "01" ? "Jan ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "02" ? "Feb ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "03" ? "Mar ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "04" ? "Apr ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "05" ? "May ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "06" ? "Jun ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "07" ? "Jul ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "08" ? "Aug ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "09" ? "Sep ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "10" ? "Oct ," : EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[1] == "11" ? "Nov ," : "Dec ,"} ${EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0].split("-")[0]}",
                                                            textAlign: TextAlign.end,
                                                            style: Utils.fonts(
                                                              fontWeight: FontWeight.w400,
                                                              size: 14.0,
                                                            )),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.3,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("${EventsBonusController.getEventsBonusListItems[index].bonusRatio}",
                                                                style: Utils.fonts(
                                                                  fontWeight: FontWeight.w400,
                                                                  size: 14.0,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // SizedBox(
                                              //   height: 10,
                                              // ),
                                              // Padding(
                                              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              //   child: Row(
                                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //     children: [
                                              //       Column(
                                              //         crossAxisAlignment: CrossAxisAlignment.start,
                                              //         children: [
                                              //           Text("Announcement Date", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                              //           Text(EventsBonusController.getEventsBonusListItems[index].announcementDate.toString().split(" ")[0],
                                              //               style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                              //         ],
                                              //       ),
                                              //       Column(
                                              //         crossAxisAlignment: CrossAxisAlignment.end,
                                              //         children: [
                                              //           Text("Ex Bonus", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                              //           Text(EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0],
                                              //               style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                              //         ],
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              Divider(
                                                thickness: 2,
                                                color: Colors.grey[350],
                                              ),
                                            ]);
                                          },
                                        )
                                      ],
                                    )
                          : eventsTab == 3
                              ? EventsRightsController.isLoading.value
                                  ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Center(child: CircularProgressIndicator()))
                                  : EventsBonusController.getEventsBonusListItems.isEmpty
                                      ? Center(child: Text("No Data available"))
                                      : Column(
                                          children: [
                                            Row(children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.3,
                                                child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.3,
                                                child: Text("Ex-Date", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.3,
                                                child: Text("Rights", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                              ),
                                            ]),
                                            Divider(thickness: 1),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: EventsRightsController.getEventsRightsListItems.length >= 4 ? 4 : EventsRightsController.getEventsRightsListItems.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(children: [
                                                  InkWell(
                                                    onTap: () {
                                                      // Navigator.push(context, MaterialPageRoute(
                                                      //     builder: (context) => ScriptInfo(
                                                      //         CommonFunction.getScripDataModel(
                                                      //             exch: int.parse(EventsRightsController.getEventsRightsListItems[index].) >= 500000 ? "B" : "N",
                                                      //             exchCode: int.parse(EventsRightsController.getEventsRightsListItems[index].scCode.toString()
                                                      //             )))));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.3,
                                                            child: Text(EventsRightsController.getEventsRightsListItems[index].symbol,
                                                                style: Utils.fonts(
                                                                  fontWeight: FontWeight.w500,
                                                                  size: 14.0,
                                                                )),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.3,
                                                            child: Text(
                                                                "${EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[2]} ${EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "01" ? "Jan ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "02" ? "Feb ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "03" ? "Mar ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "04" ? "Apr ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "05" ? "May ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "06" ? "Jun ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "07" ? "Jul ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "08" ? "Aug ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "09" ? "Sep ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "10" ? "Oct ," : EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[1] == "11" ? "Nov ," : "Dec ,"} ${EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0].split("-")[0]}",
                                                                textAlign: TextAlign.end,
                                                                style: Utils.fonts(
                                                                  fontWeight: FontWeight.w500,
                                                                  size: 14.0,
                                                                )),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.3,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text("${EventsRightsController.getEventsRightsListItems[index].rightsRatio}",
                                                                    style: Utils.fonts(
                                                                      fontWeight: FontWeight.w500,
                                                                      size: 14.0,
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 2,
                                                    color: Colors.grey[350],
                                                  ),
                                                ]);
                                              },
                                            ),
                                          ],
                                        )
                              : eventsTab == 4
                                  ? EventsSplitsController.isLoading.value
                                      ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Center(child: CircularProgressIndicator()))
                                      : EventsSplitsController.getEventsSplitsListItems.isEmpty
                                          ? Center(child: Text("No Data available"))
                                          : Column(
                                              children: [
                                                Row(children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                    child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                    child: Text("Ex-Date", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                    child: Text("Splits", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                                                  ),
                                                ]),
                                                Divider(thickness: 1),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: EventsSplitsController.getEventsSplitsListItems.length <= 4 ? EventsSplitsController.getEventsSplitsListItems.length : 4,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Column(children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ScriptInfo(
                                                                      CommonFunction.getScripDataModel(
                                                                          exch: int.parse(EventsSplitsController.getEventsSplitsListItems[index].scCode) >= 500000 ? "B" : "N",
                                                                          exchCode: int.parse(EventsSplitsController.getEventsSplitsListItems[index].scCode.toString())),
                                                                      false)));
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                child: Text(EventsSplitsController.getEventsSplitsListItems[index].coName,
                                                                    style: Utils.fonts(
                                                                      fontWeight: FontWeight.w500,
                                                                      size: 14.0,
                                                                    )),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                child: Text(
                                                                    "${EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[2]} ${EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "01" ? "Jan ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "02" ? "Feb ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "03" ? "Mar ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "04" ? "Apr ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "05" ? "May ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "06" ? "Jun ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "07" ? "Jul ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "08" ? "Aug ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "09" ? "Sep ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "10" ? "Oct ," : EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[1] == "11" ? "Nov ," : "Dec ,"} ${EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0].split("-")[0]}",
                                                                    textAlign: TextAlign.end,
                                                                    style: Utils.fonts(
                                                                      fontWeight: FontWeight.w500,
                                                                      size: 14.0,
                                                                    )),
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width * 0.3,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    Text(" ",
                                                                        style: Utils.fonts(
                                                                          fontWeight: FontWeight.w500,
                                                                          size: 14.0,
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: 2,
                                                        color: Colors.grey[350],
                                                      ),
                                                    ]);
                                                  },
                                                )
                                              ],
                                            )
                                  : Center(child: Text("No Data Available"));
                })
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget topLosers() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    // if (topLosersExpanded == false) {
                    //   topLosersExpanded = true;
                    // } else if (topLosersExpanded == true) {
                    //   topLosersExpanded = false;
                    // }
                    // setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MarketStatsNext(
                                  name: "Top Losers",
                                  currentTabIndex: 1,
                                )));
                  },
                  child: Row(
                    children: [
                      Text(
                        "Top Losers",
                        style: Utils.fonts(
                          size: 17.0,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            HomeWidgets.scrollTop();
                          },
                          child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              topLosersTab = 2;
                              Dataconstants.topLosersController.getTopLosers("nse", "nifty", "day");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "1 Day",
                                    style: Utils.fonts(size: 12.0, color: topLosersTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 3;
                              Dataconstants.topLosersController.getTopLosers("nse", "nifty", "week");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Weekly",
                                    style: Utils.fonts(size: 12.0, color: topLosersTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 1;
                              Dataconstants.topLosersController.getTopLosers("nse", "nifty", "month");
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Monthly",
                                    style: Utils.fonts(size: 12.0, color: topLosersTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              topLosersTab = 4;
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "My Holdings",
                                    style: Utils.fonts(size: 12.0, color: topLosersTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                topLosersTab == 4
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No Data Available",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                            ),
                          ],
                        ),
                      )
                    : Obx(() {
                        return TopLosersController.isLoading.value
                            ? Container(
                                height: MediaQuery.of(context).size.height * 0.45,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              )
                            : TopLosersController.getTopLosersListItems.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: TopLosersController.getTopLosersListItems.length < 4 ? TopLosersController.getTopLosersListItems.length : 4,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ScriptInfo(
                                                            CommonFunction.getScripDataModel(
                                                                exch: int.parse(TopLosersController.getTopLosersListItems[index].scCode) >= 500000 ? "B" : "N",
                                                                exchCode: int.parse(TopLosersController.getTopLosersListItems[index].scCode.toString())),
                                                            false)));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        TopLosersController.getTopLosersListItems[index].symbol,
                                                        style: Utils.fonts(fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 8.0),
                                                            child: RotatedBox(
                                                              quarterTurns: 2,
                                                              child: SvgPicture.asset(
                                                                "assets/appImages/inverted_rectangle.svg",
                                                                color: Utils.lightRedColor,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "${TopLosersController.getTopLosersListItems[index].perchg.toStringAsFixed(2)} %",
                                                            style: Utils.fonts(
                                                              color: Utils.lightRedColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          SizedBox(),
                                                          Text(
                                                            TopLosersController.getTopLosersListItems[index].prevClose.toString(),
                                                            style: Utils.fonts(
                                                              color: Utils.greyColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            )
                                          ],
                                        );
                                      },
                                    ))
                                : Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Data Available",
                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                        ),
                                      ],
                                    ),
                                  );
                      }),
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget mostActive() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      // if (mostActiveExpanded == false) {
                      //   mostActiveExpanded = true;
                      // } else if (mostActiveExpanded == true) {
                      //   mostActiveExpanded = false;
                      // }
                      // setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MarketStatsNext(
                                    name: "Most Active",
                                    currentTabIndex: 2,
                                  )));
                    },
                    child: Row(
                      children: [
                        Text(
                          "Most Active",
                          style: Utils.fonts(
                            size: 17.0,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              HomeWidgets.scrollTop();
                            },
                            child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                mostActiveTab = 1;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Volume",
                                      style: Utils.fonts(size: 12.0, color: mostActiveTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                Dataconstants.mostActiveTurnOverController.getMostTurnOver();
                                mostActiveTab = 2;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Turnover",
                                      style: Utils.fonts(size: 12.0, color: mostActiveTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                Dataconstants.mostActiveFuturesController.getMostFutures();
                                mostActiveTab = 3;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Futures",
                                      style: Utils.fonts(size: 12.0, color: mostActiveTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                Dataconstants.mostActiveCallController.getMostActiveCall();
                                mostActiveTab = 4;
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Calls",
                                      style: Utils.fonts(size: 12.0, color: mostActiveTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                mostActiveTab = 5;
                                Dataconstants.mostActivePutController.getMostActivePut();
                                setState(() {});
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                          color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        top: BorderSide(
                                          color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                          width: 1,
                                        )),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Puts",
                                      style: Utils.fonts(size: 12.0, color: mostActiveTab == 5 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                    mostActiveTab == 2
                        ? Text("Value Traded(Cr)", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))
                        : mostActiveTab == 3 || mostActiveTab == 4 || mostActiveTab == 5
                            ? Text("Traded Qty", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))
                            : Text("Volume", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                    mostActiveTab == 3 || mostActiveTab == 4 || mostActiveTab == 5
                        ? Text("Turnover", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("LTP", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                              Text("%Chg", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                            ],
                          ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  (() {
                    if (mostActiveTab == 1)
                      return MostActiveVolumeController.isLoading.value
                          ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Center(child: CircularProgressIndicator()))
                          : MostActiveVolumeController.getMostActiveVolumeListItems.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: MostActiveVolumeController.getMostActiveVolumeListItems.length >= 4 ? 4 : MostActiveVolumeController.getMostActiveVolumeListItems.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ScriptInfo(
                                                        CommonFunction.getScripDataModel(
                                                            exch: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode) >= 500000 ? "B" : "N",
                                                            exchCode: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode.toString())),
                                                        false)));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    MostActiveVolumeController.getMostActiveVolumeListItems[index].symbol.toString(),
                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                Container(
                                                  child: Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "${(MostActiveVolumeController.getMostActiveVolumeListItems[index].volTraded / 10000000).toStringAsFixed(2)} Cr.",
                                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            MostActiveVolumeController.getMostActiveVolumeListItems[index].closePrice.toString(),
                                                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 8.0),
                                                                child: RotatedBox(
                                                                  quarterTurns: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? 4 : 2,
                                                                  child: SvgPicture.asset(
                                                                    "assets/appImages/inverted_rectangle.svg",
                                                                    color: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                "${MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg.toStringAsFixed(2)} %",
                                                                style: Utils.fonts(
                                                                    size: 14.0,
                                                                    color: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No Data Available",
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                      ),
                                    ],
                                  ),
                                );

                    if (mostActiveTab == 2)
                      return MostActiveTurnOverController.isLoading.value
                          ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Center(child: CircularProgressIndicator()))
                          : MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length >= 4 ? 4 : MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ScriptInfo(
                                                        CommonFunction.getScripDataModel(
                                                            exch: int.parse(MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].scCode) >= 500000 ? "B" : "N",
                                                            exchCode: int.parse(MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].scCode.toString())),
                                                        false)));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].symbol,
                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${(MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].volTraded / 10000000).toStringAsFixed(2)} Cr",
                                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].closePrice.toString(),
                                                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 8.0),
                                                                child: RotatedBox(
                                                                  quarterTurns: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg > 0 ? 4 : 2,
                                                                  child: SvgPicture.asset(
                                                                    "assets/appImages/markets/inverted_rectangle.svg",
                                                                    color: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg > 0
                                                                        ? Utils.lightGreenColor
                                                                        : Utils.lightRedColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg.toStringAsFixed(2),
                                                                style: Utils.fonts(
                                                                    size: 14.0,
                                                                    color: MostActiveTurnOverController.getMostActiveTurnOverDetailsListItems[index].perchg > 0
                                                                        ? Utils.lightRedColor
                                                                        : Utils.lightRedColor,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No Data Available",
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                      ),
                                    ],
                                  ),
                                );

                    if (mostActiveTab == 3)
                      return MostActiveFuturesController.isLoading.value
                          ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Center(child: CircularProgressIndicator()))
                          : MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length >= 4 ? 4 : MostActiveFuturesController.getMostActiveFuturesDetailsListItems.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].symbol.toString() ?? " ",
                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].tradedQty}" ?? " ",
                                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${(MostActiveFuturesController.getMostActiveFuturesDetailsListItems[index].turnOver / 10000000).toStringAsFixed(2)} Cr." ?? " ",
                                                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No Data Available",
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                      ),
                                    ],
                                  ),
                                );

                    if (mostActiveTab == 4)
                      return MostActiveCallController.isLoading.value
                          ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Center(child: CircularProgressIndicator()))
                          : MostActiveCallController.getMostActiveCallDetailsListItems.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: MostActiveCallController.getMostActiveCallDetailsListItems.length >= 4 ? 4 : MostActiveCallController.getMostActiveCallDetailsListItems.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        MostActiveCallController.getMostActiveCallDetailsListItems[index].symbol.name,
                                                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                                                      ),
                                                      Text(
                                                        MostActiveCallController.getMostActiveCallDetailsListItems[index].strikePrice,
                                                        style: Utils.fonts(
                                                          size: 12.0,
                                                          color: Utils.greyColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${(double.parse(MostActiveCallController.getMostActiveCallDetailsListItems[index].tradedQty)).toString()}",
                                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${(double.parse(MostActiveCallController.getMostActiveCallDetailsListItems[index].turnOver) / 10000000).toStringAsFixed(2)} Cr",
                                                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No Data Available",
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                      ),
                                    ],
                                  ),
                                );

                    if (mostActiveTab == 5)
                      return MostActivePutController.isLoading.value
                          ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Center(child: CircularProgressIndicator()))
                          : MostActivePutController.getMostActivePutDetailsListItems.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: MostActivePutController.getMostActivePutDetailsListItems.length >= 4 ? 4 : MostActivePutController.getMostActivePutDetailsListItems.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        MostActivePutController.getMostActivePutDetailsListItems[index].symbol.name ?? null,
                                                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                      ),
                                                      Text(
                                                        MostActivePutController.getMostActivePutDetailsListItems[index].strikePrice ?? null,
                                                        style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${double.parse(MostActivePutController.getMostActivePutDetailsListItems[index].tradedQty)}",
                                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${(double.parse(MostActivePutController.getMostActivePutDetailsListItems[index].turnOver) / 10000000).toStringAsFixed(2)} Cr",
                                                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No Data Available",
                                        style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                      ),
                                    ],
                                  ),
                                );
                  }())
                ],
              ),
            ),
            Container(
              height: 4.0,
              width: MediaQuery.of(context).size.width,
              color: Utils.greyColor.withOpacity(0.2),
            ),
          ],
        );
      });
    });
  }

  static Widget ipo() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "IPO",
                      style: Utils.fonts(
                        size: 17.0,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          HomeWidgets.scrollTop();
                        },
                        child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              ipoTab = 1;
                              Dataconstants.openIpoController.getOpenIpo();
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: ipoTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: ipoTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: ipoTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: ipoTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Open now",
                                    style: Utils.fonts(size: 12.0, color: ipoTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              ipoTab = 2;
                              Dataconstants.upcomingIpoController.getUpcomingIpo();
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: ipoTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: ipoTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: ipoTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: ipoTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Upcoming",
                                    style: Utils.fonts(size: 12.0, color: ipoTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              ipoTab = 3;
                              Dataconstants.recentListingController.getIpoRecentListing();
                              setState(() {});
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                        color: ipoTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: ipoTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: ipoTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      ),
                                      right: BorderSide(
                                        color: ipoTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                        width: 1,
                                      )),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Recent Listing",
                                    style: Utils.fonts(size: 12.0, color: ipoTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // (OpenIpoController.getIpoDetailListItems.isEmpty || UpcomingIpoController.getUpcomingIpoListItems.isEmpty || RecentListingController.getRecentListingDetailListItems.isEmpty)
                //     ? Center(
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text(
                //               "No Data Available",
                //               style: TextStyle(
                //                 fontSize: 16.0,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     : Column(children: [
                //         if (ipoTab == 1)
                //           Column(
                //             children: [
                //               for (var i = 0; i < OpenIpoController.getIpoDetailListItems.length; i++)
                //                 Column(
                //                   children: [
                //                     Padding(
                //                       padding: const EdgeInsets.symmetric(vertical: 20.0),
                //                       child: Row(
                //                         children: [
                //                           Expanded(
                //                             child: Text(
                //                               OpenIpoController.getIpoDetailListItems[i].lname,
                //                               style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                //                             ),
                //                           ),
                //                           Expanded(
                //                             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //                               Text(
                //                                 OpenIpoController.getIpoDetailListItems[i].multiples.toStringAsFixed(2),
                //                                 style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                //                               ),
                //                             ]),
                //                           ),
                //                           Expanded(
                //                             child: Row(
                //                               mainAxisAlignment: MainAxisAlignment.end,
                //                               children: [
                //                                 ipoTab == 3
                //                                     ? Column(children: [
                //                                         Text(OpenIpoController.getIpoDetailListItems[i].issueprice.toStringAsFixed(2).toString()),
                //                                         SizedBox(
                //                                           height: 10,
                //                                         ),
                //                                         Text(OpenIpoController.getIpoDetailListItems[i].issuepri2.toStringAsFixed(2).toString())
                //                                       ])
                //                                     : Text(
                //                                         OpenIpoController.getIpoDetailListItems[i].issueprice.toStringAsFixed(2),
                //                                         style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                //                                       ),
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //             ],
                //           ),
                //         if (ipoTab == 2)
                //           Column(
                //             children: [
                //               for (var i = 0; i < 1; i++)
                //                 Column(
                //                   children: [
                //                     Padding(
                //                       padding: const EdgeInsets.symmetric(vertical: 20.0),
                //                       child: Row(
                //                         children: [
                //                           Expanded(
                //                             child: Text(
                //                               UpcomingIpoController.getUpcomingIpoListItems[i].lname,
                //                               style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                //                             ),
                //                           ),
                //                           Expanded(
                //                             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //                               Text(
                //                                 OpenIpoController.getIpoDetailListItems[i].multiples.toStringAsFixed(2),
                //                                 style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                //                               ),
                //                             ]),
                //                           ),
                //                           Expanded(
                //                             child: Row(
                //                               mainAxisAlignment: MainAxisAlignment.end,
                //                               children: [
                //                                 ipoTab == 3
                //                                     ? Column(children: [
                //                                         Text(UpcomingIpoController.getUpcomingIpoListItems[i].issueprice.toStringAsFixed(2).toString()),
                //                                         SizedBox(
                //                                           height: 10,
                //                                         ),
                //                                         Text(UpcomingIpoController.getUpcomingIpoListItems[i].issuepri2.toStringAsFixed(2).toString())
                //                                       ])
                //                                     : Text(
                //                                         UpcomingIpoController.getUpcomingIpoListItems[i].issueprice.toStringAsFixed(2),
                //                                         style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                //                                       ),
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //             ],
                //           ),
                //         if (ipoTab == 3)
                //           Column(
                //             children: [
                //               for (var i = 0; i < 1; i++)
                //                 Column(
                //                   children: [
                //                     Padding(
                //                       padding: const EdgeInsets.symmetric(vertical: 20.0),
                //                       child: Row(
                //                         children: [
                //                           Expanded(
                //                             child: Text(
                //                               RecentListingController.getRecentListingDetailListItems[i].coName,
                //                               style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                //                             ),
                //                           ),
                //                           Expanded(
                //                             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //                               Icon(
                //                                 Icons.arrow_drop_up_rounded,
                //                                 color: Utils.lightGreenColor,
                //                               ),
                //                               Text(
                //                                 OpenIpoController.getIpoDetailListItems[i].listprice.toStringAsFixed(2),
                //                                 style: Utils.fonts(size: 14.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                //                               ),
                //                             ]),
                //                           ),
                //                           Expanded(
                //                             child: Row(
                //                               mainAxisAlignment: MainAxisAlignment.end,
                //                               children: [
                //                                 ipoTab == 3
                //                                     ? Row(
                //                                         children: [
                //                                           Text("${UpcomingIpoController.getUpcomingIpoListItems[i].issueprice.toStringAsFixed(2).toString()} - "),
                //                                           SizedBox(
                //                                             height: 10,
                //                                           ),
                //                                           Text(UpcomingIpoController.getUpcomingIpoListItems[i].issuepri2.toStringAsFixed(2).toString()),
                //                                         ],
                //                                       )
                //                                     : Text(
                //                                         UpcomingIpoController.getUpcomingIpoListItems[i].issueprice.toStringAsFixed(2),
                //                                         style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                //                                       ),
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //             ],
                //           ),
                //       ])

                ipoTab == 1
                    ? Obx(() {
                        return OpenIpoController.isLoading.value
                            ? Align(
                                alignment: Alignment.center,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : OpenIpoController.getIpoDetailListItems.length > 0
                                ? Column(
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Text("Symbol", style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          child: Text("Post Listing", textAlign: TextAlign.center, style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          child: Text("LTP", textAlign: TextAlign.end, style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                                        ),
                                      ]),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: topGainersExpanded
                                                ? OpenIpoController.getIpoDetailListItems.length
                                                : OpenIpoController.getIpoDetailListItems.length < 4
                                                    ? OpenIpoController.getIpoDetailListItems.length
                                                    : 4,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            OpenIpoController.getIpoDetailListItems[index].lname,
                                                            style: Utils.fonts(),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            OpenIpoController.getIpoDetailListItems[index].issueSize,
                                                            style: Utils.fonts(
                                                              color: Utils.greyColor,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    OpenIpoController.getIpoDetailListItems[index].issueprice.toString(),
                                                                    style: Utils.fonts(
                                                                      color: Utils.mediumGreenColor,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    OpenIpoController.getIpoDetailListItems[index].issuepri2.toString(),
                                                                    style: Utils.fonts(
                                                                      color: Utils.mediumGreenColor,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                  )
                                                ],
                                              );
                                            },
                                          )),
                                    ],
                                  )
                                : Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          "No Data Available",
                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                        ),
                                      ],
                                    ),
                                  );
                      })
                    : ipoTab == 2
                        ? Obx(() {
                            return UpcomingIpoController.isLoading.value
                                ? Align(
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : UpcomingIpoController.getUpcomingIpoListItems.length > 0
                                    ? Column(
                                        children: [
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              child: Text("Symbol", style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.3,
                                              child: Text("Post Listing", textAlign: TextAlign.center, style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              child: Text("LTP", textAlign: TextAlign.end, style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                                            ),
                                          ]),
                                          Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: topGainersExpanded
                                                    ? UpcomingIpoController.getUpcomingIpoListItems.length
                                                    : UpcomingIpoController.getUpcomingIpoListItems.length < 4
                                                        ? UpcomingIpoController.getUpcomingIpoListItems.length
                                                        : 4,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                UpcomingIpoController.getUpcomingIpoListItems[index].lname,
                                                                style: Utils.fonts(),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                UpcomingIpoController.getUpcomingIpoListItems[index].issueSize,
                                                                style: Utils.fonts(
                                                                  color: Utils.greyColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(),
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        UpcomingIpoController.getUpcomingIpoListItems[index].issueprice.toString(),
                                                                        style: Utils.fonts(
                                                                          color: Utils.mediumGreenColor,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        UpcomingIpoController.getUpcomingIpoListItems[index].issuepri2.toString(),
                                                                        style: Utils.fonts(
                                                                          color: Utils.mediumGreenColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: 1,
                                                      )
                                                    ],
                                                  );
                                                },
                                              )),
                                        ],
                                      )
                                    : Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "No Data Available",
                                              style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                            ),
                                          ],
                                        ),
                                      );
                          })
                        : ipoTab == 3
                            ? Obx(() {
                                return RecentListingController.isLoading.value
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : RecentListingController.getRecentListingDetailListItems.length > 0
                                        ? Column(
                                            children: [
                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                  child: Text("Symbol", style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.3,
                                                  child: Text("Post Listing", textAlign: TextAlign.center, style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  child: Text("LTP", textAlign: TextAlign.end, style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                                                ),
                                              ]),
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: ipoExpanded
                                                        ? RecentListingController.getRecentListingDetailListItems.length
                                                        : RecentListingController.getRecentListingDetailListItems.length < 4
                                                            ? RecentListingController.getRecentListingDetailListItems.length
                                                            : 4,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                                  child: Text(
                                                                    RecentListingController.getRecentListingDetailListItems[index].lname,
                                                                    style: Utils.fonts(),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width * 0.3,
                                                                  child: Text(
                                                                    RecentListingController.getRecentListingDetailListItems[index].issueSize,
                                                                    textAlign: TextAlign.center,
                                                                    style: Utils.fonts(
                                                                      color: Utils.greyColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      SizedBox(),
                                                                      Column(
                                                                        children: [
                                                                          Text(
                                                                            RecentListingController.getRecentListingDetailListItems[index].perChange.toStringAsFixed(2),
                                                                            style: Utils.fonts(
                                                                              color: RecentListingController.getRecentListingDetailListItems[index].perChange > 0
                                                                                  ? Utils.mediumGreenColor
                                                                                  : Utils.lightRedColor,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                            thickness: 1,
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  )),
                                            ],
                                          )
                                        : Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "No Data Available",
                                                  style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                                ),
                                              ],
                                            ),
                                          );
                              })
                            : SizedBox.shrink()
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget news(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage()));
                },
                child: Row(
                  children: [
                    Text(
                      "News",
                      style: Utils.fonts(
                        size: 17.0,
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage()));
                          },
                          child: SvgPicture.asset("assets/appImages/arrow_right_circle.svg")),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: Observer(builder: (context) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: Dataconstants.todayNews.filteredNews.length,
                    itemBuilder: (context, index) => InkWell(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (Dataconstants.todayNews.filteredNews[index].staticModel != null)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Dataconstants.todayNews.filteredNews[index].staticModel.name,
                                      style: Utils.fonts(
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                if (Dataconstants.todayNews.filteredNews[index].staticModel != null)
                                  SizedBox(
                                    height: 10,
                                  ),
                                Text(
                                  Dataconstants.todayNews.filteredNews[index].description,
                                  style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      color: categoryColor(Dataconstants.todayNews.filteredNews[index].category).withOpacity(0.2),
                                      child: Text(
                                        Dataconstants.todayNews.filteredNews[index].category,
                                        style: Utils.fonts(size: 14.0, color: categoryColor(Dataconstants.todayNews.filteredNews[index].category)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          Dataconstants.todayNews.filteredNews[index].newsTime,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                      onTap: Dataconstants.todayNews.filteredNews[index].staticModel == null
                          ? null
                          : () {
                              ScripInfoModel tempModel = CommonFunction.getScripDataModel(
                                  exch: Dataconstants.todayNews.filteredNews[index].staticModel.exch, exchCode: Dataconstants.todayNews.filteredNews[index].staticModel.exchCode, getNseBseMap: true);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ScriptInfo(
                                    tempModel,
                                    false,
                                  ),
                                ),
                              );
                            },
                    ),
                  );
                }),
              ),
              // for (var i = 0; i < 4; i++)
              //   Column(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 10.0),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             SvgPicture.asset("assets/appImages/dashboard/Ellipse 503.svg"),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Text(
              //                     "Adani Green Energy net profit rises 14% to Rs 49 cr ",
              //                     style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
              //                   ),
              //                   SizedBox(
              //                     height: 10,
              //                   ),
              //                   Row(
              //                     children: [
              //                       Text(
              //                         "Moneycontrol",
              //                         style: Utils.fonts(size: 12.0, color: Utils.primaryColor, fontWeight: FontWeight.w500),
              //                       ),
              //                       Spacer(),
              //                       Text(
              //                         "2 Hours Ago",
              //                         style: Utils.fonts(size: 12.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
              //                       )
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Divider(
              //         thickness: 2,
              //       )
              //     ],
              //   )
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }

  static Widget globalIndices() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Obx(() {
        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                globalIndicesExpanded = !globalIndicesExpanded;
                setState(() {});
              },
              child: Row(
                children: [
                  Text(
                    "Global Indices",
                    style: Utils.fonts(
                      size: 17.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        HomeWidgets.scrollTop();
                      },
                      child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                ],
              ),
            ),
          ),
          if (WorldIndicesController.isLoading.value)
            Center(
              child: CircularProgressIndicator(),
            )
          else
            WorldIndicesController.getWorldIndicesListItems.length <= 0
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Data available",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          children: [
                            globalIndicesExpanded
                                ? Column(
                                    children: [
                                      for (var i = 0; i < WorldIndicesController.getWorldIndicesListItems.length; i++)
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      WorldIndicesController.getWorldIndicesListItems[i].indexname,
                                                      style: Utils.fonts(
                                                        size: 14.0,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  WorldIndicesController.getWorldIndicesListItems[i].prevClose.toStringAsFixed(2),
                                                  style: Utils.fonts(
                                                    size: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  WorldIndicesController.getWorldIndicesListItems[i].date.toString().split(" ")[0],
                                                  style: Utils.fonts(
                                                    size: 12.0,
                                                    color: Utils.greyColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      WorldIndicesController.getWorldIndicesListItems[i].chg.toStringAsFixed(2),
                                                      style: Utils.fonts(
                                                        size: 12.0,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      '(${WorldIndicesController.getWorldIndicesListItems[i].pChg}%)',
                                                      style: Utils.fonts(
                                                        size: 12.0,
                                                        color: WorldIndicesController.getWorldIndicesListItems[i].pChg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: WorldIndicesController.getWorldIndicesListItems[i].pChg > 0
                                                          ? SvgPicture.asset("assets/appImages/markets/inverted_rectangle.svg")
                                                          : RotatedBox(
                                                              quarterTurns: 2,
                                                              child: SvgPicture.asset(
                                                                "assets/appImages/markets/inverted_rectangle.svg",
                                                                color: Utils.lightRedColor,
                                                              ),
                                                            ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(
                                              thickness: 2,
                                            )
                                          ],
                                        ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      for (var i = 0; i < 4; i++)
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      WorldIndicesController.getWorldIndicesListItems[i].indexname,
                                                      style: Utils.fonts(
                                                        size: 14.0,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  WorldIndicesController.getWorldIndicesListItems[i].prevClose.toStringAsFixed(2),
                                                  style: Utils.fonts(
                                                    size: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  WorldIndicesController.getWorldIndicesListItems[i].date.toString().split(" ")[0],
                                                  style: Utils.fonts(
                                                    size: 12.0,
                                                    color: Utils.greyColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      WorldIndicesController.getWorldIndicesListItems[i].chg.toStringAsFixed(2),
                                                      style: Utils.fonts(
                                                        size: 12.0,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      '(${WorldIndicesController.getWorldIndicesListItems[i].pChg}%)',
                                                      style: Utils.fonts(
                                                        size: 12.0,
                                                        color: WorldIndicesController.getWorldIndicesListItems[i].pChg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: WorldIndicesController.getWorldIndicesListItems[i].pChg > 0
                                                          ? SvgPicture.asset("assets/appImages/markets/inverted_rectangle.svg")
                                                          : RotatedBox(
                                                              quarterTurns: 2,
                                                              child: SvgPicture.asset(
                                                                "assets/appImages/markets/inverted_rectangle.svg",
                                                                color: Utils.lightRedColor,
                                                              ),
                                                            ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(
                                              thickness: 2,
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        height: 4.0,
                        width: MediaQuery.of(context).size.width,
                        color: Utils.greyColor.withOpacity(0.2),
                      ),
                    ],
                  )
        ]);
      });

      // return SfMaps(
      //   layers: [
      //     MapShapeLayer(
      //       delegate: const MapShapeLayerDelegate(
      //         shapeFile: 'assets/australia.json',
      //         shapeDataField: 'STATE_NAME',
      //       ),
      //     ),
      //   ],
      // );
    });
  }

  static Widget circuitBreakers(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CircuitBreakersPage()));
                  },
                  child: Row(
                    children: [
                      Text(
                        "Circuit Breakers",
                        style: Utils.fonts(
                          size: 17.0,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            HomeWidgets.scrollTop();
                          },
                          child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          circuitBreakersTab = 1;
                        });
                        Dataconstants.circuitBreakersController.getCircuitBreakers();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                  color: circuitBreakersTab == 1 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                top: BorderSide(
                                  color: circuitBreakersTab == 1 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: circuitBreakersTab == 1 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: circuitBreakersTab == 1 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                )),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Upper Circuit",
                              style: Utils.fonts(size: 12.0, color: circuitBreakersTab == 1 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5), fontWeight: FontWeight.w500),
                            ),
                          )),
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            circuitBreakersTab = 2;
                          });
                          Dataconstants.circuitBreakersController.getCircuitBreakers();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: circuitBreakersTab == 2 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: circuitBreakersTab == 2 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: circuitBreakersTab == 2 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: circuitBreakersTab == 2 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Lower Circuit",
                                style: Utils.fonts(size: 12.0, color: circuitBreakersTab == 2 ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5), fontWeight: FontWeight.w500),
                              ),
                            )))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                circuitBreakersTab == 1
                    ? Obx(() {
                        return CircuitBreakersController.isLoading.value
                            ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Align(alignment: Alignment.center, child: Center(child: CircularProgressIndicator())))
                            : CircuitBreakersController.getUpperCktListItems.length > 0
                                ? Column(children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 4,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    CommonFunction.getScripDataModel(
                                                      exchCode: CircuitBreakersController.getUpperCktListItems[index],
                                                      exch: "N",
                                                    ).name,
                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    CommonFunction.getScripDataModel(
                                                      exchCode: CircuitBreakersController.getUpperCktListItems[index],
                                                      exch: "N",
                                                    ).percentChange.toStringAsFixed(2),
                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    CommonFunction.getScripDataModel(
                                                      exchCode: CircuitBreakersController.getUpperCktListItems[index],
                                                      exch: "N",
                                                    ).close.toStringAsFixed(2),
                                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ])
                                : Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Data Available",
                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                        ),
                                      ],
                                    ),
                                  );
                      })
                    : Obx(() {
                        return CircuitBreakersController.isLoading.value
                            ? Container(height: MediaQuery.of(context).size.height * 0.45, child: Align(alignment: Alignment.center, child: Center(child: CircularProgressIndicator())))
                            : CircuitBreakersController.getLowerCktListItems.length > 0
                                ? Column(children: [
                                    Row(
                                      children: [
                                        Text(
                                          "SYMBOL",
                                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    for (var i = 0; i < 4; i++)
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  CommonFunction.getScripDataModel(
                                                    exchCode: CircuitBreakersController.getUpperCktListItems[i],
                                                    exch: "N",
                                                  ).name,
                                                  style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            thickness: 1,
                                          )
                                        ],
                                      )
                                  ])
                                : Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Data Available",
                                          style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                                        ),
                                      ],
                                    ),
                                  );
                      })
                // Obx(() {
                //   return CircuitBreakersController.
                // })
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget optionChain() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OptionsPage(optionChainVar == 1 ? false : true)));
                  },
                  child: Row(
                    children: [
                      Text(
                        "Option Chain",
                        style: Utils.fonts(
                          size: 17.0,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      SvgPicture.asset("assets/appImages/markets/up_arrow.svg")
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          optionChainVar == 1 ? optionChainVar = 2 : optionChainVar = 1;
                          optionDates = Dataconstants.exchData[1].getDatesForOptions(Dataconstants.indicesListener.indices1);
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                  color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor,
                                  width: 1,
                                ),
                                top: BorderSide(
                                  color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor,
                                  width: 1,
                                )),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "NIFTY",
                              style: Utils.fonts(size: 12.0, color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          optionChainVar == 1 ? optionChainVar = 2 : optionChainVar = 1;
                          optionDates = Dataconstants.exchData[1].getDatesForOptions(Dataconstants.indicesListener.indices3);
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                  color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor,
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor,
                                  width: 1,
                                )),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "BANKNIFTY",
                              style: Utils.fonts(size: 12.0, color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                            ),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
          Observer(builder: (_) {
            if (Dataconstants.indicesListener == null)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              if (optionDates.length == 0) optionDates = Dataconstants.exchData[1].getDatesForOptions(Dataconstants.indicesListener.indices1);
              return Column(
                children: [
                  if (optionChainVar == 1)
                    Container(
                        height: MediaQuery.of(context).size.width, width: MediaQuery.of(context).size.width, child: ScripdetailOptionChain(Dataconstants.indicesListener.indices1, optionDates, 0, "0"))
                  else
                    SizedBox.shrink(),
                  if (optionChainVar == 2)
                    Container(
                        height: MediaQuery.of(context).size.width, width: MediaQuery.of(context).size.width, child: ScripdetailOptionChain(Dataconstants.indicesListener.indices3, optionDates, 0, "0"))
                  else
                    SizedBox.shrink()
                ],
              );
            }
          }),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget openInterest(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OptionsPage(nifty ? false : true)));
                  },
                  child: Row(
                    children: [
                      Text(
                        "Open Interest Analysis",
                        style: Utils.fonts(
                          size: 17.0,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            HomeWidgets.scrollTop();
                          },
                          child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (nifty == true) {
                            nifty = false;
                          } else {
                            nifty = true;
                          }
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                  color: nifty ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                top: BorderSide(
                                  color: nifty ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: nifty ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: nifty ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                )),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "NIFTY",
                              style: Utils.fonts(size: 12.0, color: nifty ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5), fontWeight: FontWeight.w500),
                            ),
                          )),
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            if (nifty == false) {
                              nifty = true;
                            } else {
                              nifty = false;
                            }
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: nifty == false ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: nifty == false ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: nifty == false ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: nifty == false ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "BANKNIFTY",
                                style: Utils.fonts(size: 12.0, color: nifty == false ? Utils.primaryColor : Utils.greyColor.withOpacity(0.5), fontWeight: FontWeight.w500),
                              ),
                            )))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Utils.primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Long Buildup ",
                            style: Utils.fonts(size: 12.0, color: Utils.mediumGreenColor),
                          ),
                          TextSpan(
                            text: "is seen in March expiry with OI addition of 65 lakh.",
                            style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return nifty
                      ? TopHighestOIController.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : TopHighestOIController.topHighestOiListItemsNifty.isEmpty
                              ? Center(child: Text("No Data Available"))
                              : Container(
                                  color: Utils.primaryColor.withOpacity(0.1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        for (var i = 0; i < TopHighestOIController.topHighestOiListItemsNifty.length; i++)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].updTime.toString().split("-")[1] == "01")
                                                      Text(
                                                        "Jan",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "02")
                                                      Text(
                                                        "Feb",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "03")
                                                      Text(
                                                        "Mar",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "04")
                                                      Text(
                                                        "Apr",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "05")
                                                      Text(
                                                        "May",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "06")
                                                      Text(
                                                        "Jun",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "07")
                                                      Text(
                                                        "July",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "08")
                                                      Text(
                                                        "Aug",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "09")
                                                      Text(
                                                        "Sep",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "10")
                                                      Text(
                                                        "Oct",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "11")
                                                      Text(
                                                        "Nov",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsNifty[i].expDate.toString().split("-")[1] == "12")
                                                      Text(
                                                        "Dec",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    Spacer(),
                                                    Text(
                                                      TopHighestOIController.topHighestOiListItemsNifty[i].openInterest.toStringAsFixed(2),
                                                      style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      " (${TopHighestOIController.topHighestOiListItemsNifty[i].chgOpenInt.toStringAsFixed(2)})",
                                                      style: Utils.fonts(size: 13.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 15,
                                                        width: 100,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: LinearProgressIndicator(
                                                            backgroundColor: Utils.greyColor.withOpacity(0.5),
                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                              Utils.primaryColor,
                                                            ),
                                                            value:
                                                                (TopHighestOIController.topHighestOiListItemsNifty[i].openInterest.toDouble() / TopHighestOIController.addedValueNifty.toDouble() * 100)
                                                                        .toDouble() *
                                                                    0.01,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      "${(TopHighestOIController.topHighestOiListItemsNifty[i].openInterest.toDouble() / TopHighestOIController.addedValueBankNifty.toDouble() * 100).toStringAsFixed(2)}%",
                                                      style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                )
                      : TopHighestOIController.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : TopHighestOIController.topHighestOiListItemsBankNifty.isEmpty
                              ? Center(child: Text("No Data Available"))
                              : Container(
                                  color: Utils.primaryColor.withOpacity(0.1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        for (var i = 0; i < TopHighestOIController.topHighestOiListItemsBankNifty.length; i++)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].updTime.toString().split("-")[1] == "01")
                                                      Text(
                                                        "Jan",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "02")
                                                      Text(
                                                        "Feb",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "03")
                                                      Text(
                                                        "Mar",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "04")
                                                      Text(
                                                        "Apr",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "05")
                                                      Text(
                                                        "May",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "06")
                                                      Text(
                                                        "Jun",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "07")
                                                      Text(
                                                        "July",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "08")
                                                      Text(
                                                        "Aug",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "09")
                                                      Text(
                                                        "Sep",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "10")
                                                      Text(
                                                        "Oct",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "11")
                                                      Text(
                                                        "Nov",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    if (TopHighestOIController.topHighestOiListItemsBankNifty[i].expDate.toString().split("-")[1] == "12")
                                                      Text(
                                                        "Dec",
                                                        style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w500),
                                                      ),
                                                    Spacer(),
                                                    Text(
                                                      TopHighestOIController.topHighestOiListItemsBankNifty[i].openInterest.toStringAsFixed(2),
                                                      style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      " (${TopHighestOIController.topHighestOiListItemsBankNifty[i].chgOpenInt.toStringAsFixed(2)})",
                                                      style: Utils.fonts(size: 13.0, color: Utils.lightGreenColor, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 15,
                                                        width: 100,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: LinearProgressIndicator(
                                                            backgroundColor: Utils.greyColor.withOpacity(0.5),
                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                              Utils.primaryColor,
                                                            ),
                                                            value: (TopHighestOIController.topHighestOiListItemsBankNifty[i].openInterest.toDouble() /
                                                                        TopHighestOIController.addedValueBankNifty.toDouble() *
                                                                        100)
                                                                    .toDouble() *
                                                                0.01,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      "${(TopHighestOIController.topHighestOiListItemsBankNifty[i].openInterest.toDouble() / TopHighestOIController.addedValueNifty.toDouble() * 100).toStringAsFixed(2)}%",
                                                      style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                })
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
    });
  }

  static Widget nfo(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "NFO",
                    style: Utils.fonts(
                      size: 17.0,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        HomeWidgets.scrollTop();
                      },
                      child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0)), border: Border.all(color: Utils.greyColor.withOpacity(0.2))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/appImages/dashboard/Frame 11541.svg"),
                          // Image.asset(
                          //   "assets/appImages/dashboard/Frame 11541.png",
                          //   height: 50,
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ICICI Technology Direct Growth",
                                style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "NFO closes today",
                                style: Utils.fonts(size: 12.0, color: Utils.primaryColor, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 2.0,
                        width: MediaQuery.of(context).size.width - 50,
                        color: Utils.greyColor.withOpacity(0.2),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "NFO Price",
                                style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "10",
                                style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Dates",
                                style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "18 May - 20 May 22",
                                style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Mini. Invest",
                                style: Utils.fonts(size: 12.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "5000",
                                style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 70.0),
                            child: Text(
                              "APPLY",
                              style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              )))),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Color(0xffffde67),
                        Color(0xffab3c00),
                      ],
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Backtest Trading Strategies with sTradEasy",
                              style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(2.0))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                child: Text(
                                  "Explore",
                                  style: Utils.fonts(size: 12.0, color: Utils.whiteColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/appImages/dashboard/data-flow-diagram.svg",
                        height: 100,
                        width: 100,
                      ),
                      // Image.asset(
                      //   "assets/appImages/dashboard/data-flow-diagram.png",
                      //   height: 100,
                      //   width: 100,
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }
}

class Conditions {
  String lName;
  bool readDB;
  String category;
  ScannerConditions scannerConditions;
  String scanId;
  bool allowed = true;

  Conditions({this.lName, this.readDB, this.category, this.scannerConditions, this.scanId, this.allowed});
}

enum ScannerConditions {
  RedBody,
  GapDown,
  CLoseBelowPrevDayLow,
  CLoseBelowPrevWeekLow,
  CLoseBelowPrevMonthLow,
  CloseBelow5DayLow,
  PriceTrendRisingLast2Days,
  PriceTrendFallingLast2Days,
  DoubleBottom2DaysReversal,
  PriceDownwardReversal,
  GreenBody,
  GapUp,
  CloseAbovePrevDayHigh,
  CloseAbovePrevWeekHigh,
  CloseAbovePrevMonthHigh,
  CloseAbove5DayHigh,
  Doubletop2DaysReversal,
  PriceUpwardReversal,
  VolumeRaiseAbove50,
  VolumeRaiseAbove100,
  VolumeRaiseAbove200,
  PriceAboveR4,
  PriceAboveR3,
  PriceAboveR2,
  PriceAboveR1,
  PriceAbovePivot,
  PriceBelowPivot,
  PriceBelowS4,
  PriceBelowS3,
  PriceBelowS2,
  PriceBelowS1,
  RSIOverSold30,
  RSIBetween30To50,
  RSIBetween50TO70,
  RSIOverBought70,
  RSIAboveRSIAvg30,
  RSIBelowRSIAvg30,
  PriceGrowth1YearAbove25,
  PriceGrowth3YearBetween25To50,
  PriceGrowth3YearBetween50To100,
  PriceGrowth3YearAbove100,
  PriceAboveSuperTrend1,
  PriceAboveSuperTrend2,
  PriceAboveSuperTrend3,
  PriceBelowSuperTrend1,
  PriceBelowSuperTrend2,
  PriceBelowSuperTrend3,
  PriceBetweenSuperTrend1and2,
  PriceBetweenSuperTrend2and3,
  PriceAboveSMA5,
  PriceAboveSMA20,
  PriceAboveSMA50,
  PriceAboveSMA100,
  PriceAboveSMA200,
  PriceBelowSMA5,
  PriceBelowSMA20,
  PriceBelowSMA50,
  PriceBelowSMA100,
  PriceBelowSMA200,
  openEqualToLow,
  openEqualToHigh
}

enum OIBuiltUpType { DummyFirst, LongBuildUp, ShortCovering, LongUnwind, ShortBuildUp, ShortUnwind, DummyLast }
