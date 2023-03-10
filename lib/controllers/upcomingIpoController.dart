import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/upcomingIpo.dart';

class UpcomingIpoController extends GetxController{
  static var isLoading = true.obs;
  static var upComingIpo = UpcomingIpo().obs;
  static List<Datum> getUpcomingIpoListItems = <Datum>[].obs;

  @override
  void onInit() {
    // getUpcomingIpo();
    super.onInit();
  }

  Future<void> getUpcomingIpo () async{

    var upcomingIpoVariable;
    isLoading(true);
    upcomingIpoVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/forthcomingipo/NSE/IPO/10',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("Upcomingvar : ${upcomingIpoVariable.runtimeType}");
    try {
      //print("Hello");

      upComingIpo.value = upcomingIpoFromJson(upcomingIpoVariable);
      getUpcomingIpoListItems.clear();

      for (var i = 0; i < upComingIpo.value.data.length; i++) {
        getUpcomingIpoListItems.add(upComingIpo.value.data[i]);
      }

      // //print("List items: $getUpcomingIpoListItems");

    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}