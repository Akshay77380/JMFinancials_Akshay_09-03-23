import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/EventsSplits.dart';

class EventsSplitsController extends GetxController{
  static var eventsSplits = EventsSplits().obs;
  static List<Datum> getEventsSplitsListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBulkDeals();
    super.onInit();
  }

  Future<void> getEventsSplits() async{

    isLoading(true);
    var eventsSplitsVariable;
    eventsSplitsVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/corp-action-WKMonth-details/mon/split/100',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    try {

      eventsSplits.value = eventsSplitsFromJson(eventsSplitsVariable);
      getEventsSplitsListItems.clear();

      for (var i = 0; i < eventsSplits.value.data.length; i++) {
        getEventsSplitsListItems.add(eventsSplits.value.data[i]);
      }

    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;
  }

}