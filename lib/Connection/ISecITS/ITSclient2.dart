import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:chaset_converter/charset_converter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:markets/Connection/ResponseListener.dart';
import 'package:markets/model/AlgoModels/ApiResponse.dart';
import 'package:markets/util/Dataconstants.dart';
import '../../util/BrokerInfo.dart';
import 'package:intl/intl.dart';
import '../../util/Dataconstants.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
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

class ITSClient2{
  Timer handshakeTimer;
  ResponseListener mResponseListener;

  // String url = 'https://api.icicidirect.com/';

  String url = '103.174.107.93';

  // String url = 'https://uatapi.icicidirect.com/';

  // String algoUrl = 'https://algo.icicidirect.com'; //LIVE

  String algoUrl = 'https://bigulint.bigul.app/algo'; // UAT
  // String algoUrl = 'http://103.87.41.159'; // UAT

  // String algoUrl = "103.87.41.43"; //  Live
  // String algoUrl = "103.87.41.159";// UAT
  // String algoUrl = "192.168.1.199";// UAT local
  JsonEncoder json = JsonEncoder();
  bool isLoggedIn = false;
  static const timeoutDuration = const Duration(seconds: 20);



  // ----------> fetch algo API <------------
  // Future<Map<String, dynamic>> fetch() async {
  //   try {
  //     var url = "$algoUrl/report/api/algo/List"; //api/algo/List
  //
  //     // var url = "$algoUrl:9193/api/instruction/totalalgo2";
  //
  //     Map data = {
  //       "ClientCode": Dataconstants.internalFeUserID,
  //       "SessionToken": Dataconstants.loginData.data.jwtToken
  //     };
  //     //encode Map to JSON
  //     var body = jsonEncode(data);
  //
  //     // var response = await http
  //     //     .post(Uri.parse(url),
  //     //         headers: {"Content-Type": "application/json"}, body: body)
  //     //     .timeout(timeoutDuration);
  //     var response = await CommonFunction.aliceLogging(
  //         link: url,
  //         payload: body,
  //         headers: {"Content-Type": "application/json"},
  //         timeoutDuration: timeoutDuration);
  //
  //     var data2 = jsonDecode(response.body);
  //
  //     // log('fetch algo API response ${response.body}');
  //     Dataconstants.fetchAlgoModel.fetchAlgoLists.clear();
  //     Dataconstants.fetchAlgoModel.fetchAlgoOrders.clear();
  //     for (int i = 0; i < data2.length; i++) {
  //       Dataconstants.fetchAlgoModel.fetchAlgoList(data2[i]);
  //     }
  //     Dataconstants.fetchAlgoModel.updateFetchingOrders(true);
  //   } catch (e, s) {
  //     FirebaseCrashlytics.instance.recordError(e, s);
  //   }
  // }

  //---------------------> Report Algo <----------------------------
//   Future<Map<String, dynamic>> reportAlgo() async {
//     try {
//       var url = "$algoUrl/report/api/algo/AlgoReport";
//
//       //http://103.87.41.159:9193/api/algo/AlgoReport
//
//       // var url = "$algoUrl:9193/api/instruction/AlgoInstructionReport";
//
//       Map data = {
//         "ClientCode": Dataconstants.feUserID,
//         "SessionToken":Dataconstants.loginData.data.jwtToken,
//         "InstState": 1,
//       };
//       //encode Map to JSON
//       var body = jsonEncode(data);
//       // log('report awaiting algo  API request $body');
//       var response = await http.post(Uri.parse(url),
//           headers: {"Content-Type": "application/json"}, body: body)
//           .timeout(timeoutDuration);
//       // var response = await CommonFunction.aliceLogging(
//       //     link: url,
//       //     payload: body,
//       //     headers: {"Content-Type": "application/json"},
//       //     timeoutDuration: timeoutDuration);
//
//       var data2 = jsonDecode(response.body);
//       // log('report awaiting algo API response $data2');
//       // if(data2.toString().length != 0 && data2.toString() != "[]"){
//       //    Dataconstants.reportAlgoModel.reportAlgoLists.clear();
//       //   for (int i = 0; i < data2.length; i++) {
//       //     Dataconstants.reportAlgoModel.getEquityModel(data2[i]);
//       //   }
//       //
//       // }
//       Dataconstants.reportAlgoModel.updateFetchingAlgoOrders(true);
//       Dataconstants.reportAlgoModel.reportAlgoLists.clear();
//       Dataconstants.reportAlgoModel.awaitAlgoReport.clear();
//       for (int i = 0; i < data2.length; i++) {
//         Dataconstants.reportAlgoModel.getEquityModel(data2[i]);
//       }
//       // for (int i = 0; i < data2.length; i++) {
//       //   Dataconstants.reportAlgoModel.addAwaitAlgoOrders(data2[i]);
//       // }
//       // Dataconstants.reportAlgoModel.updateFetchingAlgoOrders(true);
//     } catch (e, s) {
//       FirebaseCrashlytics.instance.recordError(e, s);
//     }
//   }
//
//   //----------------------------> reportRunning Algo<------------------------------------------
//   Future<Map<String, dynamic>> reportRunningAlgo() async {
//     try {
//       var url = "$algoUrl/report/api/algo/AlgoReport";
// //http://103.87.41.159:9193/api/algo/AlgoReport
//
//       // var url = "$algoUrl:9193/api/instruction/AlgoInstructionReport";
//
//       Map data = {
//         "ClientCode": Dataconstants.feUserID,
//         "SessionToken": Dataconstants.loginData.data.jwtToken,
//         "InstState": 2
//       };
//       //encode Map to JSON
//       var body = jsonEncode(data);
//
//       // //print("report running algo api request => $body");
//       // var response = await http
//       //     .post(Uri.parse(url),
//       //         headers: {"Content-Type": "application/json"}, body: body)
//       //     .timeout(timeoutDuration);
//       var response = await CommonFunction.aliceLogging(
//           link: url,
//           payload: body,
//           headers: {"Content-Type": "application/json"},
//           timeoutDuration: timeoutDuration);
//
//       var data2 = jsonDecode(response.body);
//       // log('report Running algo API response $data2');
//
//       Dataconstants.reportRunningsModel.reportRunningAlgoLists.clear();
//       Dataconstants.reportRunningsModel.runningAlgoOrders.clear();
//       for (int i = 0; i < data2.length; i++) {
//         Dataconstants.reportRunningsModel.getEquityModel(data2[i]);
//       }
//
//       Dataconstants.reportRunningsModel.updateFetchingOrders(true);
//     } catch (e, s) {
//       FirebaseCrashlytics.instance.recordError(e, s);
//     }
//   }

  //------------------------------> reportFinished algo <-----------------------------------
//  Future<Map<String, dynamic>>
  reportFinishedAlgo() async {
    try {
      var url = "${BrokerInfo.algoUrl}/report/api/algo/AlgoReport";
      // var url = "$algoUrl:9193/api/instruction/AlgoInstructionReport";

      Map data = {
        "ClientCode": Dataconstants.feUserID,
        "SessionToken": Dataconstants.loginData.data.jwtToken,
        "InstState": 3
      };
      //encode Map to JSON
      var body = jsonEncode(data);

      print("report finished algo api request => $body");
      var response = await http
          .post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body)
          .timeout(timeoutDuration);
      // var response = await CommonFunction.aliceLogging(
      //     link: url,
      //     payload: body,
      //     headers: {"Content-Type": "application/json"},
      //     timeoutDuration: timeoutDuration);
      var data2 = jsonDecode(response.body);
      return response.body.toString();
      //  log('report finished algo API response $data2');
      //
      // // Dataconstants.reportFinishdModel.reportFinishAlgoLists.clear();
      // // Dataconstants.reportFinishdModel.finishedAlgoOrders.clear();
      // for (int i = 0; i < data2.length; i++) {
      //   Dataconstants.reportFinishdModel.getEquityModel(data2[i]);
      // }
      // Dataconstants.reportFinishdModel.updateFetchingOrders(true);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  //-----------------------> Stop All<-------------------------
  Future<Map<String, dynamic>> stopAllAlgo() async {
    try {
      var url = "${BrokerInfo.algoUrl}/instruction/api/algo/StopAll";

      //http://103.87.41.159:9194/api/algo/StopAll

      // var url = "$algoUrl/instruction/api/instruction/stopall";

      Map data = {
        "ClientCode": Dataconstants.feUserID,
        "SessionToken": Dataconstants.loginData.data.jwtToken,
      };
      //encode Map to JSON
      var body = jsonEncode(data);
      // //print('stop all request $body');

      // var response = await http
      //     .post(Uri.parse(url),
      //         headers: {"Content-Type": "application/json"}, body: body)
      //     .timeout(timeoutDuration);
      var response = await CommonFunction.aliceLogging(
          link: url,
          payload: body,
          headers: {"Content-Type": "application/json"},
          timeoutDuration: timeoutDuration);
      var data2 = jsonDecode(response.body);

      // log('Stop All algo API response $data2');
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  //----------------------> Pause algo <--------------------
  pauseAlgo({
    int instructionId,

    // int algoId,
    // int totalQty,
    // int slicingQty,
    // String buySell,
    // String orderType,
    // int timeInterval,
    // int startTime,
    // int endTime,
    // double limitPrice,
    // double priceRangeLow,
    // double priceRangeHigh,
    // int instructionTime,
    //
    // String avgDirection,
    // double avgLimitPrice,
    // double avgEntryDiff,
    // double avgExitDiff,
  }) async {
    try {
      var url = "${BrokerInfo.algoUrl}/instruction/api/algo/Pause";
      //http://103.87.41.159:9194/api/algo/Pause

      // var url = "$algoUrl/instruction/api/instruction/AlgoPause";

      Map data = {
        "InstID": instructionId,
        "ClientCode": Dataconstants.feUserID,
        "SessionToken": Dataconstants.loginData.data.jwtToken,
        // "UserType": "Client",
        // "InstID": instructionId,
        // "UserName": Dataconstants.internalFeUserID,
        // "SessionToken":Dataconstants.apiSession,
      };
      //encode Map to JSON
      var body = jsonEncode(data);
      // //print("pause algo api request $body");

      // var response = await http
      //     .post(Uri.parse(url),
      //         headers: {"Content-Type": "application/json"}, body: body)
      //     .timeout(timeoutDuration);
      var response = await CommonFunction.aliceLogging(
          link: url,
          payload: body,
          headers: {"Content-Type": "application/json"},
          timeoutDuration: timeoutDuration);
      var data2 = jsonDecode(response.body);

      Dataconstants.pauseAlgoStatus = data2['Status'];
      // log('Pause  algo API response $data2');
      // log('pauseAlgoStatus ${Dataconstants.pauseAlgoStatus}');
      // Dataconstants.reportAlgoModel.reportAlgoLists.clear();
      // for (int i = 0; i < data2.length; i++) {
      //   Dataconstants.reportAlgoModel.getEquityModel(data2[i]);
      // }

    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  //----------------------> Resume algo <--------------------
  restartAlgo({
    int instructionId,
  }) async {
    try {
      var url = "${BrokerInfo.algoUrl}/instruction/api/algo/Resume";
      //http://103.87.41.159:9194/api/algo/Resume

      // var url = "$algoUrl/instruction/api/instruction/AlgoResume";

      Map data = {
        "InstID": instructionId,
        "ClientCode": Dataconstants.feUserID,
        "SessionToken": Dataconstants.loginData.data.jwtToken,
        // "UserType": "Client",
        // "InstID": instructionId,
        // "UserName": Dataconstants.internalFeUserID,
        // "SessionToken":Dataconstants.apiSession,
      };
      //encode Map to JSON
      var body = jsonEncode(data);
      // //print('restart algo request $body');

      // var response = await http
      //     .post(Uri.parse(url),
      //         headers: {"Content-Type": "application/json"}, body: body)
      //     .timeout(timeoutDuration);
      var response = await CommonFunction.aliceLogging(
          link: url,
          payload: body,
          headers: {"Content-Type": "application/json"},
          timeoutDuration: timeoutDuration);
      var data2 = jsonDecode(response.body);
      Dataconstants.resumeAlgoStatus = data2['Status'];
      // log('Restart algo API response $data2');
      // log('resume Algo  ${Dataconstants.resumeAlgoStatus}');

    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  //----------------------> Stop algo <--------------------
  stoptAlgo({
    int instructionId,
  }) async {
    try {
      var url = "${BrokerInfo.algoUrl}/instruction/api/algo/Stop";

      //http://103.87.41.159:9194/api/algo/Stop

      // var url = "$algoUrl/instruction/api/instruction/AlgoStop";

      Map data = {
        "InstID": instructionId,
        "ClientCode": Dataconstants.feUserID,
        "SessionToken": Dataconstants.loginData.data.jwtToken,

        // "UserType": "Client",
        // "InstID": instructionId,
        // "UserName": Dataconstants.internalFeUserID,
        // "SessionToken":Dataconstants.apiSession,
      };
      //encode Map to JSON
      var body = jsonEncode(data);
      // //print('Stop algo request $body');
      // var response = await http
      //     .post(Uri.parse(url),
      //         headers: {"Content-Type": "application/json"}, body: body)
      //     .timeout(timeoutDuration);
      var response = await CommonFunction.aliceLogging(
          link: url,
          payload: body,
          headers: {"Content-Type": "application/json"},
          timeoutDuration: timeoutDuration);

      var data2 = jsonDecode(response.body);

      // log('Stop algo API response $data2');
      // Dataconstants.reportAlgoModel.reportAlgoLists.clear();
      // for (int i = 0; i < data2.length; i++) {
      //   Dataconstants.reportAlgoModel.getEquityModel(data2[i]);
      // }

    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  //-------------------------algo Log -----------------------

  Future<Map<String, dynamic>> algoLog({int instructionId}) async {
    try {
      var url = "${BrokerInfo.algoUrl}/report/api/algo/AlgoLog";

      //9193/api/algo/AlgoLog

      // var url = "$algoUrl:9193/api/instruction/AlgoLog";

      Map data = {
        "ClientCode": Dataconstants.feUserID,
        "SessionToken": Dataconstants.loginData.data.jwtToken,
        "InstID": instructionId
      };
      //encode Map to JSON
      var body = jsonEncode(data);
      // //print('alo Log request $body');

      // var response = await http
      //     .post(Uri.parse(url),
      //         headers: {"Content-Type": "application/json"}, body: body)
      //     .timeout(timeoutDuration);
      var response = await CommonFunction.aliceLogging(
          link: url,
          payload: body,
          headers: {"Content-Type": "application/json"},
          timeoutDuration: timeoutDuration);
      var data2 = jsonDecode(response.body);

      // log('Algo Log API  response $data2');

      // Dataconstants.algoLogModel.getEquityModel(data2);
      // Dataconstants.algoLogModel.algoLogLists.clear();
      //
      // Dataconstants.algoLogModel.updateGetAlgoLogOrders(true);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  ///-----------------------> Create Algo <------------------------------

  Future<ApiResponse> createAlgo({
    int algoId,
    String exchange,
    exchangeType,
    String symbol,
    int scripCode,
    String totalQuantity,
    String slicingQuantity,
    String buySell,
    int timeInterval,
    int startTime,
    int endTime,
    String lowerPrice,
    String uperPrice,
    int instructionTime,
    String AvgLimitPrice,
    String AvgEntryDiff,
    String AvgExitDiff,
    String AvgDirection,
    String limitPrice,
    String historicalSize,
    List<dynamic> dynamicValue,
    String orderType,
    bool atmarket,
  }) async {
    try {
      var url =
          "${BrokerInfo.algoUrl}/instruction/api/algo/create"; // $algoUrl //$algoUrl/instruction //43.242.214.184
      // "$algoUrl/instruction/api/algo/create"; // $algoUrl //$algoUrl/instruction //43.242.214.184

      var test = "";

      switch (algoId) {
        case 1:
          Map jsonData = {
            "Exch": exchange,
            "ExchType": exchangeType,
            "Symbol": symbol,
            "ScripCode": scripCode,
            "TotalQty": totalQuantity,
            "SlicingQty": slicingQuantity,
            "BuySell": buySell,
            "TimeInterval": timeInterval,
            "OrderType": orderType,
          };
          test = jsonEncode(jsonData);
          break;
        case 2:
          Map jsonData = {
            "Exch": exchange,
            "ExchType": exchangeType,
            "Symbol": symbol,
            "ScripCode": scripCode,
            "TotalQty": totalQuantity,
            "SlicingQty": slicingQuantity,
            "BuySell": buySell,
            "TimeInterval": timeInterval,
            "OrderType": orderType,
          };
          for (var i = 0; i < dynamicValue.length; i++) {
            jsonData.addAll(
                {dynamicValue[i][0].toString(): dynamicValue[i][1].toString()});
          }
          test = jsonEncode(jsonData);
          break;
        case 3:
          Map jsonData = {
            "Exch": exchange,
            "ExchType": exchangeType,
            "Symbol": symbol,
            "ScripCode": scripCode,
            "TotalQty": totalQuantity,
            "AveragingQty": slicingQuantity,
            "BuySell": buySell,
            // "TimeInterval": timeInterval,
            "OrderType": orderType,
          };
          // dynamicValue.removeAt(2);
          for (var i = 0; i < dynamicValue.length - 1; i++) {
            jsonData.addAll(
                {dynamicValue[i][0].toString(): dynamicValue[i][1].toString()});
          }
          test = jsonEncode(jsonData);
          break;
        case 4:
          Map jsonData = {
            "Exch": exchange,
            "ExchType": exchangeType,
            "Symbol": symbol,
            "ScripCode": scripCode,
            "TotalQty": totalQuantity,
            "AveragingQty": slicingQuantity,
            "StartWith": buySell,
            "TimeInterval": timeInterval,
            "OrderType": orderType,
          };
          for (var i = 0; i < dynamicValue.length; i++) {
            jsonData.addAll(
                {dynamicValue[i][0].toString(): dynamicValue[i][1].toString()});
          }
          test = jsonEncode(jsonData);
          break;
        case 6:
          Map jsonData = {
            "Exch": exchange,
            "ExchType": exchangeType,
            "Symbol": symbol,
            "ScripCode": scripCode,
            "TotalQty": totalQuantity,
            "AveragingQty": slicingQuantity,
            "BuySell": buySell,
            // "TimeInterval": timeInterval,
            "OrderType": orderType,
          };
          // dynamicValue.removeAt(2);
          for (var i = 0; i < dynamicValue.length - 1; i++) {
            jsonData.addAll(
                {dynamicValue[i][0].toString(): dynamicValue[i][1].toString()});
          }
          test = jsonEncode(jsonData);
          break;

      }

      Map data = {
        "AlgoID": algoId,
        "Source": "MOB",
        "SessionToken": Dataconstants.loginData.data.jwtToken,

        "MatchAccount": "1234567890", //Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].matchAccount,
        "DPID": "",//Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].dpId,
        "DPClientID":"",// Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].dpClientId,
        "PipeID": "",
        // exchange == 'NSE'
        //     ? Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].nsePipeId
        // : Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].bsePipeId,
        "ClientCode": Dataconstants.feUserID,
        "instructionTime": instructionTime,
        "StartTime": startTime,
        "EndTime": endTime,
        "OrderTradeDate": DateFormat('dd-MMM-yyyy').format(DateTime.now()),
        // exchange == 'BSE'
        //     ? Dataconstants.bseTradeDate
        //     : Dataconstants.nseTradeDate,
        "LimitPrice": algoId == 3 ? dynamicValue[2][1] : 0.0,
        // algoId==3? dynamicValue:
        "AlgoParamsJsonData": test,
        "APIVersion":BrokerInfo.algoVersion,

        // "{\"Exch\":\"$exchange\","
        //     "\"ExchType\":\"$exchangeType\","
        //     "\"Symbol\":\"$symbol\","
        //     "\"ScripCode\":$scripCode,"
        //     "\"TotalQty\":$totalQuantity,"
        //     "\"SlicingQty\":$slicingQuantity,"
        //     "\"BuySell\":\"$buySell\","
        //     "\"TimeInterval\":$timeInterval,"
        //     "\"OrderType\":\"$orderType\"}"

        // {
        //   "Exch": exchange,
        // "ExchType": exchangeType,
        // "Symbol": symbol,
        // "ScripCode": scripCode,
        // "TotalQty": totalQuantity,
        // "SlicingQty": slicingQuantity,
        // "BuySell": buySell,
        // "TimeInterval": timeInterval,
        // "OrderType": orderType, //"Delevery",
        //  }

        // "AlgoID": algoId,
        // "InstID": 0,
        // "SessionToken": Dataconstants.apiSession,
        // "MatchAccount": Dataconstants
        //     .accountInfo[Dataconstants.currentSelectedAccount].matchAccount,
        // "DPID": Dataconstants
        //     .accountInfo[Dataconstants.currentSelectedAccount].dpId,
        // "DPClientID": Dataconstants
        //     .accountInfo[Dataconstants.currentSelectedAccount].dpClientId,
        // "PipeID": exchange == 'NSE'
        //     ? Dataconstants
        //         .accountInfo[Dataconstants.currentSelectedAccount].nsePipeId
        //     : Dataconstants
        //         .accountInfo[Dataconstants.currentSelectedAccount].bsePipeId,
        // "OrderTradeDate": exchange == 'BSE'
        //     ? Dataconstants.bseTradeDate
        //     : Dataconstants.nseTradeDate,
        // "Exch": exchange,
        // "ExchType": exchangeType,
        // "Symbol": symbol,
        // "ScripCode": scripCode,
        // "TotalQty": totalQuantity,
        // "SlicingQty": slicingQuantity,
        // "BuySell": buySell,
        // "TimeInterval": timeInterval,
        // "StartTime": startTime,
        // "EndTime": endTime,
        // "InstructionType": 1,

        //--------------------------********************----------------

        // "instructionTime": instructionTime,

        // "AvgLimitPrice":AvgLimitPrice,

        //--------------------------********************----------------

        // "AvgDirection": 'U',
        // "AvgEntryDiff": 1,
        // "AvgExitDiff": 1,
        // "HistSize": 15
      };

      // for (var i = 0; i < dynamicValue.length; i++) {
      //   data.addAll(
      //       {dynamicValue[i][0].toString(): dynamicValue[i][1].toString()});
      // }
      //encode Map to JSON
      var body = jsonEncode(data);
      // log('create algo request lis : $body');
      // //print('limit price : ${dynamicValue[2][1]}');
      // return null;
      var response = await http
          .post(Uri.parse(url),
              headers: {"Content-Type": "application/json"}, body: body)
          .timeout(timeoutDuration);
      // var response = await CommonFunction.aliceLogging(
      //     link: url,
      //     payload: body,
      //     headers: {"Content-Type": "application/json"},111
      //     timeoutDuration: timeoutDuration);
      // var apiResponse = ApiResponse.fromAlgoRawJson(response.body);
      var response2 = jsonDecode(response.body);
      //print('create algo response lis : $response2');

      // //print("create algo response $response2");

      //       var data3 = apiResponse.algoSuccess.instId;
      //       var status =response2["Status"];
      //       var statusCode =response2["StatusCode"];
      //
      //       // var message =status["Message"];
      //
      // Dataconstants.statusCode=statusCode;
      // Dataconstants.status=status;
      // // Dataconstants.message=message;
      //
      //      //print("Status  ${Dataconstants.statusCode}");
      //      //print("Data  $status");
      //      //print("Message  ${Dataconstants.message}");
      //
      //      Dataconstants.instructionIdAlgo = data3;
      //
      //      // log('create algo API response $data3');
      //      log('new instId ${Dataconstants.instructionIdAlgo}');
      //
      //      //print(data);
      // Dataconstants.algoCreateModel.createAlgoLists.clear();
      // Dataconstants.algoCreateModel.getEquityModel(response2);
// //print("algo instruction ID : ${Dataconstants.algoCreateModel.createAlgo.data.instId}");
      // for(int i =0;i<data2.length;i++) {
      //   Dataconstants.fetchAlgoModel.fetchAlgoList(data2[i]);
      // }
      // return apiResponse;
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }
}