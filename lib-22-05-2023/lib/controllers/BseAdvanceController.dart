import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/BseAdvance.dart';
import '../util/Dataconstants.dart';

class BseAdvanceController extends GetxController{
  static var bseAdvance = BseAdvance().obs;
  static List<Datum> getBseAdvanceListItems = <Datum>[].obs;
  static var isLoading = true.obs;
  static var bseAdvanceLength = 0.obs;

  @override
  void onInit() {
    // getBlockDeals();
    super.onInit();
  }

  Future<void> getBseAdvance () async {

    isLoading(true);
    var bseAdvanceVariable;
    bseAdvanceVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/advancesdeclinesdetails/BSE/bse_Sensex/A',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${bseAdvanceVariable.runtimeType}");
    try {
      //print("Hello");

      bseAdvance.value = bseAdvanceFromJson(bseAdvanceVariable);
      getBseAdvanceListItems.clear();

      bseAdvanceLength.value = bseAdvance.value.data.length;

      // //print("List items: $getBlockDealsListItems");

    } catch (e) {

    } finally {
      isLoading(false);
    }
    return;
  }

}