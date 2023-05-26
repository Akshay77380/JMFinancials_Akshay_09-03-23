import 'dart:convert';

import 'package:get/get.dart';
import 'package:markets/model/jmModel/cmot_profit_loss.dart';

import '../Connection/ISecITS/ITSClient.dart';

class ProfitAndLossController extends GetxController{
  static var profitAndLoss = ProfitAndLoss().obs;
  static List<Datum> getProfitAndLossDetailsListItems = <Datum>[].obs;
  static Map<String, double> getKeyValue = Map<String , double>();
  static var yearValues = [].obs;
  static var isLoading = false.obs;

  @override
  void onInit() {
    // getProfitAndLoss();
    super.onInit();
  }

  Future<void> getProfitAndLoss (coCode) async{

    var pnlVariable;
    pnlVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/ProftandLoss/6/s',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    try {

      profitAndLoss.value = profitAndLossFromJson(pnlVariable);
      getProfitAndLossDetailsListItems.clear();

      for (var i = 0; i < profitAndLoss.value.data.length; i++) {
        getProfitAndLossDetailsListItems.add(profitAndLoss.value.data[i]);
      }

      var jsonConvt = jsonDecode(pnlVariable);

      yearValues = jsonConvt["data"][0].keys.length;

    } catch (e, s) {
      print(e);
    } finally {
    }
    return;

  }

}