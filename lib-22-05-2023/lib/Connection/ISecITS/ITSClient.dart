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
import '../../util/BrokerInfo.dart';
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
          if (responseJson['status'] == false) {
            if (responseJson['emsg'] == 'Session Expired' || responseJson['emsg'] == 'Session Invalid') {
              refreshTokenJWT();
            }
          }
          // Dataconstants.alice.onHttpResponse(response);
        });
    return response.body.toString();
  }

  // Future basketOrderForFno({
  //   requestType,
  //   exchCode,
  //   routeCrt,
  //   symbol,
  //   series,
  //   orderReference,
  //   bool showIndicator = true,
  // }) async {
  //   try {
  //     if (requestType == 'E') Dataconstants.basketModel.updateFetchingRecordsForBasket(true);
  //     if (requestType == 'F') Dataconstants.basketModel.updateFetchingRecordsForContract(true);
  //
  //     var link = url + 'fno/fnobasketorder';
  //     var time = CommonFunction.istTime();
  //     var jsonData = {
  //       "Idirect_Userid": Dataconstants.internalFeUserID,
  //       "SessionToken": Dataconstants.apiSession,
  //       "RQST_TYP": requestType,
  //       "XCHNG_CD": exchCode,
  //       "SOURCE_FLG": 'B',
  //       "SYMBOL": symbol,
  //     };
  //     if (routeCrt != null) {
  //       jsonData['ROUT_CRT'] = routeCrt;
  //     }
  //     if (orderReference != null) {
  //       jsonData['ORDR_RFRNC'] = orderReference;
  //     }
  //     if (series != null) {
  //       jsonData['SERIES'] = series;
  //     }
  //     var jsonMap = json.convert(jsonData);
  //     var checksum = CommonFunction.checksum(time + jsonMap + Dataconstants.secretKey);
  //     var payload = json.convert({'AppKey': Dataconstants.appKey, 'time_stamp': time, 'JSONPostData': jsonMap, 'Checksum': checksum});
  //     var response = await post(
  //       Uri.parse(link),
  //       body: payload,
  //     ).timeout(Duration(seconds: 50));
  //     // var response = await CommonFunction.aliceLogging(
  //     //     link: link, payload: payload, timeoutDuration: timeoutDuration);
  //     log('this is BasketOrderView request => $payload');
  //
  //     var data = jsonDecode(response.body);
  //     List<BasketSuccessForFno> orders = [];
  //     List<InstrumentSuccess> contratOrders = [];
  //     if (requestType == 'G') {
  //       log('this is BasketOrderView response => ${response.body}');
  //       return data;
  //     } else if (requestType == 'E') {
  //       log('this is BasketOrderView response => ${response.body}');
  //       if (data['Status'] != 200) {
  //         Dataconstants.basketModel.addPortfolios([]);
  //         Dataconstants.basketModel.updateFetchingRecordsForBasket(false);
  //         Dataconstants.basketModel.updateFetchingRecordsForContract(false);
  //         checkIfSessionTimedOut(data['Error'], true);
  //         return;
  //       } else {
  //         for (var order in data['Success']) {
  //           var equityOrder = BasketSuccessForFno.fromJson(order);
  //           orders.add(equityOrder);
  //         }
  //         Dataconstants.basketModel.addPortfolios(orders);
  //         if (showIndicator) Dataconstants.basketModel.updateFetchingRecordsForBasket(false);
  //       }
  //     } else if (requestType == 'F') {
  //       log('this is stoBasketOrderView cklist response => ${response.body}');
  //       if (data['Status'] != 200) {
  //         Dataconstants.basketModel.addContractOfBasket([]);
  //         Dataconstants.basketModel.updateFetchingRecordsForContract(false);
  //         // CommonFunction.showBasicToast(data['Error']);
  //       } else {
  //         for (var order in data['Success']) {
  //           var orders = InstrumentSuccess.fromJson(order);
  //           contratOrders.add(orders);
  //         }
  //         Dataconstants.basketModel.addContractOfBasket(contratOrders);
  //         Dataconstants.basketModel.updateFetchingRecordsForContract(false);
  //       }
  //     } else if (requestType == 'P') {
  //       log("Delete entire basket response => $data");
  //       return data;
  //     } else if (requestType == 'N') {
  //       log("modify basket name => $data");
  //       return data;
  //     } else if (requestType == 'Q') {
  //       log("Delete contract response => $data");
  //       return data;
  //     }
  //   } catch (e, s) {
  //     FirebaseCrashlytics.instance.recordError(e, s);
  //     Dataconstants.basketModel.addPortfolios([]);
  //     Dataconstants.basketModel.updateFetchingRecordsForBasket(false);
  //     Dataconstants.basketModel.updateFetchingRecordsForContract(false);
  //   }
  // }

  // #basket order bigul
  createBasket(String basketName) async {
    try {
      var requestJson = {"basketName": basketName};

      print(requestJson);
//https://tradeapiuat.jmfonline.in:9190/api/v2/CreateBasket
      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl + "api/v2/CreateBasket"),
          body: jsonEncode(requestJson), headers: {'Content-type': 'application/json', 'Authorization': "Bearer ${Dataconstants.loginData.data.jwtToken}"});

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("create basket  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  updateBasket(String basketId, String basketName) async {
    try {
      var requestJson = {"basketId": basketId, "basketname": basketName};

      print(requestJson);

      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl + "api/v2/UpdateBasket"),
          body: jsonEncode(requestJson), headers: {'Content-type': 'application/json', 'Authorization': "Bearer ${Dataconstants.loginData.data.jwtToken}"});

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("Update basket  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  deleteBasket(String basketId) async {
    try {
      var requestJson = {"basketId": basketId};
      print(requestJson);
      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl + "api/v2/DeleteBasket"),
          body: jsonEncode(requestJson), headers: {'Content-type': 'application/json', 'Authorization': "Bearer ${Dataconstants.loginData.data.jwtToken}"});

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("delete basket  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  addScripInBasket(
      {String variety,
      String tradingsymbol,
      int symboltoken,
      String transactiontype,
      String exchange,
      String ordertype,
      producttype,
      String duration,
      String price,
      String quantity,
      String triggerprice,
      String scripDescription}) async {
    try {
      var requestJson = {
        "variety": variety, //"AMO",
        "tradingsymbol": tradingsymbol, //"LT-EQ",
        "symboltoken": symboltoken, //"22",
        "transactiontype": transactiontype, //"BUY",
        "exchange": exchange, //"NSE",
        "ordertype": ordertype, // "LIMIT",
        "producttype": producttype, // "CNC",
        "duration": duration, // "DAY",
        "price": price, //"10",
        "quantity": quantity, // "1",
        "disclosedquantity": "0",
        "triggerprice": triggerprice, // "0",
        "orderSource": "WEB",
        "BasketId": Dataconstants.basketID,
        "ScriptDescription": scripDescription,
        // "1"
      };
      print(requestJson);
      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl + "api/v2/AddScriptInBasket"),
          body: jsonEncode(requestJson), headers: {'Content-type': 'application/json', 'Authorization': "Bearer ${Dataconstants.loginData.data.jwtToken}"});
      var responses = response.body.toString();
      log(responses);
      var jsonmap = jsonDecode(response.body);
      print("add scrip to absket  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  getSripFromBasket(String basketId) async {
    try {
      var requestJson = {"basketId": basketId};
      print(requestJson);
      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl + "api/v2/GetScriptsFromBasket"),
          body: jsonEncode(requestJson), headers: {'Content-type': 'application/json', 'Authorization': "Bearer ${Dataconstants.loginData.data.jwtToken}"});

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("delete basket  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  UpdateScriptInBasket(
      {String variety,
      String tradingsymbol,
      String symboltoken,
      String transactiontype,
      String exchange,
      String ordertype,
      producttype,
      String duration,
      String price,
      String quantity,
      String triggerprice,
      String basketId,
      String scriptId,
      String ScriptDescription}) async {
    try {
      var requestJson = {
        "variety": variety,
        "tradingsymbol": tradingsymbol,
        "symboltoken": symboltoken,
        "transactiontype": transactiontype,
        "exchange": exchange,
        "ordertype": ordertype,
        "producttype": producttype,
        "duration": duration,
        "price": price,
        "quantity": quantity,
        "disclosedquantity": triggerprice,
        "triggerprice": "0",
        "orderSource": "WEB",
        "basketId": basketId,
        "scriptId": scriptId,
        "ScriptDescription": ScriptDescription,
      };

      print(requestJson);

      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl + "api/v2/UpdateScriptInBasket"),
          body: jsonEncode(requestJson), headers: {'Content-type': 'application/json', 'Authorization': "Bearer ${Dataconstants.loginData.data.jwtToken}"});

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("Update Scrip in basket $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  deleteScriptFromBasket(String scripID) async {
    try {
      var requestJson = {"scriptID": scripID};
      print(requestJson);
      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl + "api/v2/DeleteScriptFromBasket"),
          body: jsonEncode(requestJson), headers: {'Content-type': 'application/json', 'Authorization': "Bearer ${Dataconstants.loginData.data.jwtToken}"});

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("DeleteScriptFromBasket =  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  // #end basket bigul

  static httpGet(url) async {
    var response;
    await http.get(Uri.parse(url)).timeout(Duration(seconds: 20)).then((responses) {
      response = responses;
      var responseJson = jsonDecode(response.body.toString());
      if (responseJson['status'] == false) {
        if (responseJson['emsg'] == 'Session Expired' || responseJson['emsg'] == 'Session Invalid') {
          refreshTokenJWT();
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
      if (responseJson['status'] == false) {
        if (responseJson['emsg'] == 'Session Expired' || responseJson['emsg'] == 'Session Invalid') {
          refreshTokenJWT();
        }
      }
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
          if (responseJson['status'] == false) {
            if (responseJson['emsg'] == 'Session Expired' || responseJson['emsg'] == 'Session Invalid') {
              refreshTokenJWT();
            }
          }
          // Dataconstants.alice.onHttpResponse(response);
        });
    return response;
  }

  static refreshTokenJWT() async {
    var requestJson = {
      "userId": Dataconstants.feUserID,
      "devId": "123123123",
      "refreshToken": Dataconstants.loginData.data.refreshToken,
      "deviceId": Dataconstants.feUserDeviceID,
      "deviceType": Platform.isAndroid ? "Android" : "IOS",
      "accessToken": Dataconstants.loginData.data.jwtToken
    };

    var jsonresponse = await CommonFunction.refreshToken(requestJson);
    var jsonData = jsonDecode(jsonresponse);
    var jsonjwtToken = jsonData["data"]["jwtToken"];
    Dataconstants.loginData.data.jwtToken = jsonjwtToken;
    print(jsonjwtToken);
  }

  httpPostWithHeaderContentType(url, body) async {
    var response;
    await http
        .post(Uri.parse(url), body: body, headers: {
          'Content-Type': 'application/json',
        })
        .timeout(Duration(seconds: 20))
        .then((responses) {
          response = responses;
          var responseJson = jsonDecode(response.body.toString());
          if (responseJson['status'] == false) {
            if (responseJson['emsg'] == 'Session Expired' || responseJson['emsg'] == 'Session Invalid') {
              refreshTokenJWT();
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
    await http.post(Uri.parse(url), body: newbody, headers: {'Authorization': "Bearer $headers", 'Content-Type': 'application/json'}).timeout(Duration(seconds: 20)).then((responses) {
          response = responses;
          var responseJson = jsonDecode(response.body.toString());
          print(response.body.toString());
          if (responseJson['status'] == false) {
            if (responseJson['emsg'] == 'Session Expired' || responseJson['emsg'] == 'Session Invalid') {
              refreshTokenJWT();
            }
          }
          // Dataconstants.alice.onHttpResponse(response);
        });
    print(response.body.toString());
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
          // 'https://tradeapiaws.jmfonline.in/chart/api/chart/symbol15minchartdata';
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

  // #SIP START
  startSip(
    String exch,
    String exchType,
    int scripCode,
    DateTime startDate,
    var expiryDate,
    String sipPeriod,
    var qty,
    var value,
    String symbol,
  ) async {
    try {
      var requestJson = {
        "Source": "MOB",
        "SessionToken": Dataconstants.loginData.data.jwtToken.toString(),
        "ClientCode": Dataconstants.feUserID,
        "APIVersion": BrokerInfo.algoVersion,
        "Data": {
          "Exch": exch,
          "ExchType": exchType,
          "Symbol": symbol,
          "ScripCode": scripCode,
          "StartDate": startDate.toString(),
          "ExpiryDate": expiryDate.toString(),
          "SIPPeriod": sipPeriod,
          "Qty": qty,
          "Value": value,
          "UpperPriceLimit": 0,
          "LowerPriceLimit": 0
        }
      };
      var s = jsonEncode(requestJson);
      print(requestJson);

      // http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl == BrokerInfo.UATURL ? "https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/create" : "https://tradeapi.jmfonline.in/tools/Instruction/api/sip/create"), body: jsonEncode(requestJson), headers: {
      //   'Content-type': 'application/json',
      // });


      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl == BrokerInfo.UATURL ?"https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/create":"https://tradeapi.jmfonline.in/tools/Instruction/api/sip/create" ) , body: jsonEncode(requestJson), headers: {
        'Content-type': 'application/json',
      });

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("sip Api  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  pauseSip(int instId) async {
    try {
      var requestJson = {"ClientCode": Dataconstants.feUserID, "SessionToken": Dataconstants.loginData.data.jwtToken.toString(), "InstID": instId};

      print(requestJson);

      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl == BrokerInfo.UATURL ? "https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/Pause" : "https://tradeapi.jmfonline.in/tools/Instruction/api/sip/Pause"), body: jsonEncode(requestJson), headers: {
        'Content-type': 'application/json',
      });

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("Pause Api  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  resumeSip(int instId) async {
    try {
      var requestJson = {"ClientCode": Dataconstants.feUserID, "SessionToken": Dataconstants.loginData.data.jwtToken.toString(), "InstID": instId};

      print(requestJson);

      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl == BrokerInfo.UATURL ? "https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/Resume" : "https://tradeapi.jmfonline.in/tools/Instruction/api/sip/Resume"), body: jsonEncode(requestJson), headers: {
        'Content-type': 'application/json',
      });

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("Resume Api  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  stopSip(int instId) async {
    try {
      var requestJson = {"ClientCode": Dataconstants.feUserID, "SessionToken": Dataconstants.loginData.data.jwtToken.toString(), "InstID": instId};

      print(requestJson);

      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl == BrokerInfo.UATURL ? "https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/Stop" : "https://tradeapi.jmfonline.in/tools/Instruction/api/sip/Stop"), body: jsonEncode(requestJson), headers: {
        'Content-type': 'application/json',
      });

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("Stop Api  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  skipNextSip(int instId) async {
    try {
      var requestJson = {"ClientCode": Dataconstants.feUserID, "SessionToken": Dataconstants.loginData.data.jwtToken.toString(), "InstID": instId, "SkipCount": "1"};
      print(requestJson);
      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl == BrokerInfo.UATURL ? "https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/SkipNext" : "https://tradeapi.jmfonline.in/tools/Instruction/api/sip/Stop"), body: jsonEncode(requestJson), headers: {
        'Content-type': 'application/json',
      });
      var responses = response.body.toString();
      log(responses);
      var jsonmap = jsonDecode(response.body);
      print("Skip Next Api  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  modifySip(String exch, String exchType, int scripCode, DateTime startDate, var expiryDate, String sipPeriod, var qty, var value, String symbol, int instIde) async {
    try {
      var requestJson = {
        "ClientCode": Dataconstants.feUserID.toString(),
        "SessionToken": Dataconstants.loginData.data.jwtToken.toString(),
        "InstID": instIde.toString(),
        "ExpiryDate": expiryDate.toString(),
        "SIPPeriod": sipPeriod.toString(),
        "Qty": qty,
        "Value": value,
        "UpperPriceLimit": 0,
        "LowerPriceLimit": 0
      };
      var s = jsonEncode(requestJson);
      print(requestJson);

      http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl == BrokerInfo.UATURL ? "https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/Modify" : "https://tradeapi.jmfonline.in/tools/Instruction/api/sip/Stop"), body: jsonEncode(requestJson), headers: {
        'Content-type': 'application/json',
      });

      var responses = response.body.toString();
      log(responses);

      var jsonmap = jsonDecode(response.body);
      print("modify sip Api  $responses");
      return jsonmap;
    } on TimeoutException catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    } catch (e, s) {
      CommonFunction.firebaseCrash(e, s);
      return false;
    }
  }

  httpPostBigul(url, body) async {
    var response = await http.post(Uri.parse(url), body: jsonEncode(body), headers: {'Content-type': 'application/json'});
    print(response.body.toString());
    return response;
  }

//  #SIP END
}
