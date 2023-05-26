import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/FiftyTwoWeekLow.dart';

class FiftyTwoWeekHighController extends GetxController{
  static var fiftyTwoWeekHigh = FiftyTwoWeekLow().obs;
  static List<Datum> getFiftyTwoWeekHighListItems = <Datum>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getFiftyTwoWeekHigh (nse) async{

    var fiftyTwoWeekHighVariable;
    fiftyTwoWeekHighVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/FiftyTwoWeekHigh/${nse}/-/10',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${fiftyTwoWeekHighVariable.runtimeType}");
    try {
      //print("Hello");

      fiftyTwoWeekHigh.value = fiftyTwoWeekLowFromJson(fiftyTwoWeekHighVariable);
      getFiftyTwoWeekHighListItems.clear();

      for (var i = 0; i < fiftyTwoWeekHigh.value.data.length; i++) {
        getFiftyTwoWeekHighListItems.add(fiftyTwoWeekHigh.value.data[i]);
      }

    } catch (e, s) {
      //print(e);
    } finally {

    }
    return;

  }

}