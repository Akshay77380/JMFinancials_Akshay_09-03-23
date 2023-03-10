import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../../model/AlgoModels/reportRunningAlgo_Model.dart';
import '../../util/BrokerInfo.dart';
import '../../util/Dataconstants.dart';
import 'package:http/http.dart' as http;


class RunningController extends GetxController {
  static var isLoading = true.obs;
  static var reportRunningAlgo = ReportRunningAlgo().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static List<ReportRunningAlgo> reportRunningAlgoLists = null;
  static RxDouble totalVal = 0.0.obs;
  @override
  void onInit() {
    fetchReportRunningAlgo();
    super.onInit();
  }
  Future<void> fetchReportRunningAlgo({String name}) async {
    isLoading(true);
      var url = "${BrokerInfo.algoUrl}/report/api/algo/AlgoReport";
      Map data = {
        "ClientCode": Dataconstants.feUserID,
        "SessionToken": Dataconstants.loginData.data.jwtToken,
        "InstState": 2
      };
      //encode Map to JSON
      var body = jsonEncode(data);
      //print("running algo api request => $body");
      var response = await http
          .post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body)
          .timeout(BrokerInfo.timeoutDuration);

      // var responseBody= response.body.toString();

      var data2 = jsonDecode(response.body);

      var responses = response;
      //log("running report Response  => $data2");
      reportRunningAlgoLists = new List<ReportRunningAlgo>();
      try{
      if(response.statusCode==200){
        for (int i = 0; i < data2.length; i++) {
          reportRunningAlgoLists.add(ReportRunningAlgo.fromJson(data2[i]));
        }
      }
    }catch(e){
      // var jsons = json.decode(responseBody);
      //print(e);
    }
    finally {
      isLoading(false);
    }
    return;

  }



}
