import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/OiGainers.dart';

class OiGainersController extends GetxController{
  static var oiGainers = OiGainers().obs;
  static List<Datum> getOiGainersDetailsListItems = <Datum>[].obs;

  @override
  void onInit() {
    getOiGainers();
    super.onInit();
  }

  Future<void> getOiGainers  () async{

    var oiGainersVariable;
    oiGainersVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/FuturesHighOI',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${oiGainersVariable.runtimeType}");
    try {
      //print("Hello");

      oiGainers.value = oiGainersFromJson(oiGainersVariable);
      getOiGainersDetailsListItems.clear();

      for (var i = 0; i < oiGainers.value.data.length; i++) {
        getOiGainersDetailsListItems.add(oiGainers.value.data[i]);
      }

    } catch (e, s) {
      //print(e);
    } finally {

    }
    return;

  }

}