import 'dart:developer';

import 'package:get/get.dart';
import 'package:markets/model/jmModel/cmot_profit_loss.dart';
import 'package:markets/model/jmModel/shareHolding.dart';

import '../Connection/ISecITS/ITSClient.dart';

class ShareHoldingController extends GetxController {
  static var shareHolding = ShareHolding().obs;

  static List<Map<String, dynamic>> getShareHoldingDetailsListItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    getShareHoldings;
    super.onInit();
  }

  Future<void> getShareHoldings(stockCode) async {
    var shareHoldingVariable;
    shareHoldingVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/Share-Holding-Pattern/6',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef');

    //print(shareHoldingVariable);

    try {
      // //print("Hellol");

      shareHolding.value = shareHoldingFromJson(shareHoldingVariable);
      getShareHoldingDetailsListItems.clear();

      // //print("ShareHolding Value: ${shareHolding.value.data[0]}");
      for (var i = 0; i < shareHolding.value.data.length; i++) {
        getShareHoldingDetailsListItems.add(shareHolding.value.data[i]);
      }

      //log("List items shareHoldings: $getShareHoldingDetailsListItems");
    } catch (e, s) {
      //print(e);
    } finally {

    }
    return;
  }
}
