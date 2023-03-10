import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../model/AlgoModels/reportFinishedAlgo_model.dart';
import '../../util/BrokerInfo.dart';
import '../../util/Dataconstants.dart';


class FinishedController extends GetxController {
  static var isLoading = true.obs;
  static var reportFinishedAlgo = ReportFinishedAlgo().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static List<ReportFinishedAlgo> reportFinishedAlgoLists = null;
  static RxDouble totalVal = 0.0.obs;
  @override
  void onInit() {
    fetchReportFinishedAlgo();
    super.onInit();
  }
  Future<void> fetchReportFinishedAlgo({String name}) async {


    var url = "${BrokerInfo.algoUrl}/report/api/algo/AlgoReport";
    Map data = {
      "ClientCode": Dataconstants.feUserID,
      "SessionToken": Dataconstants.loginData.data.jwtToken,
      "InstState": 3
    };
    //encode Map to JSON
    var body = jsonEncode(data);
    //print("report finished algo api request => $body");
    var response = await http
        .post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body)
        .timeout(BrokerInfo.timeoutDuration);
   var responseBody= response.body.toString();
    var data2 = jsonDecode(response.body);
    var responses = response;
    //log("Finished report Response  => $data2");
    reportFinishedAlgoLists = new List<ReportFinishedAlgo>();



    try {
      if(response.statusCode==200){
        for (int i = 0; i < data2.length; i++) {
          reportFinishedAlgoLists.add(ReportFinishedAlgo.fromJson(data2[i]));
        }
      }


      totalVal.value = 0.0;
    } catch (e) {
      var jsons = json.decode(responseBody);
    } finally {
      isLoading(false);
    }
    return;

  }



}
