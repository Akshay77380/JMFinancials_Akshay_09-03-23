import 'dart:convert';

import 'package:get/get.dart';
import 'package:markets/util/Dataconstants.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../model/jmModel/summaryModel.dart';
import '../../util/CommonFunctions.dart';

class SummaryController extends GetxController{

  static var summaryBackOffice = SummaryApi().obs;
  static List<TrPositionsCmGetDataResult> getSummaryDetailListItems = <TrPositionsCmGetDataResult>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getSummaryApi () async{

    var res1;
    isLoading(true);
    // bankDetailsVariable = await ITSClient.httpGetWithHeader(
    //     'https://tradeapiuat.jmfonline.in:9190/payment/GetBankDetails',
    //     '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    // );

    try {
      String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
      String bs64 = base64.encode(rawData.codeUnits);
      //print(bs64);

      res1 = await ITSClient.httpGetDpHoldings(
          "https://mobilepms.jmfonline.in/TrPositionsCM.svc/TrPositionsCMGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}"
          ,bs64
      );
      print("summaryDetails $res1");
      summaryBackOffice.value = summaryApiFromJson(res1);
      getSummaryDetailListItems = <TrPositionsCmGetDataResult>[].obs;
      getSummaryDetailListItems.clear();

      for (var i = 0; i < summaryBackOffice.value.trPositionsCmGetDataResult.length; i++) {
        getSummaryDetailListItems.add(summaryBackOffice.value.trPositionsCmGetDataResult[i]);
      }


    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}