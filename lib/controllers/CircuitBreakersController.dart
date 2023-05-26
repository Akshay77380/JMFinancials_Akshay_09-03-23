import 'dart:convert';

import 'package:get/get.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/CircuitBreakers.dart';
import '../util/Dataconstants.dart';

class CircuitBreakersController extends GetxController {
  static var isLoading = true.obs;
  static var circuitElements = CircuitBreakersModel().obs;
  static List<int> getUpperCktListItems = <int>[].obs;
  static List<int> getLowerCktListItems = <int>[].obs;

  @override
  void onInit() {
    // getTopGainers;
    super.onInit();
  }

  Future<void> getCircuitBreakers() async {
    isLoading(true);
    try {
      var topGainersVariable;

      var requestJson = {
        "Exch": "N",
        "ExchType": "C"
      };

      topGainersVariable = await Dataconstants.itsClient.httpPostBigul(
          "https://tradeapi.jmfonline.in/chart/api/bcast/circuitbreakers",
          requestJson
      );

      print(topGainersVariable.body.toString());

      circuitElements.value = circuitBreakersModelFromJson(topGainersVariable.body.toString());
      getUpperCktListItems.clear();
      getLowerCktListItems.clear();

      for (var i = 0; i < circuitElements.value.lowerCircuitBreakers.length; i++) {
        getUpperCktListItems.add(circuitElements.value.lowerCircuitBreakers[i]);
      }

      for (var i = 0; i < circuitElements.value.upperCircuitBreakers.length; i++) {
        getLowerCktListItems.add(circuitElements.value.upperCircuitBreakers[i]);
      }

    } catch (e, s) {
      print("Error $e");
    } finally {
    }
    isLoading(false);
    return;
  }
}
