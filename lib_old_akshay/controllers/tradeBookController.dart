import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../model/jmModel/tradeBook.dart';
import '../util/BrokerInfo.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';

class TradeBookController extends GetxController {
  static var isLoading = true.obs;
  static var TradeBookList = TradeBook().obs;
  static List<tradebookDatum> tradeBookList = <tradebookDatum>[].obs;
  static var TradeBookLength = 0;

  @override
  void onInit() {
    // fetchTradeBook();
    super.onInit();
  }

  Future<void> fetchTradeBook() async {
    var requestJson = {};
    isLoading(true);
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "TradeBook", requestJson, Dataconstants.loginData.data.jwtToken);
    var responses = response.body.toString();
    try {
      var jsons = json.decode(responses);
      if (jsons['status'] == false) {
        if (jsons["emsg"].toString() != 'No Data') CommonFunction.showBasicToast(jsons["emsg"].toString());
      } else {
        tradeBookList.clear();
        TradeBookList.value = tradeBookFromJson(response.body.toString());
        TradeBookLength = TradeBookList.value.data.length;
        tradeBookList = TradeBookList.value.data;
        //log("trade book data => $responses");
      }
    } catch (e) {
      var jsons = json.decode(response.body.toString());
      // CommonFunction.showBasicToast(jsons["Message"].toString());
    } finally {
      isLoading(false);
    }
    return;
  }
}
