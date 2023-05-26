import 'package:get/get.dart';
import 'package:markets/model/jmModel/mostActive.dart';
import '../Connection/ISecITS/ITSClient.dart';

class MostActiveController extends GetxController{
  static var mostActiveVar = MostActive().obs;
  static List<Datum> getMostActiveDetailsListItems = <Datum>[].obs;

  @override
  void onInit() {
    // getMostActive();
    super.onInit();
  }

  Future<void> getMostActive () async{

    var mostActiveVariable;
    mostActiveVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/OptionsMostActive/OPTIDX/P',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${mostActiveVariable.runtimeType}");
    try {
      //print("Hello");

      mostActiveVar.value = mostActiveFromJson(mostActiveVariable);
      getMostActiveDetailsListItems.clear();

      for (var i = 0; i < mostActiveVar.value.data.length; i++) {
        getMostActiveDetailsListItems.add(mostActiveVar.value.data[i]);
      }

      // //print("List items: $getMostActiveDetailsListItems");

    } catch (e) {

    } finally {

    }
    return;

  }

}