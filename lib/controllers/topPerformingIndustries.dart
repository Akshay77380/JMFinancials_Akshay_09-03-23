import 'package:get/get.dart';
import 'package:markets/util/Dataconstants.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/topPerformingIndustries.dart';
import '../util/CommonFunctions.dart';

class TopPerformingIndustriesController extends GetxController{

  static var topPerformingIndustries = TopPerformingIndustries().obs;
  static List<Datum> getTopPerformingIndustriesListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBankDetails();
    super.onInit();
  }

  Future<void> getTopPerformingIndustries () async{
    isLoading(true);

    try {

      var res1;

      res1 = await ITSClient.httpGetWithHeader(
          'https://cmdatafeed.jmfonline.in/api/Top-Performing-Industries/bse/10',
          '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
      );

      //print("Hello");

      topPerformingIndustries.value = topPerformingIndustriesFromJson(res1);
      getTopPerformingIndustriesListItems.clear();

      for (var i = 0; i < topPerformingIndustries.value.data.length; i++) {
        getTopPerformingIndustriesListItems.add(topPerformingIndustries.value.data[i]);
      }

    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}