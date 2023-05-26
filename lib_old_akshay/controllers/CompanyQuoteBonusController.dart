import 'package:get/get.dart';

import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/CompanyQuoteBonus.dart';

class CompanyQuoteBonusController extends GetxController{
  static var companyQuoteBonus = CompanyQuoteBonus().obs;
  static List<Datum> companyQuoteBonusItems = <Datum>[].obs;

  @override
  void onInit() {
    // getBalanceSheet();
    super.onInit();
  }

  Future<void> getCompanyQuoteBonus (coCode) async{

    var pnlVariable;

    pnlVariable = await ITSClient.httpGetWithHeader(
        'http://cmdatafeed.jmfonline.in/api/Bonus/${coCode}/all/all/100',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    try {

      companyQuoteBonus.value = companyQuoteBonusFromJson(pnlVariable);
      companyQuoteBonusItems.clear();

      for (var i = 0; i < companyQuoteBonus.value.data.length; i++) {
        companyQuoteBonusItems.add(companyQuoteBonus.value.data[i]);
      }

    } catch (e, s) {
      print(e);
    } finally {

    }
    return;

  }

}