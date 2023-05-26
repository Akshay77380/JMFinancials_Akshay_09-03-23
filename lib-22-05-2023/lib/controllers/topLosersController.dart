import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/topLosers.dart';

class TopLosersController extends GetxController {
  static var isLoading = true.obs;
  static var topLosers = TopLosers().obs;

  static List<Datum> getTopLosersListItems = <Datum>[].obs;

  @override
  void onInit() {
    // getTopLosers;
    super.onInit();
  }

  Future<void> getTopLosers(nse, nifty, duration) async {
    isLoading(true);
    var topLosersVariable;
    topLosersVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/losers/${nse}/${nifty}/$duration/100',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef');

    //pnlVariable = await ITSClient.httpGet('https://cmdatafeed.jmfonline.in/api/ProftandLoss/6/s');
    //print("TopLosersVar : ${topLosersVariable.runtimeType}");
    try {
      //print("Hello");

      topLosers.value = topLosersFromJson(topLosersVariable);
      getTopLosersListItems.clear();

      for (var i = 0; i < topLosers.value.data.length; i++) {
        getTopLosersListItems.add(topLosers.value.data[i]);
      }

      // //print("List items: $getTopLosersListItems");
    } catch (e) {
    } finally {}
    isLoading(false);
    return;
  }
}
