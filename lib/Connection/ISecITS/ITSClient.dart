import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:markets/util/loginEncryption.dart';
import 'package:mobx/mobx.dart';
import '../../jmScreens/mainScreen/MainScreen.dart';
import '../../model/indices_listener.dart';
import '../../model/scrip_info_model.dart';
import '../../util/AccountInfo.dart';
import '../../util/DateUtil.dart';
import '../../util/InAppSelections.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:markets/Connection/News/NewsClient.dart';
import 'package:markets/Connection/ResponseListener.dart';
import '../../util/Dataconstants.dart';
import '../../util/CommonFunctions.dart';

enum ReportCalledFrom {
  none,
  orderbook,
  openPosition,
  dematHolding,
  equityPortfolio,
  fnoPortfolio,
  commodityPortfolio,
  currencyPortfolio,
  // openPositionPortfolio,
  // dematHoldingPortfolio,
}

class ITSClient {
  Timer handshakeTimer;
  ResponseListener mResponseListener;

  JsonEncoder json = JsonEncoder();
  bool isLoggedIn = false;
  static const timeoutDuration = const Duration(seconds: 20);

  /* #region Alice */

  static httpGetWithHeader(url, accessToken) async {
    var response;
    await http
        .get(Uri.parse(url), headers: {
          'Authorization': "Bearer $accessToken",
        })
        .timeout(Duration(seconds: 20))
        .then((responses) {
          response = responses;
          var responseJson = jsonDecode(response.body.toString());
          if(responseJson['status'] == false) {
            if(responseJson['emsg'] == 'Session Expired') {

            }
          }
          // Dataconstants.alice.onHttpResponse(response);
        });
    return response.body.toString();
  }

  static httpGet(url) async {
    var response;
    await http.get(Uri.parse(url)).timeout(Duration(seconds: 20)).then((responses) {
      response = responses;
      var responseJson = jsonDecode(response.body.toString());
      if(responseJson['status'] == false) {
        if(responseJson['emsg'] == 'Session Expired') {

        }
      }
      // Dataconstants.alice.onHttpResponse(response);
    });
    return response.body.toString();
  }

  httpPost(url, body) async {
    var response;
    await http.post(Uri.parse(url), body: body).timeout(Duration(seconds: 20)).then((responses) {
      response = responses;
      var responseJson = jsonDecode(response.body.toString());
      if(responseJson['status'] == false) {
        if(responseJson['emsg'] == 'Session Expired') {

        }
      }
      // Dataconstants.alice.onHttpResponse(response);
    });
    return response;
  }

  static httpGetPortfolio(url, accessToken) async {
    var response;
    await http
        .get(Uri.parse(url), headers: {
      'authkey': "cHFyc0BAMTAwOF9wcXJzIyMxMDA4XzEx",
    })
        .timeout(Duration(seconds: 20))
        .then((responses) {
      response = responses;
      // Dataconstants.alice.onHttpResponse(response);
    });
    return response.body.toString();
  }

  static httpGetDpHoldings(url, accessToken) async {
    var response;
    await http
        .get(Uri.parse(url), headers: {
      'authkey': accessToken,
    })
        .timeout(Duration(seconds: 20))
        .then((responses) {
      response = responses;
    });

    return response.body.toString();
  }

  httpPostWithHeader(url, body, headers) async {
    var response;
    await http
        .post(Uri.parse(url), body: body, headers: {
      'Authorization': "Bearer $headers",
    })
        .timeout(Duration(seconds: 20))
        .then((responses) async {
      response = responses;
      //print('${Dataconstants.feUserDeviceID}');
      var responseJson = jsonDecode(response.body.toString());
      if(responseJson['status'] == false) {
        if(responseJson['emsg'] == 'Session Expired') {
          // var requestJson = {
          //   "userId": Dataconstants.feUserID,
          //   "devId": Dataconstants.feUserDeviceID,
          //   "refreshToken": Dataconstants.loginData.data.refreshToken,
          //   "deviceId": Dataconstants.feUserDeviceID,
          //   "deviceType": Platform.isAndroid ? 'Android' : 'iOS',
          //   "accessToken": Dataconstants.loginData.data.jwtToken,
          // };
          // //log("refresh token request --- $requestJson");
          // var response = await CommonFunction.refreshToken(requestJson);
          // //print(response);
        }
      }
      // Dataconstants.alice.onHttpResponse(response);
    });
    return response;
  }

  httpPostWithHeaderContentType(url, body) async {
    var response;
    await http
        .post(Uri.parse(url), body: body,
        headers: {
          'Content-Type': 'application/json',
        }
        )
        .timeout(Duration(seconds: 20))
        .then((responses) {
          response = responses;
          var responseJson = jsonDecode(response.body.toString());
          if(responseJson['status'] == false) {
            if(responseJson['emsg'] == 'Session Expired') {

            }
          }
          // Dataconstants.alice.onHttpResponse(response);
        });
    return response;
  }

  httpPostWithHeaderNew(
    url,
    Map body,
    headers,
  ) async {
    //print(url);
    var newbody = jsonEncode(body);
    //print(newbody);
    var response;
    await http.post(Uri.parse(url), body: newbody, headers: {
      'Authorization': "Bearer $headers",
      'Content-Type': 'application/json'}).timeout(Duration(seconds: 20)).then((responses) {
          response = responses;
          var responseJson = jsonDecode(response.body.toString());
          if(responseJson['status'] == false) {
            if(responseJson['emsg'] == 'Session Expired') {

            }
          }
          // Dataconstants.alice.onHttpResponse(response);
        });
    //print(response.body.toString());
    return response;
  }

  void onLoggedIn({
    int indicator = 0,
    String message = '',
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("showPasswordPopup", true);
    try {
      // DataConstants.iqsClient.createHeaderRecord('DEVESH');
      // // Future.delayed(Duration(seconds: 1), () {
      // DataConstants.iqsClient.connect();
      // });
      isLoggedIn = true;
      /* Commented to resolve lag on validate MPIN screen */
      // if (Dataconstants.indicesListener == null) Dataconstants.indicesListener = IndicesListener();
      // Dataconstants.indicesListener.getIndicesFromPref();
      // Dataconstants.newsClient = NewsClient.getInstance();
      // Dataconstants.newsClient.connect();
      /* end region */
      var params = {
        "Login": "Success",
      };
      CommonFunction.JMFirebaseLogging("Login_Tracking", params);
      if (indicator == 1)
        mResponseListener.onResponseReceieved(message, 3);
      else
        mResponseListener.onResponseReceieved(message, 200);
    } catch (e, s) {
      // CommonFunction.firebaseCrash(e, s);
      mResponseListener.onErrorReceived('Please Try again', -99);
    }
  }



  Future<void> getChartData({int timeInterval = 15, String chartPeriod = 'I', ScripInfoModel model}) async {
    try {
      if (!model.isNewCloseChartDataRequired(timeInterval)) return;
      // //print("chart model exch => ${model.exch}");
      var link =
          // 'http://${Dataconstants.eodIP}:9192/chart/api/chart/symbol15minchartdata';
          'https://${Dataconstants.iqsIP}/chart/api/chart/symbol15minchartdata';
          // 'https://marketstreams.icicidirect.com/chart/api/chart/symbol15minchartdata';
      // //print("small chart link - $link");
      var jsonData = {
        "Exch": model.exch,
        "ScripCode": model.exchCode.toString(),
        // "FromDate": Dataconstants.chartFromDate, // 31 jul 2021 09:15:00
        // "ToDate": Dataconstants.chartToDate, // 31 jul 2021 15:30:00
        "TimeInterval": timeInterval.toString(),
        "ChartPeriod": chartPeriod,
      };

      // //print("jsonData $jsonData");
      // var response = await post(Uri.parse(link),
      //         body: jsonEncode(jsonData),
      //         headers: {'Content-type': 'application/json'})
      //     .timeout(timeoutDuration);
      var response = await CommonFunction.aliceLogging(link: link, headers: {'Content-type': 'application/json'}, payload: jsonEncode(jsonData), timeoutDuration: timeoutDuration);
      // //print(
      //     "chart data name ${model.name} and series ${model.series}-> ${response.body}");
      var data = jsonDecode(response.body);
      model.chartMinClose[timeInterval] = ObservableList();
      model.dataPoint[timeInterval] = ObservableList();
      if (data['c'] != null) {
        if (data['c'].length > 0)
          for (int i = 0; i < data['c'].length; i++) {
            model.chartMinClose[timeInterval].add(data['c'][i]);
            model.dataPoint[timeInterval].add(FlSpot(double.parse(i.toStringAsFixed(2)), double.parse(data['c'][i].toStringAsFixed(2))));
          }
      } else {}
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
    }
  }
}
