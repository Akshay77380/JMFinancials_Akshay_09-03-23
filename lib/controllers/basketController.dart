import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:markets/util/BrokerInfo.dart';
import '../model/jmModel/basket.dart';
import '../util/Dataconstants.dart';

class BasketController extends GetxController {
  static var isLoading = true.obs, isHoldingSearch = false.obs;
  static var BasketDatas = BasketData().obs;
  static List<BasketDatum> BasketList = <BasketDatum>[].obs;

  @override
  void onInit() {
    fetchBasket();
    super.onInit();
  }

  Future<void> fetchBasket() async {
    var requestJson = {
      "LoginID": Dataconstants.feUserID,
      "Operation": "SELECT"
    };
    isLoading(true);
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(
        BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "Basket",
        requestJson,
        Dataconstants.loginData.data.jwtToken);
    var responses = response.body.toString();
    try {
      BasketList = [];
      BasketDatas.value = basketDataFromJson(responses);
      BasketList.addAll(BasketDatas.value.data);
      //log("basket data => $responses");
    } catch (e) {
      var jsons = json.decode(responses);
      // CommonFunction.showBasicToast(jsons["message"].toString());
    } finally {
      isLoading(false);
    }
    return;
  }
}
