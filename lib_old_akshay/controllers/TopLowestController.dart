import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/topLowestOi.dart';

class  TopLowestOIController extends GetxController{

  static var topLowestOI =  TopLowestOiModel().obs;
  static List<Datum> topLowestOiListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBalanceSheet();
    super.onInit();
  }

  Future<void> getTopLowestOi() async{

    isLoading(true);
    var  topLowestOiVariable;
    topLowestOiVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/FuturesLowOI',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print( FiiDiiVariable);
    try {

      topLowestOI.value =  topLowestOiModelFromJson(topLowestOiVariable);
      topLowestOiListItems.clear();

      for (var i = 0; i <  topLowestOI.value.data.length; i++) {
        topLowestOiListItems.add(topLowestOI.value.data[i]);
      }

      // //print("List items: $getBalanceSheetDetailsListItems");

    } catch (e, s) {
      print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}