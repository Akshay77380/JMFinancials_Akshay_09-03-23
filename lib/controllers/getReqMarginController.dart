
import 'dart:convert';

import 'package:get/get.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/getReqmargin.dart';
import '../util/Dataconstants.dart';

class  GetRequiredMarginController extends GetxController{

  static var reqMargin =  GetrequiredMargin().obs;
  static var isLoading = true.obs;
  static var requiredMargin = ''.obs;
  static var hairCut = ''.obs;

  @override
  void onInit() {
    // getBalanceSheet();
    super.onInit();
  }

  Future<void> getRequiredMargin(requestJson) async{

    requiredMargin.value = '';
    isLoading(true);

    var decodedVal;
    var  reqMarginVariable;
    reqMarginVariable = await Dataconstants.itsClient.httpPostWithHeaderNew(
        'https://tradeapiuat.jmfonline.in:9190/api/v2/GetRequiredMargin',
        requestJson,
        Dataconstants.loginData.data.jwtToken
    );

    try {
      var decodedValue = json.decode(reqMarginVariable.body.toString());
      // reqMargin.value = getrequiredMarginFromJson(reqMarginVariable);
      // requiredMargin = reqMargin.value.data.requiredMargin;

      requiredMargin.value = decodedValue["data"]["RequiredMargin"];
      hairCut.value = decodedValue["data"]["HaircutPercentage"];

    } catch (e, s) {
      print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}