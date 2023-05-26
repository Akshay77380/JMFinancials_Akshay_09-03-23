import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/OpenIpoModel.dart';

class OpenIpoController extends GetxController{
  static var isLoading = true.obs;
  static var ipo = OpenIpo().obs;
  static List<Datum> getIpoDetailListItems = <Datum>[].obs;

  @override
  void onInit() {
    // getOpenIpo();
    super.onInit();
  }

  Future<void> getOpenIpo() async{

    var IpoVariable;
    isLoading(true);
    IpoVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/OpenIssues/NSE/IPO/10',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    //pnlVariable = await ITSClient.httpGet('https://cmdatafeed.jmfonline.in/api/ProftandLoss/6/s');
    //print("TopLosersVar : ${IpoVariable.runtimeType}");
    try {
      //print("Hello");

      ipo.value = openIpoFromJson(IpoVariable);
      getIpoDetailListItems.clear();

      for (var i = 0; i < ipo.value.data.length; i++) {
        getIpoDetailListItems.add(ipo.value.data[i]);
      }

      // //print("List items: $getIpoDetailListItems");

    } catch (e, s) {
      //print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}