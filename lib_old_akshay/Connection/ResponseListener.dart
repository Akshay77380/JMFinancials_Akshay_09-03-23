abstract class ResponseListener {
  void onResponseReceieved(String resp, int type);

  void onErrorReceived(String error, int type);
}
