
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/FiiDiiModel.dart';

class  FiiDiiController extends GetxController{

  static var fiiDii =  FiiDiiCash().obs;
  static List<Datum> getFiiDiiListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBalanceSheet();
    super.onInit();
  }

  Future<void> getFiiDii() async{

    isLoading(true);
    var  FiiDiiVariable;
     FiiDiiVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/FiiDii-DailyEOD',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print( FiiDiiVariable);
    try {

       fiiDii.value =  fiiDiiCashFromJson( FiiDiiVariable);
      getFiiDiiListItems.clear();

      for (var i = 0; i <  fiiDii.value.data.length; i++) {
        getFiiDiiListItems.add(fiiDii.value.data[i]);
      }

      // //print("List items: $getBalanceSheetDetailsListItems");

    } catch (e) {

    } finally {
      isLoading(false);
    }
    return;

  }

}