import 'dart:convert';

import 'package:get/get.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../model/jmModel/PortfolioModels/PortfolioDpHoldings.dart';
import '../../util/Dataconstants.dart';

class DpHoldingController extends GetxController {

  static var dpHoldings = DpHoldings().obs;
  static List<Datum> getDpHoldingListItems = <Datum>[].obs;

  static var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getDpHoldings() async {
    isLoading(true);
    String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);
    //print(bs64);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/DPHoldings.svc/DPHoldingsGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}",
        bs64
    );

    //print(res1);
    try {
      dpHoldings.value = dpHoldingsFromJson(res1);
      getDpHoldingListItems.clear();

      for (var i = 0; i <
          dpHoldings.value.dpHoldingsGetDataResult.length; i++) {
        getDpHoldingListItems.add(
            dpHoldings.value.dpHoldingsGetDataResult[i]);
      }
    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;
  }

}