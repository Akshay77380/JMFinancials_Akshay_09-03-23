import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/EventsBoardMeet.dart';

class BoardMeetController extends GetxController{
  static var eventsBoardMeet = EventsBoardMeet().obs;
  static List<Datum> getBoardMeetListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBulkDeals();
    super.onInit();
  }


  Future<void> getEventsBoardMeet() async{

    isLoading(true);
    var eventsBoardMeetVariable;
    eventsBoardMeetVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/Board-Meetings/bse',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    try {

      eventsBoardMeet.value = eventsBoardMeetFromJson(eventsBoardMeetVariable);
      getBoardMeetListItems.clear();

      for (var i = 0; i < eventsBoardMeet.value.data.length; i++) {
        getBoardMeetListItems.add(eventsBoardMeet.value.data[i]);
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