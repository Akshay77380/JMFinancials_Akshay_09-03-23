import 'package:get/get.dart';
import 'package:markets/model/jmModel/bulkDeals.dart';
import '../Connection/ISecITS/ITSClient.dart';

class BulkDealsController extends GetxController{
  static var bulkDeals = BulkDeals().obs;
  static List<Datum> getBulkDealsListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBulkDeals();
    super.onInit();
  }

  Future<void> getBulkDeals () async{

    isLoading(true);
    var bulkDealsVariable;
    bulkDealsVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/Bulk-Deals/bse/1-May-2022/15-jun-2022',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${bulkDealsVariable.runtimeType}");
    try {
      //print("Hello");

      bulkDeals.value = bulkDealsFromJson(bulkDealsVariable);
      getBulkDealsListItems.clear();

      for (var i = 0; i < bulkDeals.value.data.length; i++) {
        getBulkDealsListItems.add(bulkDeals.value.data[i]);
      }

      // //print("List items: $getBulkDealsListItems");
    } catch (e) {
    } finally {
      isLoading(false);
    }
    return;
  }

}