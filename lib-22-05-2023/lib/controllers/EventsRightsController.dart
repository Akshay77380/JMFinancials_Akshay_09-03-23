import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/EventsRights.dart';

class EventsRightsController extends GetxController{
  static var eventsRights = EventsRights().obs;
  static List<Datum> getEventsRightsListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBulkDeals();
    super.onInit();
  }

  Future<void> getEventsRights() async{

    isLoading(true);
    var eventsRightsVariable;
    eventsRightsVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/Rights/6263/all/all/100',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    try {

      eventsRights.value = eventsRightsFromJson(eventsRightsVariable);
      getEventsRightsListItems.clear();

      for (var i = 0; i < eventsRights.value.data.length; i++) {
        getEventsRightsListItems.add(eventsRights.value.data[i]);
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