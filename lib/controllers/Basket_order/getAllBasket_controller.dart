import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/basket_order/getAllBasket_model.dart';
import '../../util/BrokerInfo.dart';
import '../../util/Dataconstants.dart';


class GetAllBasketsController extends GetxController {
  static var isLoading = true.obs;
  static var BasketsData = GetAllBaskets().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static List<Datum> BasketListList = <Datum>[].obs;
  static List<Datum> BasketfilterList = <Datum>[].obs;
  static RxDouble totalVal = 0.0.obs;
  @override
  void onInit() {
    fetchBasketList();
    super.onInit();
  }
  Future<void> fetchBasketList() async {
    isLoading(true);
    http.Response response = await http.post(Uri.parse(BrokerInfo.mainUrl + "api/v2/GetAllBaskets"),
    headers: {
          'Content-type': 'application/json',
          'Authorization': "Bearer ${Dataconstants.loginData.data.jwtToken}"
        });;
    var responses = response.body;
    log("get all basket  => $responses");
    try {
      BasketListList.clear();
      BasketfilterList.clear();
      BasketsData.value=getAllBasketsFromJson(responses);
      BasketListList.addAll(BasketsData.value.data);
      BasketfilterList.addAll(BasketsData.value.data);
      // updateHoldingsBySearch();
      totalVal.value = 0.0;
    } catch (e) {
    } finally {
      isLoading(false);
    }
    return;
  }

  void updateHoldingsBySearch([String filterText = '']) {
    isLoading.value = true;
    if (filterText != '' && filterText.isNotEmpty) {
      BasketListList = BasketfilterList.where((element) => element.basketName.toLowerCase().contains(filterText.toLowerCase())).toList();
    }
    else {
      BasketListList = BasketfilterList;
    }
    isLoading.value = false;
  }

}
