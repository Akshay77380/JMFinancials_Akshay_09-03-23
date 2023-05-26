import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/topHighestOI.dart';

class  TopHighestOIController extends GetxController{

  static var topHighestOI =  TopHighestOiModel().obs;
  static List<Datum> topHighestOiListItemsNifty = <Datum>[].obs;
  static List<Datum> topHighestOiListItemsBankNifty = <Datum>[].obs;
  static var addedValueNifty = 0.0.obs;
  static var addedValueBankNifty = 0.0.obs;
  static var isLoading = true.obs;

  @override
  void onInit() {
    // getBalanceSheet();
    super.onInit();
  }

  Future<void> getTopHighestOi() async{

    isLoading(true);
    var  topHighestOiVariable;
    topHighestOiVariable = await ITSClient.httpGetWithHeader(
        'http://cmdatafeed.jmfonline.in/api/FuturesHighOI',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //print( FiiDiiVariable);
    try {

      topHighestOI.value =  topHighestOiModelFromJson(topHighestOiVariable);
      topHighestOiListItemsNifty.clear();
      topHighestOiListItemsBankNifty.clear();

      for (var i = 0; i < topHighestOI.value.data.length; i++) {
        if(topHighestOI.value.data[i].symbol == "NIFTY     ") {
          topHighestOiListItemsNifty.add(topHighestOI.value.data[i]);
          addedValueNifty += topHighestOI.value.data[i].openInterest.toDouble();
        }if(topHighestOI.value.data[i].symbol == "BANKNIFTY ") {
          topHighestOiListItemsBankNifty.add(topHighestOI.value.data[i]);
          addedValueBankNifty += topHighestOI.value.data[i].openInterest.toDouble();
        }
      }

      topHighestOiListItemsNifty.sort((a,b) => int.parse(a.expDate.toString().split("-")[1]).compareTo(int.parse(b.expDate.toString().split("-")[1])));
      topHighestOiListItemsBankNifty.sort((a,b) => int.parse(a.expDate.toString().split("-")[1]).compareTo(int.parse(b.expDate.toString().split("-")[1])));

    } catch (e, s) {
      print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}