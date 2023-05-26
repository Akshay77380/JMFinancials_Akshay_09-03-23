import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/eventsDate.dart';

class EventsDateController extends GetxController{
  static var eventsDate = EventsDate().obs;
  static List<Datum> getEventsDateListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBlockDeals();
    super.onInit();
  }

  Future<void> getEventsDate () async{

    isLoading(true);
    var eventsDateVariable;
    eventsDateVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/Eventdatewisedetails/22-Sep-2021/BookCloser/100',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${eventsDateVariable.runtimeType}");
    try {

      //print("Hello");

      eventsDate.value = eventsDateFromJson(eventsDateVariable);
      getEventsDateListItems.clear();

      for (var i = 0; i < eventsDate.value.data.length; i++) {
        getEventsDateListItems.add(eventsDate.value.data[i]);
      }

      // //print("List items: $getBlockDealsListItems");

    } catch (e,s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;
  }

}