import 'package:get/get.dart';
import 'package:markets/model/jmModel/cmot_profit_loss.dart';

import '../Connection/ISecITS/ITSClient.dart';

class ProfitAndLossController extends GetxController{
  static var profitAndLoss = ProfitAndLoss().obs;
  static List<Datum> getProfitAndLossDetailsListItems = <Datum>[].obs;

  @override
  void onInit() {
    getProfitAndLoss();
    super.onInit();
  }

  Future<void> getProfitAndLoss () async{

    var pnlVariable;
    pnlVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/ProftandLoss/6/s',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );
    //
    //
    //
    //
    // //print(pnlVariable);

    //pnlVariable = await ITSClient.httpGet('https://cmdatafeed.jmfonline.in/api/ProftandLoss/6/s');

    //print("${pnlVariable}");
    try {
      //print("Hellol");

      profitAndLoss.value = profitAndLossFromJson(pnlVariable);
      getProfitAndLossDetailsListItems.clear();

      for (var i = 0; i < profitAndLoss.value.data.length; i++) {
        getProfitAndLossDetailsListItems.add(profitAndLoss.value.data[i]);
      }

      // //print("List items: $getProfitAndLossDetailsListItems");

    } catch (e) {

    } finally {

    }
    return;

  }

}