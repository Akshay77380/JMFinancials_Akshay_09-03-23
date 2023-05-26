import 'dart:convert';

import 'package:get/get.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../model/jmModel/PortfolioModels/PortfolioHoldings.dart';
import '../../util/Dataconstants.dart';

class PortfolioHoldingController extends GetxController {

  static var holdings = PortfolioHoldings().obs;
  static List<TrPositionsCmGetDataResult2> getHoldingListItems = <TrPositionsCmGetDataResult2>[].obs;
  static List<String> sectors = <String>[];
  static var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getHoldings() async {
    isLoading(true);
    String rawData = "10116241:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);
    //print(bs64);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPositionsCM.svc/TrPositionsCMGetData?EncryptedParameters=10116241~~*~~*~~*~~*~~1.0.0.0~~*~~10116241",
        bs64
    );

    try {
      holdings.value = portfolioHoldingsFromJson(res1);
      getHoldingListItems = <TrPositionsCmGetDataResult2>[].obs;
      getHoldingListItems.clear();

      for (var i = 0; i < holdings.value.trPositionsCmGetDataResult.length-1; i++) {
        getHoldingListItems.add(holdings.value.trPositionsCmGetDataResult[i]);
        if(sectors.contains(getHoldingListItems[i].sector)){

        }else{
          sectors.add(holdings.value.trPositionsCmGetDataResult[i].sector);
        }
      }

    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;
  }

}