import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../../model/AlgoModels/AlgoLogModel.dart';
import '../../util/BrokerInfo.dart';
import '../../util/Dataconstants.dart';
import 'package:http/http.dart' as http;


class AlgoLogController extends GetxController {
  static var isLoading = true.obs;
  static var AlgoLogDetail = AlgoLogModel().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static List<AlgoLogModel> AlgoLogLists = null;
  static RxDouble totalVal = 0.0.obs;
  @override
  void onInit() {
    fetchAlgoLogDetail();
    super.onInit();
  }
  Future<void> fetchAlgoLogDetail({int insState}) async {


    isLoading(true);

    var url = "${BrokerInfo.algoUrl}/report/api/algo/AlgoLog";
    Map data = {
      "ClientCode": Dataconstants.feUserID,
      "SessionToken": Dataconstants.loginData.data.jwtToken,
      "InstID": insState
    };
    //encode Map to JSON
    var body = jsonEncode(data);
    //print("algo log api request => $body");
    var response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body).timeout(BrokerInfo.timeoutDuration);
    var responseBody = response.body.toString();

    var data2 = jsonDecode(response.body);
    var responses = response;
    //log("algo log api Response  => $data2");

    // AlgoLogLists = new List<AlgoLogModel>();
    try{
      if(response.statusCode==200){


          Dataconstants.algoLogModel = AlgoLogModel.fromJson(data2);

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
