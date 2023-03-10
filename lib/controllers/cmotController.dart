import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/cmot_get_quote.dart';

class CmotController extends GetxController {
  static var isLoading = true.obs;
  static var getQuoteDetails = GetQuoteDetails().obs;
  static List<Datum> getQuoteDetailsListItems = <Datum>[].obs;

  @override
  void onInit() {
    getCMOTS();
    super.onInit();
  }

  Future<void> getCMOTS() async {
    isLoading(true);
    var headers = {
      'Authorization':
      'bearer 9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef',
      'Content-Type': 'application/json'
    };

    var cmotVariable;
    cmotVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/GetQuoteDetails/6/bse',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef');

    //print("CMOT Variable: $cmotVariable");

    try {

      //print("Hello");
      getQuoteDetails.value = getQuoteDetailsFromJson(cmotVariable);
      getQuoteDetailsListItems.clear();

      for (var i = 0; i < getQuoteDetails.value.data.length; i++) {
        getQuoteDetailsListItems.add(getQuoteDetails.value.data[i]);
      }

    isLoading(false);
    } catch (e) {

      isLoading(false);
    } finally {
      isLoading(false);
    }
    return;
  }

}