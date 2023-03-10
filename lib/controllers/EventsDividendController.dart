import 'package:get/get.dart';
import 'package:markets/model/jmModel/eventsDividend.dart';
import '../Connection/ISecITS/ITSClient.dart';

class EventsDividendController extends GetxController{
  static var eventsDividend = EventsDividend().obs;
  static List<Datum> getEventsDividendListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBulkDeals();
    super.onInit();
  }

  Future<void> getEventsDividend () async{

    isLoading(true);
    var eventsDividendVariable;
    eventsDividendVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/corp-action-WKMonth-details/mon/dividend/10',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    try {
      //print("Hello");

      eventsDividend.value = eventsDividendFromJson(eventsDividendVariable);
      getEventsDividendListItems.clear();

      for (var i = 0; i < eventsDividend.value.data.length; i++) {
        getEventsDividendListItems.add(eventsDividend.value.data[i]);
      }

      // //print("List items: $getBulkDealsListItems");
    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;
  }

}