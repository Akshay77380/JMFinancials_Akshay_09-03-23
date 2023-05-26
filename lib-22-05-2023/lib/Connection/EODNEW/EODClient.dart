import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../Connection/EODNEW/structures/Request/TEODRequestHeaderRecord.dart';
import '../../Connection/IQS/structures/Request/THeaderRecord.dart';
import 'package:path_provider/path_provider.dart';

import '../../Connection/Socket/Connection.dart';

import '../../Connection/Socket/Client.dart';

import '../../database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart';

import '../../util/Dataconstants.dart';
import '../structHelper/BufferForSock.dart';
import '../../Connection/ResponseListener.dart';

class EODClient implements Client {
  ResponseListener mResponseListener;
  bool isConnected = false, isMasterChecked = false;
  int connectAttemps = 0;
  Connection connection;
  static int iqsHeaderSize = new THeaderRecord().sizeOf();
  static int eodHeaderSize = new TEODRequestHeaderRecord().sizeOf();
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
      tag: 'IQS Master',
      ip: Dataconstants.newsIP,
      port: Dataconstants.iqsPORT,
    );
    this.connection.connect();
    startReconnecTimer();
  }

  void startReconnecTimer() {
    if (timer == null) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (connectAttemps > 5 && masterExists) {
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
            ip: Dataconstants.newsIP,
            port: Dataconstants.iqsPORT,
          );
          // //print('Trying $connectAttemps');
          this.connection.connect();
        }
      });
    }
  }

  void onConnected() {
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
      sendRequestToEODServer('E', masterDate);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  void sendRequestToEODServer(String reqType, int date) {
    try {
      THeaderRecord header = new THeaderRecord();
      header.msgType.setValueChar(reqType);
      header.msgLen.setValue(date);
      if (connection != null) {
        connection.sendRequest(header.getBytes());
      }
      isMasterChecked = true;
    } catch (e) {}
  }

  void processReply(Uint8List response) async {
    try {
      eodBuff.write(response, response.length);
      TEODRequestHeaderRecord header = TEODRequestHeaderRecord();
      Uint8List data;
      int bufAvailLen, bufReqLen;
      eodCompressBuff = new BufferForSock(0);
      data = Uint8List(eodHeaderSize);
      while (eodBuff.getBufUsed >= eodHeaderSize) {
        eodBuff.peek(data, data.length);
        header.setFields(data);
        bufAvailLen = eodBuff.getBufUsed;
        bufReqLen = eodHeaderSize + header.replyLen.getValue();
        if (header.scripCode.getValue() == 0)
          mResponseListener.onResponseReceieved(
              ((bufAvailLen / bufReqLen) - 0.2).toString(), 999);
        if (bufReqLen > bufAvailLen) break;
        eodBuff.read(data, eodHeaderSize);
        header.setFields(data);
        if (header.compressed.getValue() == 1) {
          Uint8List compress = Uint8List(header.replyLen.getValue());
          eodBuff.read(compress, header.replyLen.getValue());
          //var dir = await getExternalStorageDirectory();
          //File('${dir.path}/new.txt').writeAsStringSync(compress.join("\n"));
          Uint8List decompress = BZip2Decoder().decodeBytes(compress);
          header.compressed.setValue(0);
          header.replyLen.setValue(decompress.length);
          eodBuff.write(header.getBytes(), eodHeaderSize);
          eodBuff.write(decompress, decompress.length);
          continue;
        }
        bool isMasterDownload = header.scripCode.getValue() == 0 ? true : false;
        if (isMasterDownload) {
          final databasePath = join(await getDatabasesPath(), "masters.mf");
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
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  void loadMasters(bool isMasterDownload) async {
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
