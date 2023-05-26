import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/jmModel/order_history.dart';
import '../util/BrokerInfo.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';

class OrderHistoryController extends GetxController{
  static var isLoading = true.obs;

  static var orderHistory = OrderHistoryModel().obs;
  static List<OrderHistoryDatum> orderHistoryListItems = <OrderHistoryDatum>[].obs;

  Future<void> fetchOrderHistory(orderid) async {
    // isLoading(true);
    var requestJson = {
      "orderId": orderid
    };
    //print('Dataconstants.loginData.data.jwtToken---${Dataconstants.loginData.data.jwtToken}');
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(
        BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "OrderHistory",
        requestJson,
        Dataconstants.loginData.data.jwtToken);
    // http.Response response = await Dataconstants.itsClient.httpPostWithHeader(
    //     BrokerInfo.mainUrl + "api/OrderHistory",
    //     requestJson,
    //     Dataconstants.loginData.data.jwtToken);
    var responses = response.body.toString();
    try {
      var jsons = json.decode(responses);
      if (jsons['status'] == false) {
        CommonFunction.showBasicToast(jsons["emsg"].toString());
      } else {
        orderHistory.value = orderHistoryModelFromJson(responses);
        orderHistoryListItems.clear();

        for (var i = 0; i < orderHistory.value.data.length; i++) {
          orderHistoryListItems.add(orderHistory.value.data[i]);
        }
        //log("Order history data => $responses");
        isLoading(false);
      }
    } catch (e) {
      var jsons = json.decode(responses);
      // CommonFunction.showBasicToast(jsons["message"].toString());
    } finally {
      isLoading(false);
    }
    return;
  }

}