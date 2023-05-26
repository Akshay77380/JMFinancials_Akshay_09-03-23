import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:markets/model/jmModel/DecreaseInOi.dart';
import '../Connection/ISecITS/ITSClient.dart';

class  DecreaseInOiController extends GetxController{

  static var decreaseInOi =  DecreaseInOi().obs;
  static List<Datum> decreaseInOiItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBalanceSheet();
    super.onInit();
  }

  Future<void> getDecreaseinOi() async{

    isLoading(true);
    var decreaseInOi;
    decreaseInOi = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/OptionsDeacreaseOI',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print( FiiDiiVariable);
    try {

      decreaseInOi.value =  decreaseInOiFromJson(decreaseInOi);
      decreaseInOiItems.clear();

      for (var i = 0; i <  decreaseInOi.value.data.length; i++) {
        decreaseInOiItems.add(decreaseInOi.value.data[i]);
      }

    } catch (e, s) {
      print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}