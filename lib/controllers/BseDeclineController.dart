import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/BseDecline.dart';
import '../util/Dataconstants.dart';

class BseDeclineController extends GetxController{
  static var bseDecline = BseDecline().obs;
  static List<Datum> getBseDeclineListItems = <Datum>[].obs;
  static var isLoading = true.obs;
  static var bseDeclineLength = 0.obs;

  @override
  void onInit() {
    // getBlockDeals();
    super.onInit();
  }

  Future<void> getBseDecline () async {

    isLoading(true);
    var bseDeclineVariable;
    bseDeclineVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/advancesdeclinesdetails/BSE/bse_Sensex/D',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${bseDeclineVariable.runtimeType}");
    try {
      //print("Hello");

      bseDecline.value = bseDeclineFromJson(bseDeclineVariable);
      getBseDeclineListItems.clear();

      bseDeclineLength.value = bseDecline.value.data.length;

    } catch (e, s) {
        //print(e);
    } finally {
      isLoading(false);
    }
    return;
  }

}