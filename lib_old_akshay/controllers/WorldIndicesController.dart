import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/WorldIndices.dart';

class WorldIndicesController extends GetxController {
  static var isLoading = true.obs;
  static var worldIndices = WorldIndices().obs;
  static List<Datum> getWorldIndicesListItems = <Datum>[].obs;

  @override
  void onInit() {
    // getWorldIndices();
    super.onInit();
  }

  Future<void> getWorldIndices() async {
    try {
      isLoading(true);
      var worldIndicesVariable;
      // var link = 'https://cmdatafeed.jmfonline.in/api/WorldIndices';
      var link = 'http://cmdatafeed.jmfonline.in/api/Global-Indices/SGX%20NIFTY';

      var accessToken = '9lRjr6IxdL_kOegjJmnnOafSx73sTqtFaVozg_EtU8cTpjTnLDbb0VQ3Y1J6UZdiQTwYvfU6SLjy9WnAUt4v9RXR13WcnnKayWEEZL_06xdR7_lTHszbYE4TATLP8yEy2a58q9JV8WqVdbUleaIeps6ae9rzODlAZekfxGmChoJ8JzHHgAcRsuLUQkYd7QyM4oVfXtHNRZBtSJYldNdVp0Hi1fzynB_g-HcKTJj36INtHEo0I3ttPZTBVeagrZ6CM8u7HNUZ_F-X8HxBb6Blk62-Pn8_qTMb01iFulJ-nQUBtdvmDURRqiOQaT17duef';
      // //print("link -- $link --- access Token -- $accessToken");
      worldIndicesVariable = await ITSClient.httpGetWithHeader(
          link, accessToken);

      //print("TopGainersVar : ${worldIndicesVariable.runtimeType}");

      worldIndices.value = worldIndicesFromJson(worldIndicesVariable);
      getWorldIndicesListItems.clear();

      for (var i = 0; i < worldIndices.value.data.length; i++) {
        getWorldIndicesListItems.add(worldIndices.value.data[i]);
      }

      // //print("List items: $getTopGainersListItems");
      isLoading(false);
    } catch (e, s) {
      //print("Error $e");
    } finally {
      isLoading(false);
    }
    return;
  }
}
