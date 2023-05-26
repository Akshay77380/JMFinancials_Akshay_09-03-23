import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/mostActivePut.dart';

class MostActivePutController extends GetxController{
  static var mostActivePutVar = MostActivePut().obs;
  static List<Datum> getMostActivePutDetailsListItems = <Datum>[].obs;
  static var isLoading = false.obs;

  @override
  void onInit() {
    getMostActivePut();
    super.onInit();
  }

  Future<void> getMostActivePut () async{

    isLoading(true);
    var mostActivePutVariable;
    mostActivePutVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/OptionsMostActive/OPTIDX/P',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${mostActivePutVariable.runtimeType}");
    try {
      //print("Hello");

      mostActivePutVar.value = mostActivePutFromJson(mostActivePutVariable);
      getMostActivePutDetailsListItems.clear();

      for (var i = 0; i < mostActivePutVar.value.data.length; i++) {
        getMostActivePutDetailsListItems.add(mostActivePutVar.value.data[i]);
      }

      // //print("List items: $getMostActiveCallDetailsListItems");

    } catch (e) {
    } finally {
      isLoading(false);
    }

    return;

  }

}