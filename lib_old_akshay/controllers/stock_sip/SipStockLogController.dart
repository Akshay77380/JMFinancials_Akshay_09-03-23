import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../../model/stock_sip_model/stock_sip_model/StockSipLogModel.dart';
import '../../util/BrokerInfo.dart';
import '../../util/Dataconstants.dart';

class StockSipLogController extends GetxController {
  static var isLoading = true.obs;
  static var SipLogData = StockSipLogModel().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static List<Log> GetSipLogtData = <Log>[].obs;
  static RxDouble totalVal = 0.0.obs;

  @override
  void onInit() {
    // fetchGetSipLog();
    super.onInit();
  }

  Future<void> fetchGetSipLog({String InstId}) async {
    isLoading(true);

    var requestJson = {"ClientCode": Dataconstants.feUserID, "SessionToken": Dataconstants.loginData.data.jwtToken, "InstID": InstId};
    var response = await Dataconstants.itsClient.httpPost(BrokerInfo.mainUrl == BrokerInfo.UATURL ? "https://tradeapiuat.jmfonline.in/tools/Report/api/sip/Logs" : "https://tradeapi.jmfonline.in/tools/Report/api/sip/Logs", requestJson); //+ "api/Login"
    var responses = response.body;
    // String    response = await ITSClient.httpPost(BrokerInfo.sipMainUrlBase + "tools/Report/api/sip/FetchAll", requestJson);
    log("get SIP Log Response  => $responses");
    try {
      SipLogData.value = stockSipLogModelFromJson(responses);
      GetSipLogtData.clear();
      for (var i = 0; i < SipLogData.value.logs.length; i++) {
        GetSipLogtData.add(SipLogData.value.logs[i]);
      }
    } catch (e) {
      var jsons = json.decode(responses);
    } finally {
      isLoading(false);
    }
    return;
  }
}
