import 'dart:typed_data';

abstract class Client {
  void connect();
  void onConnected();
  void disconnect();
  void onDisconnected();
  void onError(String error);
  void processReply(Uint8List response);
}
