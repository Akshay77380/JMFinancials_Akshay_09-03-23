import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/ipoRecentListing.dart';

class RecentListingController extends GetxController{
  static var isLoading = true.obs;
  static var recentListing = IpoRecentListing().obs;
  static List<Datum> getRecentListingDetailListItems = <Datum>[].obs;

  @override
  void onInit() {
    // getIpoRecentListing();
    super.onInit();
  }

  Future<void> getIpoRecentListing () async{

    var recentListingVariable;
    isLoading(true);
    recentListingVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/Newlisting/bse/10',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //pnlVariable = await ITSClient.httpGet('https://cmdatafeed.jmfonline.in/api/ProftandLoss/6/s');
    //print("RecentListing : ${recentListingVariable.runtimeType}");
    try {
      //print("Hello");

      recentListing.value = ipoRecentListingFromJson(recentListingVariable);
      getRecentListingDetailListItems.clear();

      for (var i = 0; i < recentListing.value.data.length; i++) {
        getRecentListingDetailListItems.add(recentListing.value.data[i]);
      }

      // //print("List items: $getRecentListingDetailListItems");

    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}