import 'dart:async';
import 'dart:typed_data';
import 'package:markets/Connection/Socket/Client.dart';

import 'package:markets/Connection/Socket/Connection.dart';

import 'package:markets/Connection/News/structures/Reply/LiveSquakNewsRecord.dart';
import 'package:markets/Connection/News/structures/Request/TNewsMessageRecord.dart';
import 'package:markets/model/scripStaticModel.dart';
import '../../database/news_database.dart';
import '../../model/news_record_model.dart';
import 'package:archive/archive.dart';

import '../../util/CommonFunctions.dart';
import '../../util/ConnectionStatus.dart';
import '../../util/Dataconstants.dart';
import '../structHelper/BufferForSock.dart';
import 'package:markets/Connection/ResponseListener.dart';

class NewsClient implements Client {
  ResponseListener _mResponseListener;
  Connection connection;
  bool isConnected = false;
  static int newsHeaderSize = TNewsMessageRecord().sizeOf();
  static int liveNewsSize = LiveSquakNewsRecord().sizeOf();
  static BufferForSock newsBuff, newsCompressBuff;

  // Timer timer;
  Completer completer;

  static NewsClient getInstance() {
    return new NewsClient();
  }

  void setResponseListener(ResponseListener mResponseListener) {
    this._mResponseListener = mResponseListener;
  }

  void connect() {
    this.connection = new Connection(
      client: this,
      tag: 'News',
      ip: Dataconstants.newsIP,
      port: Dataconstants.newsPORT,
    );
    this.connection.connect();
    // if (timer == null) {
    //   int counter = 0;
    //   timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //     if (!isConnected) {
    //       this.connection = new Connection(
    //         client: this,
    //         tag: 'News',
    //         ip: Dataconstants.newsIP,
    //         port: Dataconstants.newsPORT,
    //       );
    //       // //print('Trying');
    //       // if (counter == 3)
    //       timer.cancel();
    //       this.connection.connect();
    //       counter++;
    //     }
    //   });
    // }
  }

  void onConnected() {
    Dataconstants.newsFreshConnection = false;
    isConnected = true;
    // if (timer != null) {
    //   timer.cancel();
    //   timer = null;
    // }
    checkNewsData();
    if (completer != null) {
      completer.complete();
      completer = null;
    }
  }

  void disconnect() {
    if (this.connection != null) {
      this.connection.disconnect();
      this.connection = null;
    }
    if (newsBuff != null) newsBuff.free();
  }

  void onDisconnected() {
    isConnected = false;
    if (newsBuff != null) newsBuff.free();
  }

  void onError(String error) {
    isConnected = false;
    if (newsBuff != null) newsBuff.free();
    // connect();
  }

  Future<Null> reconnectNewsServerCallback() {
    var internet = ConnectionStatusSingleton.getInstance().hasConnection;
    if (!isConnected || !internet) {
      completer = null;
      Completer tempCompleter = Completer<Null>();
      disconnect();
      connect();
      CommonFunction.showBasicToast(!internet
          ? 'Unable to connect to server.\nPlease check your Internet connection'
          : 'Reconnecting to server.\nPlease try again.');
      tempCompleter.complete();
      return tempCompleter.future;
    } else {
      completer = Completer<Null>();
      disconnect();
      connect();
      return completer.future;
    }
  }

  void checkNewsData() {
    try {
      NewsDatabase.instance.getTodayNews().then(
              (todayNews) => Dataconstants.todayNews.addToNewsListBulk(todayNews));
      NewsDatabase.instance
          .getLastestDate()
          .then((value) => sendRequestToNewsServer(value));
    } catch (e) {
      // //print(e);
    }
  }

  void sendRequestToNewsServer(int date) {
    try {
      TNewsMessageRecord header = TNewsMessageRecord();
      header.msgType.setValueChar('F');
      header.date.setValue(date ?? 0);
      if (connection != null) connection.sendRequest(header.getBytes());
    } catch (e) {
      // //print(e);
    }
  }

  void processReply(Uint8List response) async {
    try {
      newsBuff.write(response, response.length);
      TNewsMessageRecord header = TNewsMessageRecord();
      Uint8List data;
      int bufAvailLen, bufReqLen;
      newsCompressBuff = new BufferForSock(0);

      while (newsBuff.getBufUsed >= newsHeaderSize) {
        data = Uint8List(newsHeaderSize);
        newsBuff.peek(data, data.length);
        header.setFields(data);
        bufAvailLen = newsBuff.getBufUsed;
        bufReqLen = newsHeaderSize + header.replyLength.getValue();
        if (bufReqLen > bufAvailLen) break;
        newsBuff.read(data, newsHeaderSize);
        data = Uint8List(newsHeaderSize);
        if (header.compression.getValue() == 1) {
          Uint8List compress = Uint8List(header.replyLength.getValue());
          newsBuff.read(compress, header.replyLength.getValue());
          Uint8List decompress = BZip2Decoder().decodeBytes(compress);
          header.compression.setValue(0);
          header.replyLength.setValue(decompress.length);
          newsBuff.write(header.getBytes(), newsHeaderSize);
          newsBuff.write(decompress, decompress.length);
          continue;
        }
        switch (header.msgType.getValueChar()) {
          case 'F':
            var now = DateTime.now();
            int date = DateTime(now.year, now.month, now.day)
                .difference(Dataconstants.exchStartDate)
                .inSeconds;
            var liveNewsList = List<NewsRecordModel>();
            var todayNews = List<NewsRecordModel>();
            var headerReplyCount = header.replyCount.getValue();
            for (var i = 0; i < headerReplyCount; i++) {
              var temp = Uint8List(liveNewsSize);
              newsBuff.read(temp, liveNewsSize);
              var record =
              NewsRecordModel(LiveSquakNewsRecord()..setFields(temp));
              ScripStaticModel model =
              Dataconstants.exchData[0].getStaticModel(record.nseCode);
              record.staticModel = model;
              if (!liveNewsList.contains(record)) liveNewsList.add(record);
              if (record.date >= date && !todayNews.contains(record))
                todayNews.add(record);
            }
            // //print("News got");
            Dataconstants.todayNews.addToNewsListBulk(todayNews);
            NewsDatabase.instance.addToNewsTableBulk(liveNewsList);
            break;
          case 'L':
            var todayNews = List<NewsRecordModel>();
            for (var i = 0; i < header.replyCount.getValue(); i++) {
              var temp = Uint8List(liveNewsSize);
              newsBuff.read(temp, liveNewsSize);
              var record =
              NewsRecordModel(LiveSquakNewsRecord()..setFields(temp));
              ScripStaticModel model =
              Dataconstants.exchData[0].getStaticModel(record.nseCode);
              record.staticModel = model;
              todayNews.add(record);
            }
            Dataconstants.todayNews.addToNewsList(todayNews);
            NewsDatabase.instance.addToNewsTableBulk(todayNews);
            break;
        }
      }
    } catch (e, s) {
      // //print("Exception $e");
      // //print("StackTrace $s");
    }
  }
}
