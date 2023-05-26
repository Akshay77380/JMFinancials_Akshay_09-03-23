import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/basket_order/getScripmFromBasket_model.dart';
import '../../util/BrokerInfo.dart';
import '../../util/Dataconstants.dart';


class GetScripFromBasketController extends GetxController {
  static var isLoading = true.obs;
  static var ScripFromBasketsData = GetScripFromBasket().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static List<Datum2> ScripListList = <Datum2>[].obs;
  static RxDouble totalVal = 0.0.obs;
  @override
  void onInit() {
    getScripmFromBasket();
    super.onInit();
  }

  Future<void> getScripmFromBasket({String basketId}) async {

    isLoading(true);
    var requestJson = {
      "basketId": basketId
    };
    http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl + "api/v2/GetScriptsFromBasket"),
        body: jsonEncode(requestJson),
        headers: {
          'Content-type': 'application/json',
          'Authorization': "Bearer ${Dataconstants.loginData.data.jwtToken}"
        });;
    var responses = response.body;
    log("get all basket  => $responses");
    try {
      ScripListList.clear();
      ScripFromBasketsData.value=getScripFromBasketFromJson(responses);
      ScripListList.addAll(ScripFromBasketsData.value.data);
      totalVal.value = 0.0;
    } catch (e) {
      // var jsons = json.decode(responses);
      print(e);
    } finally {
      isLoading(false);
    }
    return;

  }



}
