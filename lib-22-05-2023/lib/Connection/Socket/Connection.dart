import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'Client.dart';

class Connection {
  final String tag, ip;
  Socket socket;
  Client client;
  final int port;

  Connection({
    @required this.client,
    @required this.tag,
    @required this.ip,
    @required this.port,
  });

  void connect() async {
    try {
      // socket = await Socket.connect('3.61.161.135', 19304);
      socket = await Socket.connect(ip, port);
      socket.setOption(SocketOption.tcpNoDelay, true);
      socket.timeout(Duration(milliseconds: 100));
      socket.handleError((error) {
        if (client != null) client.onError(error.toString());
      });
      socket.listen(
        dataHandler,
        onError: errorHandler,
        onDone: client.onDisconnected,
      );
      if (client != null) client.onConnected();
    } catch (e) {
      if (client != null) client.onError(e.toString());
      // //print("this is eod connection error $e");
    }
  }

  void sendRequest(Uint8List req) {
    try {
      if (socket != null) {
        socket.add(req);
      }

    } on SocketException catch (s) {
      // //print(s);
    } catch (e) {
      // //print(e);
    }
  }

  void disconnect() async {
    try {
      if (socket != null) {
        await socket.close();
        socket.destroy();
        if (client != null) client.onDisconnected();
      }
    } on SocketException catch (s) {
      // //print(s);
    } catch (e) {
      // //print(e);
    }
  }

  void dataHandler(data) {
    try {
      // Logit.i(tag, data.toString()); //printing response
      if (data is Uint8List && client != null) {
        client.processReply(data);
      }
    } on SocketException catch (s) {
      // //print(s);
    } catch (e) {
      if (client != null) client.onError('');
      // //print(e);
    }
  }

  void errorHandler(error, StackTrace trace) async {
    try {
      //print("$tag socket error " + error.toString());
      await socket.close();
      socket.destroy();
      if (client != null) client.onError(error.toString());
    } on SocketException catch (s) {
      //print(s);
      if (client != null) client.onError(error.toString());
    } catch (e) {
      //print(e);
      if (client != null) client.onError(error.toString());
    }
  }

  void doneHandler() async {
    // //print('$tag done');
  }
}
