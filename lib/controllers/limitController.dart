import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:markets/model/jmModel/limit.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../util/BrokerInfo.dart';
import '../util/Dataconstants.dart';

class LimitController extends GetxController {
  static var isLoading = true.obs;
  static var limit = Limit().obs;
  static var limitData = LimitData().obs;

  Future<void> getLimitsData() async {
    isLoading(true);
    var responses = await CommonFunction.getLimits();
    var jsons = json.decode(responses);
    try {
      if (jsons['status'] == true) {
        limit.value = limitFromJson(responses);
        if (limit.value.status == true) {
          limitData.value = limit.value.data;
        }
        // //log("Order book data => $limitData");
        // log('Order History: ${orderHistoryListItems}');
      } else
        CommonFunction.showBasicToast(jsons["emsg"].toString());
    } catch (e) {
      CommonFunction.showBasicToast(jsons["data"].toString());
    } finally {}
    isLoading(false);
    return;
  }
}
