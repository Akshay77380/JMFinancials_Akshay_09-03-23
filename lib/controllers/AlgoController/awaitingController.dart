import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:markets/model/AlgoModels/reportAlgo_Model.dart';
import '../../util/BrokerInfo.dart';
import '../../util/Dataconstants.dart';
import 'package:http/http.dart' as http;


class AwaitingController extends GetxController {
  static var isLoading = true.obs;
  static var reportAwaitingAlgo = ReportAlgo().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static List<ReportAlgo> reportAwaitingAlgoLists = null;
  static RxDouble totalVal = 0.0.obs;
  @override
  void onInit() {
    fetchReportAwaitingAlgo();
    super.onInit();
  }
  Future<void> fetchReportAwaitingAlgo({String name}) async {


  isLoading(true);

  var url = "${BrokerInfo.algoUrl}/report/api/algo/AlgoReport";
  Map data = {
    "ClientCode": Dataconstants.feUserID,
    "SessionToken": Dataconstants.loginData.data.jwtToken,
    "InstState": 1
  };
  //encode Map to JSON
  var body = jsonEncode(data);
  //print("awaiting algo api request => $body");
  var response = await http
      .post(Uri.parse(url),
      headers: {"Content-Type": "application/json"}, body: body)
      .timeout(BrokerInfo.timeoutDuration);
  // var responseBody= response.body.toString();

  var data2 = jsonDecode(response.body);
  var responses = response;
  //log("awaiting report Response  => $data2");

  reportAwaitingAlgoLists = new List<ReportAlgo>();
  try{
  if(response.statusCode==200){
    for (int i = 0; i < data2.length; i++) {
      reportAwaitingAlgoLists.add(ReportAlgo.fromJson(data2[i]));
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
