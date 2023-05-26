import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';

import 'package:markets/Connection/Socket/Client.dart';
import 'package:markets/util/DateUtil.dart';

import '../../model/scrip_info_model.dart';
import '../../util/ConnectionStatus.dart';
import '../../util/InAppSelections.dart';

import 'package:markets/Connection/IQS/structures/Request/TReqBidOfferRecord.dart';

import 'package:markets/Connection/IQS/structures/RecHeader.dart';
import 'package:markets/Connection/IQS/structures/Request/IClientInfoToIQSRecord.dart';
import 'package:markets/Connection/IQS/structures/Request/THeaderRecord.dart';
import 'package:markets/Connection/IQS/structures/Request/TReqDataForScripRecord.dart';
import 'package:markets/Connection/IQS/structures/Request/TReqMarketSummaryRecord.dart';
import 'package:markets/Connection/structHelper/RespRecType.dart';
import '../../model/exchData.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../structHelper/BufferForSock.dart';
import 'package:markets/Connection/ResponseListener.dart';
import '../Socket/Connection.dart';
import 'structures/Request/TReqScripIntraDayHistoryVolRecord.dart';

class IQSClient implements Client {
  bool iqsReconnect = false;
  Timer iqsTimer;
  DateTime lastDataInTime, lastConnectTime;
  ResponseListener mResponseListener;
  bool isConnected = false, isTryingToConnect = false;
  static Connection connection;
  static BufferForSock iqsBuff;
  static IClientInfoToIQSRecord loginRequest;
  static int tReqDataForScripRecordSize = TReqDataForScripRecord().sizeOf();
  static int tHeaderRecordSize = THeaderRecord().sizeOf();
  Function functionToBeTriggered;

  void setResponseListener(ResponseListener mResponseListener) {
    this.mResponseListener = mResponseListener;
  }

  void connect() {
    //print('iqs conntect called');
    isTryingToConnect = true;
    if (connection != null) {
      connection.disconnect();
    }

    connection = Connection(
      client: this,
      tag: 'IQS',
      ip: Dataconstants.iqsIP,
      port: Dataconstants.iqsPORT,
    );
    connection.connect();
  }

  void onConnected() {
     isTryingToConnect = false;
    try {
      //print('IQS On Connected CAlled');
      isConnected = true;
      lastConnectTime = DateTime.now();
      _startiqsTimer();
      IClientInfoToIQSRecord req = IClientInfoToIQSRecord();
      req.header.msgType.setValueChar('Q');
      req.header.msgLen.setValue(req.sizeOf() - loginRequest.header.sizeOf());
      req.feUserID.setValue(Dataconstants.internalFeUserID, 15);
      req.feUserIDLength.setValue(Dataconstants.internalFeUserID.length);
      req.feUserName.setValue(Dataconstants.internalFeUserID, 30);
      req.feUserNameLength.setValue(Dataconstants.internalFeUserID.length);
      req.requiredNseEquity.setValue(1);
      req.requiredNseDeriv.setValue(1);
      req.requiredBseEquity.setValue(1);
      req.requiredNseCurrency.setValue(1);
      req.requiredMcx.setValue(1);
      req.requiredBseFo.setValue(1);
      req.requiredBseCurr.setValue(1);
      req.allowTotalBuySellQty.setValue(0);
      req.getAllBO.setValue(20);
      req.version.setValue(Dataconstants.fileVersion, 10);
      req.versionLength.setValue(Dataconstants.fileVersion.length);
      req.allScripsNseCash.setValue(0);
      req.allScripsNseDeriv.setValue(0);
      req.allScripsBseCash.setValue(0);
      req.junk.setValueAsBytes(Uint8List(40));
      if (isConnected && connection != null) {
        connection.sendRequest(req.getBytes());
        if (iqsReconnect) {
          for (int i = 0; i < Dataconstants.exchData.length; i++) {
            String exch;
            if (i == 0 || i == 1)
              exch = 'N';
            else if (i == 2)
              exch = 'B';
            else if (i == 3)
              exch = 'C';
            else if (i == 4)
              exch = 'E';
            else if (i == 5)
              exch = 'M';
            else
              exch = 'M';
            TReqDataForScripRecord req1 = TReqDataForScripRecord();
            req1.header.msgType.setValueChar("d");
            req1.header.msgLen.setValue(req1.sizeOf() - req1.header.sizeOf());
            req1.exch.setValueChar(exch);
            req1.exchType.setValueChar(Dataconstants.exchData[i].exchTypeShort);
            req1.addToList.setValue(1);
            for (var element in Dataconstants.exchData[i].reqDataForScrip) {
              try {
                req1.code.setValue(element);
                connection.sendRequest(req1.getBytes());
                // if(i == 3 || i == 4){
                //   for(int j=0;j<Dataconstants.exchData[i].reqDataForScrip.length;j++){
                //     //print(Dataconstants.exchData[i].reqDataForScrip);
                //   }
                // }

              } on SocketException catch (s) {
                // //print(s);
              } catch (e) {
                // //print(e);
              }
            }
          }
        }
      }
      iqsReconnect = false;
      if (Dataconstants.iqsFreshConnection) CommonFunction.startupTasks();
      Dataconstants.iqsFreshConnection = false;
      if (functionToBeTriggered != null) {
        functionToBeTriggered();
        functionToBeTriggered = null;
      }


    } on SocketException catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  void disconnect() {
    isTryingToConnect = false;
    //print('IQS called disconnet');
    if (connection != null) {
      connection.disconnect();
      connection = null;
    }
    if (iqsBuff != null) iqsBuff.free();
  }

  void onDisconnected() {
    //print('IQS onDisconnected');
    isTryingToConnect = false;
    isConnected = false;
    if (iqsBuff != null) iqsBuff.free();
  }

  void onError(String error) {
    //print('IQS /;onError');
    isTryingToConnect = false;
    isConnected = false;
    if (iqsBuff != null) iqsBuff.free();
    connect();
  }

  void createHeaderRecord(String id) {
    try {
      loginRequest = new IClientInfoToIQSRecord();
      loginRequest.header = new THeaderRecord();
      loginRequest.allowTotalBuySellQty.setValue(1);
      loginRequest.feUserIDLength.setValue(id.length);
      loginRequest.feUserID.setValue(id, 15);
      loginRequest.feUserNameLength.setValue(id.length);
      loginRequest.feUserName.setValue(id, 30);
      loginRequest.getAllBO.setValue(30);
      loginRequest.header.msgType.setValueChar('Q');
      loginRequest.header.msgLen
          .setValue(loginRequest.sizeOf() - loginRequest.header.sizeOf());
      loginRequest.requiredBseEquity.setValue(1);
      loginRequest.requiredNseCurrency.setValue(1);
      loginRequest.requiredNseDeriv.setValue(1);
      loginRequest.requiredNseEquity.setValue(1);
      loginRequest.requiredNseSLBM.setValue(1);
      loginRequest.version.setValue("3.0.5.500", 10);
      loginRequest.versionLength.setValue(9);
      loginRequest.allScripsNseCash.setValue(0);
      loginRequest.allScripsBseCash.setValue(0);
      loginRequest.allScripsNseDeriv.setValue(0);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

//int size = 0;
  void processReply(Uint8List response) async {
    try {
      //size += response.length;
      lastDataInTime = DateTime.now();
      iqsBuff.write(response, response.length);
      int sh1RecSize = 30;

      List<int> buff = List<int>(iqsBuff.getBufUsed);
      while (iqsBuff.getBufUsed >= sh1RecSize) {
        try {
          iqsBuff.read(buff, sh1RecSize);
          RecHeader header = RecHeader();
          Uint8List hdr = Uint8List(10);
          hdr.setRange(0, hdr.length, buff, 0);
          header.setFields(hdr);
          if (!RespRecType.validRecType.contains(header.recType.getValue())) {
            iqsBuff.free();
            return;
          }
          Uint8List resp1 = Uint8List((sh1RecSize - 10));
          resp1.setRange(0, resp1.length, buff, hdr.length);

          final exchPos = CommonFunction.getExchPosOnCode(
              String.fromCharCode(header.exch.getValue()),
              header.exchCode.getValue());
          if (header.recType.getValue() != RespRecType.recType_1) {
            if (header.recType.getValue() == RespRecType.recType_Y) {
              int status = resp1[0];
              if (Dataconstants.exchData[exchPos].exchangeStatus !=
                  ExchangeStatus.values[status]) {
                Dataconstants.exchData[exchPos].exchangeStatus =
                    ExchangeStatus.values[status];
              }
            } else if (header.recType.getValue() == RespRecType.recType_y) {
              Dataconstants.summaryMarketWatchListener
                  .updateSummaryWatchlist(resp1[2]);
            } else {
              final scripPos = Dataconstants.exchData[exchPos]
                  .scripPos(header.exchCode.getValue());
              if (scripPos < 0) {
                var model = CommonFunction.getScripDataModelFastForIQS(
                  exchPos: exchPos,
                  exchCode: header.exchCode.getValue(),
                );
                if (model.exchCode != 0) {
                  model.setFields(resp1, header);
                }
              } else
                Dataconstants.exchData[exchPos]
                    .getModel(scripPos)
                    .setFields(resp1, header);
            }
          } else {
            THeaderRecord head = THeaderRecord();
            head.msgType.setValueChar('1');
            head.msgLen.setValue(0);
            if (isConnected && connection != null) {
              connection.sendRequest(head.getBytes());
            }
          }
        } catch (e, s) {
          // FirebaseCrashlytics.instance.recordError(e, s);
        }
      }
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  // //int size = 0;
  // void processReply(Uint8List response) async {
  //   try {
  //     //size += response.length;
  //     lastDataInTime = DateTime.now();
  //     iqsBuff.write(response, response.length);
  //     int headerSize = 10, sh1RecSize = 30, bufAvailLen, bufReqLen;
  //     Uint8List buff = Uint8List(iqsBuff.getBufUsed);
  //     RecHeader header = RecHeader();

  //     while (iqsBuff.getBufUsed >= headerSize) {
  //       try {
  //         iqsBuff.peek(buff, buff.length);
  //         if (buff.length < 10) buff = Uint8List(10);
  //         header.setFields(buff);
  //         bufAvailLen = iqsBuff.getBufUsed;
  //         bool isChartResponse =
  //             header.recType.getValue() == RespRecType.recType_k ||
  //                 header.recType.getValue() == RespRecType.recType_v;
  //         if (isChartResponse)
  //           bufReqLen = headerSize + header.recTime.getValue();
  //         else
  //           bufReqLen = sh1RecSize;
  //         if (bufReqLen > bufAvailLen) break;
  //         iqsBuff.read(buff, headerSize);
  //         if (!RespRecType.validRecType.contains(header.recType.getValue())) {
  //           iqsBuff.free();
  //           return;
  //         }

  //         buff = Uint8List(
  //             isChartResponse ? header.recTime.getValue() : sh1RecSize - 10);

  //         iqsBuff.read(buff, buff.length);

  //         final exchPos = CommonFunction.getExchPosOnCode(
  //             String.fromCharCode(header.exch.getValue()),
  //             header.exchCode.getValue());
  //         if (header.recType.getValue() != RespRecType.recType_1) {
  //           if (header.recType.getValue() == RespRecType.recType_Y) {
  //             int status = buff[0];
  //             if (Dataconstants.exchData[exchPos].exchangeStatus !=
  //                 ExchangeStatus.values[status]) {
  //               Dataconstants.exchData[exchPos].exchangeStatus =
  //                   ExchangeStatus.values[status];
  //             }
  //           } else if (header.recType.getValue() == RespRecType.recType_y) {
  //             Dataconstants.summaryMarketWatchListener
  //                 .updateSummaryWatchlist(buff[2]);
  //           } else {
  //             final scripPos = Dataconstants.exchData[exchPos]
  //                 .scripPos(header.exchCode.getValue());
  //             if (scripPos < 0) {
  //               var model = CommonFunction.getScripDataModelFastForIQS(
  //                 exchPos: exchPos,
  //                 exchCode: header.exchCode.getValue(),
  //               );
  //               if (model.exchCode != 0) {
  //                 model.setFields(buff, header);
  //               }
  //             } else
  //               Dataconstants.exchData[exchPos]
  //                   .getModel(scripPos)
  //                   .setFields(buff, header);
  //           }
  //         } else {
  //           THeaderRecord head = THeaderRecord();
  //           head.msgType.setValueChar('1');
  //           head.msgLen.setValue(0);
  //           if (isConnected && connection != null) {
  //             connection.sendRequest(head.getBytes());
  //           }
  //         }
  //       } catch (e, s) {
  //         FirebaseCrashlytics.instance.recordError(e, s);
  //       }
  //     }
  //   } catch (e, s) {
  //     FirebaseCrashlytics.instance.recordError(e, s);
  //   }
  // }

  sendChartRequest(
      ScripInfoModel model,
      int time,
      ) {
    try {
      // return;
      if (!isConnected) return;
      model.chartOHLCRequestedTime = time;
      model.chartCloseRequestedTime = time;
      // if (!model.isNewCloseChartDataRequired(time)) return;
      TReqScripIntraDayHistoryVolRecord req =
      TReqScripIntraDayHistoryVolRecord();
      req.header.msgType.setValueChar("r");
      req.header.msgLen.setValue(req.sizeOf() - req.header.sizeOf());
      req.exch.setValueChar(model.exch);
      req.code.setValue(model.exchCode);
      req.uptoTime.setValue(time);
      connection.sendRequest(req.getBytes());
      //print("chart request for ${model.name} is sent");
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  void requestForBidOffer(String exch, int exchCode) {
    try {
      if (!Dataconstants.iqsClient.isConnected) return;
      TReqBidOfferRecord req = TReqBidOfferRecord();
      req.header.msgType.setValueChar("O");
      req.header.msgLen.setValue(req.sizeOf() - req.header.sizeOf());
      req.exch.setValueChar(exch);
      req.code.setValue(exchCode);
      if (isConnected && connection != null) {
        connection.sendRequest(req.getBytes());
      }
    } on Exception catch (e, s) {
      //log("Error " + e.toString());
      CommonFunction.firebaseCrashlytics(e, s);
    }
  }

  Completer completer;

  Future<void> sendIqsReconnectWithCallback() {
    try {
      var internet = ConnectionStatusSingleton.getInstance().hasConnection;

      if (!isConnected || !internet) {
        completer = null;
        Completer tempCompleter = Completer<void>();

        iqsReconnect = true;
        disconnect();
        //print("iqs called sendIqsReconnectWithCallback 1");
        connect();
        //print("iqs called sendIqsReconnectWithCallback 1");
        tempCompleter.complete();
        // CommonFunction.showBasicToast(!internet
        //     ? 'Unable to connect to server.\nPlease check your Internet connection'
        //     : 'Reconnecting to server.\nPlease try again.');
        return tempCompleter.future;
      } else {
        completer = Completer<void>();
        Dataconstants
            .marketWatchListeners[InAppSelection.marketWatchID].watchList
            .forEach((model) {
          Dataconstants.itsClient
              .getChartData(timeInterval: 15, chartPeriod: 'I', model: model);
        });
        Dataconstants.predefinedMarketWatchListener.watchList.forEach((model) {
          Dataconstants.itsClient.getChartData(
            timeInterval: 15,
            chartPeriod: 'I',
            model: model,
          );
        });
        iqsReconnect = true;
        disconnect();
        connect();
        //print("iqs called sendIqsReconnectWithCallback 2");
        completer.complete();
        return completer.future;
      }
    } catch (e, s) {
      CommonFunction.firebaseCrashlytics(e, s);
    }
  }

  IsecSendIqsReconnectWithCallback(String chartToCall) async {
    if (chartToCall == "MarketWatchList") {
      var toCallMarketChart = await CommonFunction.getMarketWatchChartTime();
      if (toCallMarketChart) {
        Dataconstants
            .marketWatchListeners[InAppSelection.marketWatchID].watchList
            .forEach((model) {
          Dataconstants.itsClient
              .getChartData(timeInterval: 15, chartPeriod: 'I', model: model);
        });
        // //print(chartToCall);
      }
    } else if (chartToCall == "PredefinedWatchList") {
      var toCallPredefinedChart = await CommonFunction.getPredefinedChartTime();
      if (toCallPredefinedChart) {
        Dataconstants.predefinedMarketWatchListener.watchList.forEach((model) {
          Dataconstants.itsClient.getChartData(
            timeInterval: 15,
            chartPeriod: 'I',
            model: model,
          );
        });
        // //print(chartToCall);
      }
    } else if (chartToCall == "IndicesWatchList") {
      var toCallIndicesChart = await CommonFunction.getIndicesChartTime();
      if (toCallIndicesChart) {
        Dataconstants.indicesMarketWatchListener.watchList.forEach((model) {
          Dataconstants.itsClient
              .getChartData(timeInterval: 15, chartPeriod: 'I', model: model);
        });
        // //print(chartToCall);
      }
    }

    iqsReconnect = true;
    Completer tempCompleter = Completer<void>();
    disconnect();
    connect();
    tempCompleter.complete();
    return tempCompleter.future;
  }

  void sendIqsReconnect() {
    iqsReconnect = true;
    disconnect();
    connect();
  }

  void sendLTPRequest(ScripInfoModel model, bool addToList) {
    try {
      if (!isConnected || connection == null) return;
      TReqDataForScripRecord req = TReqDataForScripRecord();
      bool contains = Dataconstants.exchData[model.exchPos].reqDataForScrip
          .contains(model.exchCode);
      if (addToList) {
        if (contains) return;
        Dataconstants.exchData[model.exchPos].reqDataForScrip
            .add(model.exchCode);
        req.addToList.setValue(1);
      } else {
        if (!contains) return;
        if (Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
            .isScripInMarketWatch(model.exch, model.exchCode)) return;
        Dataconstants.exchData[model.exchPos].reqDataForScrip
            .remove(model.exchCode);
        req.addToList.setValue(0);
      }
      req.header.msgType.setValueChar("d");
      req.header.msgLen
          .setValue(tReqDataForScripRecordSize - tHeaderRecordSize);
      req.exch.setValueChar(model.exch);
      req.exchType
          .setValueChar(Dataconstants.exchData[model.exchPos].exchTypeShort);
      req.code.setValue(model.exchCode);
      if (model.exchCode == 71326) {
        //print("REQ of AXIS 660");
      }
      connection.sendRequest(req.getBytes());
    } on Exception catch (e, s) {
      //log("Error" + e.toString());
      CommonFunction.firebaseCrashlytics(e, s);
    }
  }

  void sendScripRequestToIQS(ScripInfoModel model, bool addToList) {
    try {
      if (!isConnected || connection == null) return;
      TReqDataForScripRecord req = TReqDataForScripRecord();
      bool contains = Dataconstants.exchData[model.exchPos].reqDataForScrip
          .contains(model.exchCode);
      if (addToList) {
        if (contains) return;
        Dataconstants.exchData[model.exchPos].reqDataForScrip
            .add(model.exchCode);
        req.addToList.setValue(1);
      } else {
        if (!contains) return;
        if (Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
            .isScripInMarketWatch(model.exch, model.exchCode)) return;
        Dataconstants.exchData[model.exchPos].reqDataForScrip
            .remove(model.exchCode);
        req.addToList.setValue(0);
      }
      req.header.msgType.setValueChar("d");
      req.header.msgLen
          .setValue(tReqDataForScripRecordSize - tHeaderRecordSize);
      req.exch.setValueChar(model.exch);
      req.exchType
          .setValueChar(Dataconstants.exchData[model.exchPos].exchTypeShort);
      req.code.setValue(model.exchCode);
      if (model.exchCode == 71326) {
        //print("REQ of AXIS 660");
      }
      connection.sendRequest(req.getBytes());
    } on Exception catch (e, s) {
      //log("Error " + e.toString());
      CommonFunction.firebaseCrashlytics(e, s);
    }
  }

  void sendBulkLTPRequest(List<ScripInfoModel> models, bool addToList) {
    try {
      if (!isConnected || connection == null) return;
      TReqDataForScripRecord req = TReqDataForScripRecord();
      List<bool> alreadyCotains = List(models.length);
      for (int i = 0; i < models.length; i++) {
        alreadyCotains[i] = Dataconstants
            .exchData[models[i].exchPos].reqDataForScrip
            .contains(models[i].exchCode);
      }
      req.header.msgType.setValueChar("d");
      req.header.msgLen
          .setValue(tReqDataForScripRecordSize - tHeaderRecordSize);
      req.addToList.setValue(addToList ? 1 : 0);
      if (addToList) {
        for (int i = 0; i < models.length; i++) {
          if (alreadyCotains[i]) continue;
          Dataconstants.exchData[models[i].exchPos].reqDataForScrip
              .add(models[i].exchCode);
          req.exch.setValueChar(models[i].exch);
          req.exchType.setValueChar(
              Dataconstants.exchData[models[i].exchPos].exchTypeShort);
          req.code.setValue(models[i].exchCode);
          connection.sendRequest(req.getBytes());
        }
      } else {
        for (int i = 0; i < models.length; i++) {
          if (!alreadyCotains[i]) continue;
          if (Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
              .isScripInMarketWatch(models[i].exch, models[i].exchCode))
            continue;
          Dataconstants.exchData[models[i].exchPos].reqDataForScrip
              .remove(models[i].exchCode);
          req.exch.setValueChar(models[i].exch);
          req.exchType.setValueChar(
              Dataconstants.exchData[models[i].exchPos].exchTypeShort);
          req.code.setValue(models[i].exchCode);
          connection.sendRequest(req.getBytes());
        }
      }
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  // void sendChartRequest(
  //   ScripInfoModel model,
  //   int time,
  // ) {
  //   try {
  //     // return;
  //     if (!isConnected) return;
  //     model.chartOHLCRequestedTime = time;
  //     model.chartCloseRequestedTime = time;
  //     if (!model.isNewCloseChartDataRequired(time)) return;
  //     TReqScripIntraDayHistoryVolRecord req =
  //         TReqScripIntraDayHistoryVolRecord();
  //     req.header.msgType.setValueChar("k");
  //     req.header.msgLen.setValue(req.sizeOf() - req.header.sizeOf());
  //     req.exch.setValueChar(model.exch);
  //     req.code.setValue(model.exchCode);
  //     req.uptoTime.setValue(time);
  //     connection.sendRequest(req.getBytes());
  //     //print("request for ${model.name} is sent");
  //   } catch (e, s) {
  //     FirebaseCrashlytics.instance.recordError(e, s);
  //   }
  // }

  void sendScripDetailsRequest(
    String exch,
    int exchCode,
    bool addToList,
  ) {
    try {
      if (!isConnected) return;
      TReqBidOfferRecord req = TReqBidOfferRecord();
      req.header.msgType.setValueChar("D");
      req.header.msgLen.setValue(req.sizeOf() - req.header.sizeOf());
      req.exch.setValueChar(exch);
      req.code.setValue(exchCode);
      req.addToList.setValue(addToList ? 1 : 0);
      connection.sendRequest(req.getBytes());
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  sendMarketDepthRequest(
    String exch,
    int exchCode,
    bool addToList,
  ) {
    try {
      //print("isIqs connected => $isConnected");
      if (!isConnected) return;

      TReqBidOfferRecord req = TReqBidOfferRecord();
      req.header.msgType.setValueChar("O");
      req.header.msgLen.setValue(req.sizeOf() - req.header.sizeOf());
      req.exch.setValueChar(exch);
      req.code.setValue(exchCode);
      req.addToList.setValue(addToList ? 1 : 0);
      connection.sendRequest(req.getBytes());
      return;
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  Future<void> requestForMarketSummary(
      String exch, String exchType, int reportType) {
    Completer tempCompleter = Completer<void>();
    if (!isConnected) {
      functionToBeTriggered =
          () => requestForMarketSummary(exch, exchType, reportType);
      disconnect();
      connect();
      tempCompleter.complete();
      return tempCompleter.future;
    } else {
      Dataconstants.summaryMarketWatchListener.setSummaryWatchList(reportType);
      TReqMarketSummaryRecord req = TReqMarketSummaryRecord();
      req.header.msgType.setValueChar("y");
      req.header.msgLen.setValue(req.sizeOf() - req.header.sizeOf());
      req.exch.setValueChar(exch);
      req.exchType.setValueChar(exchType);
      req.reportType.setValue(reportType);
      req.addToList.setValue(0);
      if (connection != null) {
        connection.sendRequest(req.getBytes());
      }
      tempCompleter.complete();
      return tempCompleter.future;
    }
  }

  void stopIqsTimer() {
    if (iqsTimer != null) {
      iqsTimer.cancel();
      iqsTimer = null;
    }
  }

  void _startiqsTimer() {
    try {
      if (iqsTimer != null) {
        iqsTimer.cancel();
        iqsTimer = null;
      }
      iqsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        // //print("Exchange Status -> ${Dataconstants.exchData[0].exchangeStatus}");
        var now = DateTime.now();
        if (now.difference(lastConnectTime).inSeconds > 60 &&
            now.difference(lastDataInTime).inSeconds > 5 &&
            Dataconstants.itsClient.isLoggedIn) {
          if (Dataconstants.exchData[0].exchangeStatus ==
                  ExchangeStatus.nesOpen ||
              Dataconstants.exchData[1].exchangeStatus ==
                  ExchangeStatus.nesOpen ||
              Dataconstants.exchData[2].exchangeStatus ==
                  ExchangeStatus.nesOpen) {
            iqsReconnect = true;
            iqsTimer.cancel();
            iqsTimer = null;
            disconnect();
            if (!isTryingToConnect) connect();
          }
        }
      });
    } catch (e) {
      // //print(e);
    }
  }

  void bulkSendScripRequestToIQS(List<ScripInfoModel> models, bool addToList) {
    try {
      if (!isConnected || connection == null) return;
      TReqDataForScripRecord req = TReqDataForScripRecord();
      List<bool> alreadyCotains = List(models.length);
      for (int i = 0; i < models.length; i++) {
        alreadyCotains[i] = Dataconstants
            .exchData[models[i].exchPos].reqDataForScrip
            .contains(models[i].exchCode);
      }
      req.header.msgType.setValueChar("d");
      req.header.msgLen
          .setValue(tReqDataForScripRecordSize - tHeaderRecordSize);
      req.addToList.setValue(addToList ? 1 : 0);
      if (addToList) {
        for (int i = 0; i < models.length; i++) {
          if (alreadyCotains[i]) continue;
          Dataconstants.exchData[models[i].exchPos].reqDataForScrip
              .add(models[i].exchCode);
          req.exch.setValueChar(models[i].exch);
          req.exchType.setValueChar(
              Dataconstants.exchData[models[i].exchPos].exchTypeShort);
          req.code.setValue(models[i].exchCode);
          connection.sendRequest(req.getBytes());
        }
      } else {
        for (int i = 0; i < models.length; i++) {
          if (!alreadyCotains[i]) continue;
          if (Dataconstants.marketWatchListeners[InAppSelection.marketWatchID]
              .isScripInMarketWatch(models[i].exch, models[i].exchCode))
            continue;
          Dataconstants.exchData[models[i].exchPos].reqDataForScrip
              .remove(models[i].exchCode);
          req.exch.setValueChar(models[i].exch);
          req.exchType.setValueChar(
              Dataconstants.exchData[models[i].exchPos].exchTypeShort);
          req.code.setValue(models[i].exchCode);
          connection.sendRequest(req.getBytes());
        }
      }
    } on Exception catch (e, s) {
      //log("Error " + e.toString());
      CommonFunction.firebaseCrashlytics(e, s);
    }
  }

  void stopiqsTimer() {
    if (iqsTimer != null) {
      iqsTimer.cancel();
      iqsTimer = null;
    }
  }
}
