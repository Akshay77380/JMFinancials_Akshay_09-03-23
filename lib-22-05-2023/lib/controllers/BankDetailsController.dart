import 'package:get/get.dart';
import 'package:markets/model/jmModel/bankDetails.dart';
import 'package:markets/util/Dataconstants.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../util/CommonFunctions.dart';

class BankDetailsController extends GetxController{

  static var bankDetails = BankDetails().obs;
  static List<Datum> getBankDetailsListItems = <Datum>[].obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBankDetails();
    super.onInit();
  }

  Future<void> getBankDetails () async{
    isLoading(true);
    var bankDetailsVariable;
    // bankDetailsVariable = await ITSClient.httpGetWithHeader(
    //     'https://tradeapiuat.jmfonline.in:9190/payment/GetBankDetails',
    //     '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    // );
    try {
      var requestJson = {
        "FilterValue":  Dataconstants.feUserID,
        "token" : Dataconstants.fundstoken,
      };

      bankDetailsVariable = await CommonFunction.getBankDetails(requestJson);


      bankDetails.value = bankDetailsFromJson(bankDetailsVariable);
      getBankDetailsListItems.clear();

      for (var i = 0; i < bankDetails.value.data.length; i++) {
        getBankDetailsListItems.add(bankDetails.value.data[i]);
      }

    } catch (e, s) {
      print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}