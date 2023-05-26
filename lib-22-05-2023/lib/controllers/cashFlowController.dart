import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/cashFlow.dart';

class CashFlowController extends GetxController{
  static var cashFlow = CashFlow().obs;
  static List<Datum> getCashFlowListItems = <Datum>[].obs;

  @override
  void onInit() {
    // getCashFlow();
    super.onInit();
  }

  Future<void> getCashFlow (coCode) async{

    var cashFlowVariable;
    cashFlowVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/CashFlow/6/s',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //pnlVariable = await ITS
    // Client.httpGet('https://cmdatafeed.jmfonline.in/api/ProftandLoss/6/s');
    //print("CashFlowVar : ${cashFlowVariable.runtimeType}");
    try {
      //print("Hello");

      cashFlow.value = cashFlowFromJson(cashFlowVariable);
      getCashFlowListItems.clear();

      for (var i = 0; i < cashFlow.value.data.length; i++) {
        getCashFlowListItems.add(cashFlow.value.data[i]);
      }

      // //print("List items: $getCashFlowListItems");

    } catch (e) {

    } finally {

    }
    return;

  }

}