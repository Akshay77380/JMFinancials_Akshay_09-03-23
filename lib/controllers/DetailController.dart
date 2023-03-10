import 'dart:convert';

import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/DetailModel.dart';
import '../util/Dataconstants.dart';

class DetailsControlller extends GetxController {
  static var isLoading = true.obs;
  static var detail = Detail().obs;
  static List<TrPositionsCmDetailGetDataResult> getDetailResultListItems =
      <TrPositionsCmDetailGetDataResult>[].obs;
  static var getYears = [].obs;

  @override
  void onInit() {
    // getIpoRecentListing();
    super.onInit();
  }

  Future<void> getDetailResult() async {

    var res1;
    isLoading(true);
    String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);
    //print(bs64);

    res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPositionsCMDetail.svc/TrPositionsCMDetailGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}",
        bs64);

    //print("RecentListing : ${res1.runtimeType}");
    try {

      detail.value = detailFromJson(res1);
      getDetailResultListItems.clear();
      getYears.clear();

      for (var i = 0; i < detail.value.trPositionsCmDetailGetDataResult.length; i++) {
        getDetailResultListItems.add(detail.value.trPositionsCmDetailGetDataResult[i]);
        getYears.add(detail.value.trPositionsCmDetailGetDataResult[i].tradeDate.substring(0,4));
      }

    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;
  }
}
