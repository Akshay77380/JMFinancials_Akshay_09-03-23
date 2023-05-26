import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/CompanyQuoteRights.dart';

class CompanyQuoteRightsController extends GetxController{
  static var companyQuoteRights = CompanyQuoteRights().obs;
  static List<Datum> companyQuoteRightsItems = <Datum>[].obs;
  static var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getCompanyQuoteRights (coCode) async{

    var companyQuoteRightsVariable;
    isLoading(true);
    companyQuoteRightsVariable = await ITSClient.httpGetWithHeader(
        'http://cmdatafeed.jmfonline.in/api/Rights/${coCode}/all/all/100',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    try {

      companyQuoteRights.value = companyQuoteRightsFromJson(companyQuoteRightsVariable);
      companyQuoteRightsItems.clear();

      for (var i = 0; i < companyQuoteRights.value.data.length; i++) {
        companyQuoteRightsItems.add(companyQuoteRights.value.data[i]);
      }

    } catch (e, s) {
      print(e);
    } finally {
      isLoading(false);
    }
    return;
  }

}