import 'package:get/get.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/MostActiveVolume.dart';

class MostActiveVolumeController extends GetxController{

  static var mostActiveVolume = MostActiveVolume().obs;
  static List<Datum> getMostActiveVolumeListItems = <Datum>[].obs;
  static var isLoading = false.obs;

  @override
  void onInit() {
    // getMostActiveVolume();
    super.onInit();
  }

  Future<void> getMostActiveVolume (nse, nifty) async{

    isLoading(true);
    var mostActiveVolumeVariable;
    mostActiveVolumeVariable = await ITSClient.httpGetWithHeader(
        'https://cmdatafeed.jmfonline.in/api/MostActiveToppers/${nse}/${nifty}/Gain/100',
        '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef'
    );

    try {

      mostActiveVolume.value = mostActiveVolumeFromJson(mostActiveVolumeVariable);
      getMostActiveVolumeListItems.clear();

      for (var i = 0; i < mostActiveVolume.value.data.length; i++) {
        getMostActiveVolumeListItems.add(mostActiveVolume.value.data[i]);
      }

    } catch (e,s) {
        //print(e);
    } finally {
      isLoading(false);
    }
    return;

  }

}