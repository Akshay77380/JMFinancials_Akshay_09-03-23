import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/FiftyTwoWeekLow.dart';

class FiftyTwoWeekLowController extends GetxController{
  static var fiftyTwoWeekLow = FiftyTwoWeekLow().obs;
  static List<Datum> getFiftyTwoWeekLowListItems = <Datum>[].obs;

  @override
  void onInit() {
    getFiftyTwoWeekLow();
    super.onInit();
  }

  Future<void> getFiftyTwoWeekLow () async{

    var fiftyTwoWeekLowVariable;
    fiftyTwoWeekLowVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/FiftyTwoWeekLow/NSE/-/10',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${fiftyTwoWeekLowVariable.runtimeType}");
    try {
      //print("Hello");

      fiftyTwoWeekLow.value = fiftyTwoWeekLowFromJson(fiftyTwoWeekLowVariable);
      getFiftyTwoWeekLowListItems.clear();

      for (var i = 0; i < fiftyTwoWeekLow.value.data.length; i++) {
        getFiftyTwoWeekLowListItems.add(fiftyTwoWeekLow.value.data[i]);
      }

    } catch (e, s) {
      //print(e);
    } finally {

    }
    return;

  }

}