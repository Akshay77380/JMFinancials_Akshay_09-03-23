
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/nseIndicesModel.dart';

class NseIndicesController extends GetxController{

  static var nseIndices = NseIndices().obs;
  static List<Datum> getNseIndicesListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBalanceSheet();
    super.onInit();
  }

  Future<void> getNseIndices () async{

    isLoading(true);
    var NseIndicesVariable;
    NseIndicesVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/BseNseIndices/nse',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print(NseIndicesVariable);
    try {

      nseIndices.value = nseIndicesFromJson(NseIndicesVariable);
      getNseIndicesListItems.clear();

      for (var i = 0; i < nseIndices.value.data.length; i++) {
        getNseIndicesListItems.add(nseIndices.value.data[i]);
      }

    }catch (e) {

    } finally {
      isLoading(false);
    }
    return;

  }

}