import 'dart:convert';

import 'package:get/get.dart';
import 'package:markets/model/jmModel/portfolioEquityModel.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../util/Dataconstants.dart';

class PortfolioEquityController extends GetxController {

  static var portfolioEquity = PortfolioEquity().obs;
  static List<TrPositionsCmDetailGetDataResult> getPortfolioEquityListItems = <TrPositionsCmDetailGetDataResult>[].obs;
  static List<String> sectors = <String>[];

  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBalanceSheet();
    super.onInit();
  }

  Future<void> getPortfolioEquity() async {
    isLoading(true);
    String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);
    //print(bs64);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPositionsCMDetail.svc/TrPositionsCMDetailGetData?EncryptedParameters=${Dataconstants
         .feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}",
        bs64
    );

    //print(res1);
    try {
      portfolioEquity.value = portfolioEquityFromJson(res1);
      getPortfolioEquityListItems.clear();

      for (var i = 0; i <
          portfolioEquity.value.trPositionsCmDetailGetDataResult.length; i++) {
        getPortfolioEquityListItems.add(
            portfolioEquity.value.trPositionsCmDetailGetDataResult[i]);
      }
    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;
  }

}