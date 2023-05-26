import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../Connection/Socket/Connection.dart';

import '../../Connection/Socket/Client.dart';

import '../../database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart';

import '../../Connection/EOD/structures/Reply/TEODReplyHeaderRecord.dart';
import '../../Connection/EOD/structures/Request/TEODRequestHeaderRecord.dart';
import '../../Connection/structHelper/IntStruct.dart';
import '../../util/Dataconstants.dart';
import '../structHelper/BufferForSock.dart';
import '../../Connection/ResponseListener.dart';

class EODClient implements Client {
  ResponseListener mResponseListener;
  bool isConnected = false, isMasterChecked = false;
  int connectAttemps = 0;
  Connection connection;
  static int eodHeaderSize = new TEODReplyHeaderRecord().sizeOf();
  static BufferForSock eodBuff, eodCompressBuff;
  final bool masterExists;
  Timer timer;

  EODClient(this.masterExists);
  void setResponseListener(ResponseListener mResponseListener) {
    this.mResponseListener = mResponseListener;
  }

  void connect() {
    this.connection = new Connection(
      client: this,
      tag: 'EOD',
      ip: Dataconstants.eodIP,
      port: Dataconstants.eodPORT,
    );
    this.connection.connect();
    startReconnecTimer();
  }

  void startReconnecTimer() {
    if (timer == null) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (connectAttemps >= 1 && masterExists) {
          // //print('bypass');
          if (timer != null) {
            timer.cancel();
            timer = null;
          }
          loadMasters(false);
        }
        connectAttemps++;
        if (!isConnected) {
          this.connection = new Connection(
            client: this,
            tag: 'EOD',
            ip: Dataconstants.eodIP,
            port: Dataconstants.eodPORT,
          );
          // //print('Trying $connectAttemps');
          this.connection.connect();
        }
      });
    }
  }

  void onConnected() {
    // FirebaseCrashlytics.instance.log('EOD Connected');
    // //print('EOD Connected');
    isConnected = true;
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    if (!isMasterChecked) checkMasterStatus();
  }

  void disconnect() {
    if (this.connection != null) {
      this.connection.disconnect();
      this.connection = null;
    }
    if (eodBuff != null) eodBuff.free();
  }

  void onDisconnected() {
    eodBuff.free();
    isConnected = false;
    if (eodBuff != null) eodBuff.free();
  }

  void onError(String error) {
    isConnected = false;
    if (eodBuff != null) eodBuff.free();
    connect();
  }

  void sendProgressResponse(double value) {
    mResponseListener.onResponseReceieved((value).toString(), 999);
  }

  Future<void> checkMasterStatus() async {
    try {
      int masterDate = 0;

      if (masterExists) {
        masterDate = await DatabaseHelper.getMasterDate();
      }
      sendRequestToEODServer(100, masterDate);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  void sendRequestToEODServer(int reqType, int date) {
    try {
      TEODRequestHeaderRecord header = new TEODRequestHeaderRecord();
      IntStruct body = IntStruct(date);
      header.clientID.setValue(Dataconstants.feUserID, 15);
      header.idLength.setValue(Dataconstants.feUserID.length);
      header.requestType.setValue(reqType);
      header.requestLen.setValue(body.sizeOf());
      Uint8List hdrStr = header.getBytes();
      Uint8List bodyStr = body.toBytes();
      Uint8List byteArr = new Uint8List(hdrStr.length + bodyStr.length);
      byteArr.setRange(0, hdrStr.length, hdrStr, 0);
      byteArr.setRange(
          hdrStr.length, hdrStr.length + bodyStr.length, bodyStr, 0);
      if (connection != null) {
        connection.sendRequest(byteArr);
        // FirebaseCrashlytics.instance.log('Master Request Sent');
        return;
      }
      isMasterChecked = true;
    } catch (e) {}
  }

  void processReply(Uint8List response) async {
    try {
      bool derivFromNew = false;
      int replyType = 0;
      eodBuff.write(response, response.length);
      TEODReplyHeaderRecord header = TEODReplyHeaderRecord.getInstance();
      Uint8List data;
      int bufAvailLen, bufReqLen;
      eodCompressBuff = new BufferForSock(0);
      data = Uint8List(31);
      while (eodBuff.getBufUsed >= eodHeaderSize) {
        data = Uint8List(33);
        eodBuff.peek(data, data.length);
        if (data[16] == 51) {
          derivFromNew = true;
          data = Uint8List(33);
          eodBuff.peek(data, data.length);
          header.setFields(data);
          bufAvailLen = eodBuff.getBufUsed;
          bufReqLen = 33 + header.replyLen.getValue();
          replyType = header.replyType.getValue();
        } else {
          derivFromNew = false;
          data = Uint8List(eodHeaderSize);
          eodBuff.peek(data, data.length);
          header.setFields(data);
          bufAvailLen = eodBuff.getBufUsed;
          bufReqLen = eodHeaderSize + header.replyLen.getValue();
          replyType = header.replyType.getValue();
        }
        if (header.scripCode.getValue() == 0)
          mResponseListener.onResponseReceieved(
              ((bufAvailLen / bufReqLen) - 0.2).toString(), 999);
        if (bufReqLen > bufAvailLen) break;
        if (derivFromNew) {
          eodBuff.read(data, 33);
          header.setFields(data);
          if (header.compressed.getValue() == 1) {
            Uint8List compress = Uint8List(header.replyLen.getValue());
            eodBuff.read(compress, header.replyLen.getValue());
            Uint8List decompress = BZip2Decoder().decodeBytes(compress);
            header.compressed.setValue(0);
            header.replyLen.setValue(decompress.length);
            eodBuff.write(header.getBytes(), 33);
            eodBuff.write(decompress, decompress.length);
            replyType = header.replyType.getValue();
            continue;
          }
        } else {
          eodBuff.read(data, 31);
          header.setFields(data);
          if (header.compressed.getValue() == 1) {
            Uint8List compress = Uint8List(header.replyLen.getValue());
            eodBuff.read(compress, header.replyLen.getValue());
            Uint8List decompress = BZip2Decoder().decodeBytes(compress);
            header.compressed.setValue(0);
            header.replyLen.setValue(decompress.length);
            eodBuff.write(header.getBytes(), eodHeaderSize);
            eodBuff.write(decompress, decompress.length);
            replyType = header.replyType.getValue();
            continue;
          }
        }
        switch (replyType) {
          //Masters
          case 100:
            {
              bool isMasterDownload =
                  header.scripCode.getValue() == 0 ? true : false;
              if (isMasterDownload) {
                final databasePath =
                    join(await getDatabasesPath(), "masters.mf");
                Uint8List data = Uint8List(header.replyLen.getValue());
                eodBuff.read(data, header.replyLen.getValue());
                final dbFile = File(databasePath);
                final masterExists = await dbFile.exists();
                if (masterExists) await dbFile.delete();
                dbFile.writeAsBytesSync(data, flush: true);
                eodBuff.free();
              }
              loadMasters(isMasterDownload);
            }
            break;
        }
      }
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  void loadMasters(bool isMasterDownload) async {
    //log("");
    try {
      var result = await DatabaseHelper.getAllScripDetailFromMemory(
        sendProgressResponse,
        isMasterDownload,
      );
      if (result) {
        disconnect();
        mResponseListener.onResponseReceieved('', 100);
      } else
        loadMasters(isMasterDownload);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }
}
