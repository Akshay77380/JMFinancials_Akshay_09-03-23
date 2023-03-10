
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/balanceSheet.dart';

class BalanceSheetController extends GetxController{
  static var balanceSheet = BalanceSheet().obs;
  static List<Datum> getBalanceSheetDetailsListItems = <Datum>[].obs;

  @override
  void onInit() {
    getBalanceSheet();
    super.onInit();
  }

  Future<void> getBalanceSheet () async{

    var pnlVariable;
    pnlVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/Balancesheet/6/s',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print(pnlVariable);
    try {
      //print("Hellol");

      balanceSheet.value = balanceSheetFromJson(pnlVariable);
      getBalanceSheetDetailsListItems.clear();

      for (var i = 0; i < balanceSheet.value.data.length; i++) {
        getBalanceSheetDetailsListItems.add(balanceSheet.value.data[i]);
      }

      // //print("List items: $getBalanceSheetDetailsListItems");

    } catch (e) {

    } finally {

    }
    return;

  }

}