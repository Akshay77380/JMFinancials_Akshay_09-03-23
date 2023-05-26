import 'dart:convert';
import 'package:get/get.dart';
import 'package:markets/util/Dataconstants.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/summaryModel.dart';
import '../model/jmModel/swotModel.dart';
import '../util/CommonFunctions.dart';

class SwotController extends GetxController{

  static var swot = SwotModel().obs;

  static List getStrength = [].obs;
  static List getWeakness = [].obs;
  static List getOpportunities = [].obs;
  static List getThreats = [].obs;

  static RxInt strengthCount = 0.obs;
  static RxInt weaknessCount = 0.obs;
  static RxInt opportunitiesCount = 0.obs;
  static RxInt threatsCount = 0.obs;



  static var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getSwot (scripName) async{

    var requestJson = {
      "tradingsymbol" : "${scripName}"
    };

    var res1;
    isLoading(true);

    try {
      res1 = await Dataconstants.itsClient.httpPostWithHeaderNew(
          "https://tradeapiuat.jmfonline.in:9190/api/v2/FundamentalSWOT",
          requestJson,
          Dataconstants.loginData.data.jwtToken
      );

      swot.value = swotModelFromJson(res1.body);
      getStrength.clear();
      getWeakness.clear();
      getOpportunities.clear();
      getThreats.clear();

      for (var i = 0; i < swot.value.data.strengths.length; i++) {
        getStrength.add(swot.value.data.strengths[i]);
      }

      for (var i = 0; i < swot.value.data.weaknesses.length; i++) {
        getWeakness.add(swot.value.data.weaknesses[i]);
      }

      for (var i = 0; i < swot.value.data.opportunities.length; i++) {
        getOpportunities.add(swot.value.data.opportunities[i]);
      }

      for (var i = 0; i < swot.value.data.threats.length; i++) {
        getThreats.add(swot.value.data.threats[i]);
      }

    } catch (e, s) {
      print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}