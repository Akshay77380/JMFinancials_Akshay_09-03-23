import 'dart:convert';

import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/checkMarketModel.dart';
import '../util/Dataconstants.dart';

class CheckMarketController extends GetxController {
  static var isLoading = true.obs;
  static var checkMarket = CheckMarketModel().obs;
  static List<String> getChekcMarketListItems = <String>[].obs;
  static var res2;

  @override
  void onInit() {
    // getTopGainers;
    super.onInit();
  }

  Future<void> getCheckMarket() async {
    isLoading(true);
    var res;
    try {

      res = await Dataconstants.itsClient.httpPostWithHeaderNew(
          "https://tradeapiuat.jmfonline.in:9190/PayOut/checkMarketDays",
          {"token" : Dataconstants.loginData.data.jwtToken},
          Dataconstants.loginData.data.jwtToken
      );

      print(res.body.toString());

      res2 = jsonDecode(res.body.toString());

      Dataconstants.listOfStrings = res2["note"];

      print(res2["note"][0]);

      // for(var i = 0 ; i < res2["note"])

      // //print("link -- $link --- access Token -- $accessToken");

      // topGainersVariable = await ITSClient.httpGetWithHeader(link, accessToken);
      //
      // topGainers.value = topGainersFromJson(topGainersVariable);
      // getTopGainersListItems.clear();
      //
      // for (var i = 0; i < topGainers.value.data.length; i++) {
      //   getTopGainersListItems.add(topGainers.value.data[i]);
      // }

    } catch (e, s) {
      print("Error $e");
    } finally {
    }
    isLoading(false);
    return;
  }
}
