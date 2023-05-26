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
        'https://cmdatafeed.jmfonline.in/api/Share-Holding-Pattern/${stockCode}',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef');

    try {
      shareHolding.value = shareHoldingFromJson(shareHoldingVariable);
      getShareHoldingDetailsListItems.clear();

      for (var i = 0; i < shareHolding.value.data.length; i++) {
        getShareHoldingDetailsListItems.add(shareHolding.value.data[i]);
      }

      // for(var i = 0 ; i < getShareHoldingDetailsListItems.length; i ++){
      //   getShareHoldingDetailsListItems.sort((a,b) => b[i]["YRC"].compareTo(a[i]["YRC"]));
      // }

    } catch (e, s) {
      //print(e);
    } finally {

    }
    return;
  }
}
