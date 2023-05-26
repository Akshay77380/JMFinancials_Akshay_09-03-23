import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/OiLosers.dart';

class OiLosersController extends GetxController{
  static var oiLosers = OiLosers().obs;
  static List<Datum> getOiLosersDetailsListItems = <Datum>[].obs;

  @override
  void onInit() {
    // getOiLosers();
    super.onInit();
  }

  Future<void> getOiLosers  () async{

    var oiLosersVariable;
    oiLosersVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/FuturesLowOI',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${oiLosersVariable.runtimeType}");
    try {
      //print("Hello");

      oiLosers.value = oiLosersFromJson(oiLosersVariable);
      getOiLosersDetailsListItems.clear();

      for (var i = 0; i < oiLosers.value.data.length; i++) {
        getOiLosersDetailsListItems.add(oiLosers.value.data[i]);
      }

    } catch (e, s) {
      //print(e);
    } finally {

    }
    return;

  }

}