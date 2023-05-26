import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/blockDeals.dart';

class BlockDealsController extends GetxController{
  static var blockDeals = BlockDeals().obs;
  static List<Datum> getBlockDealsListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBlockDeals();
    super.onInit();
  }

  Future<void> getBlockDeals () async {

    isLoading(true);
    var blockDealsVariable;
    blockDealsVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/Block-Deals/bse/1-May-2022/15-jun-2022',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print("CashFlowVar : ${blockDealsVariable.runtimeType}");
    try {
      //print("Hello");

      blockDeals.value = blockDealsFromJson(blockDealsVariable);
      getBlockDealsListItems.clear();

      for (var i = 0; i < blockDeals.value.data.length; i++) {
        getBlockDealsListItems.add(blockDeals.value.data[i]);
      }

      // //print("List items: $getBlockDealsListItems");

    } catch (e) {

    } finally {
      isLoading(false);
    }
    return;
  }

}