import 'dart:convert';

import 'package:get/get.dart';
import 'package:markets/util/Dataconstants.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/equitySip.dart';
import '../util/CommonFunctions.dart';

class EquitySipController extends GetxController{

  static var equitySip = EquitySip().obs;
  static List<Datum> getEquitySipListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {

    super.onInit();
  }

  Future<void> getEquitySip () async{

    var res1;
    isLoading(true);

    try {

      res1 = await ITSClient.httpGetWithHeader(
          'https://cmdatafeed.jmfonline.in/api/Equity-Top-performing-SIP/bse/Y1/bse_sensex/10',
          '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
      );

      //print("Hello");

      equitySip.value = equitySipFromJson(res1);
      getEquitySipListItems.clear();

      for (var i = 0; i < equitySip.value.data.length; i++) {
        getEquitySipListItems.add(equitySip.value.data[i]);
      }

    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}