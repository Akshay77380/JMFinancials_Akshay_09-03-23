import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/mostActiveCall.dart';

class MostActiveCallController extends GetxController{
  static var mostActiveCallVar = MostActiveCall().obs;
  static List<Datum> getMostActiveCallDetailsListItems = <Datum>[].obs;
  static var isLoading = false.obs;

  @override
  void onInit() {
    getMostActiveCall();
    super.onInit();
  }

  Future<void> getMostActiveCall () async{
    isLoading(true);

    var mostActiveCallVariable;
    mostActiveCallVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/OptionsMostActive/OPTIDX/C',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${mostActiveCallVariable.runtimeType}");
    try {
      //print("Hello");

      mostActiveCallVar.value = mostActiveCallFromJson(mostActiveCallVariable);
      getMostActiveCallDetailsListItems.clear();

      for (var i = 0; i < mostActiveCallVar.value.data.length; i++) {
        getMostActiveCallDetailsListItems.add(mostActiveCallVar.value.data[i]);
      }

      // //print("List items: $getMostActiveCallDetailsListItems");

    } catch (e) {
    } finally {
      isLoading(false);
    }

    return;

  }

}