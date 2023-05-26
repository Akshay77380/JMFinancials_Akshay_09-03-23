import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/mostActiveFutures.dart';

class MostActiveFuturesController extends GetxController{
  static var mostActiveFutures = MostActiveFutures().obs;
  static List<Datum> getMostActiveFuturesDetailsListItems = <Datum>[].obs;
  static var isLoading = false.obs;

  @override
  void onInit() {
    getMostFutures();
    super.onInit();
  }

  Future<void> getMostFutures() async{

    isLoading(true);
    var mostActiveTurnOverVariable;
    mostActiveTurnOverVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/GetQuoteDerivatives/MAC/-/-',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${mostActiveTurnOverVariable.runtimeType}");
    try {

      //print("Hello");

      mostActiveFutures.value = mostActiveFuturesFromJson(mostActiveTurnOverVariable);
      getMostActiveFuturesDetailsListItems.clear();

      for (var i = 0; i < mostActiveFutures.value.data.length; i++) {
        getMostActiveFuturesDetailsListItems.add(mostActiveFutures.value.data[i]);
      }

      // //print("List items: $getMostActiveCallDetailsListItems");
    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}