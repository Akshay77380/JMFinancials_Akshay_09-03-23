import 'package:get/get.dart';
import 'package:markets/model/jmModel/mostActiveTurnover.dart';
import '../Connection/ISecITS/ITSClient.dart';

class MostActiveTurnOverController extends GetxController{
  static var mostActiveTurnover = MostActiveTurnOver().obs;
  static List<Datum> getMostActiveTurnOverDetailsListItems = <Datum>[].obs;
  static var isLoading = false.obs;

  @override
  void onInit() {
    // getMostActiveCall();
    super.onInit();
  }

  Future<void> getMostTurnOver () async{
    isLoading(true);
    var mostActiveTurnOverVariable;
    mostActiveTurnOverVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/MostActiveToppers/NSE/Nifty/Gain/6',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    try {
      //print("Hello");

      mostActiveTurnover.value = mostActiveTurnOverFromJson(mostActiveTurnOverVariable);
      getMostActiveTurnOverDetailsListItems.clear();

      for (var i = 0; i < mostActiveTurnover.value.data.length; i++) {
        getMostActiveTurnOverDetailsListItems.add(mostActiveTurnover.value.data[i]);
      }

      // //print("List items: $getMostActiveCallDetailsListItems");

    } catch (e) {
    } finally {
      isLoading(false);
    }

    return;

  }

}