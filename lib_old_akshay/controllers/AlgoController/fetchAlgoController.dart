import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../../model/AlgoModels/fetchAlgo_Model.dart';
import '../../util/BrokerInfo.dart';
import '../../util/Dataconstants.dart';
import 'package:http/http.dart' as http;


class FetchAlgoController extends GetxController {
  static var isLoading = true.obs;
  static var fetchAlgo = FetchAlgo().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static List<ListItem> fetchAlgoLists = null;
  static RxDouble totalVal = 0.0.obs;

  @override
  void onInit() {
    fetchAlgoList();
    super.onInit();
  }

  Future<void> fetchAlgoList({String name}) async {
      isLoading(true);
      var url = "${BrokerInfo.algoUrl}/report/api/algo/AlgoList";
      // /api/algo/AlgoList
      // Request Body :
      // {
      //     "ClientCode":"AF468085",
      //     "SessionToken":"79785231",
      //     "APIVersion":2,
      //     "Source":"MOB"
      // }
      // var url = "${BrokerInfo.algoUrl}/report/api/algo/List";
      // var url = "$algoUrl:9193/api/instruction/AlgoInstructionReport";

      Map data = {
        "ClientCode":Dataconstants.feUserID,
        "SessionToken": Dataconstants.loginData.data.jwtToken,
        "APIVersion":BrokerInfo.algoVersion,
        "Source":"MOB"

        // "ClientCode": Dataconstants.internalFeUserID,
        // "SessionToken": Dataconstants.loginData.data.jwtToken
      };
      //encode Map to JSON
      var body = jsonEncode(data);
      //print("fetch algo api request => $body"
      // );
      var response = await http
          .post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body)
          .timeout(BrokerInfo.timeoutDuration);

      var responseBody= response.body.toString();

      var data2 = jsonDecode(response.body);
      var responses = response;
      //log("fetch report Response  => $data2");
      fetchAlgoLists = new List<ListItem>();
      try{
      if(response.statusCode==200){
        for (int i = 0; i < data2["ListItem"].length; i++) {
          fetchAlgoLists.add(ListItem.fromJson(data2["ListItem"][i]));
        }
      }
    }catch(e){
      //print(e);
    }
    finally {
      isLoading(false);
    }
    return;

  }

}
