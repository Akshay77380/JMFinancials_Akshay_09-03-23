import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../../model/stock_sip_model/stock_sip_model/get_sip_list.dart';
import '../../util/BrokerInfo.dart';
import '../../util/Dataconstants.dart';

class GetSipListController extends GetxController {
  static var isLoading = true.obs;
  static var SipListData = GetSipList().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static GetSipList GetSipListData = null;
  static List<GetSipList> ActiveSipListData=[];
  static List<GetSipList> PauseSipListData=[];
  static List<GetSipList> ExpiredSipListData=[];
  static RxDouble totalVal = 0.0.obs;
  @override
  void onInit() {
    fetchGetSipListData();
    super.onInit();
  }
  Future<void> fetchGetSipListData() async {
    isLoading(true);

    var requestJson ={
      "ClientCode":Dataconstants.feUserID,
      "SessionToken":Dataconstants.loginData.data.jwtToken.toString()
    };

    var    response  = await Dataconstants.itsClient.httpPostBigul(BrokerInfo.mainUrl == BrokerInfo.UATURL ? "https://tradeapiuat.jmfonline.in/tools/Report/api/sip/FetchAll" : "https://tradeapi.jmfonline.in/tools/Report/api/sip/FetchAll", requestJson); //+ "api/Login"
    // var    response  = await Dataconstants.itsClient.httpPostBigul("https://tradeapiuat.jmfonline.in/tools/Report/api/sip/FetchAll", requestJson); //+ "api/Login"
    var responses = response.body;
    // String    response = await ITSClient.httpPost(BrokerInfo.sipMainUrlBase + "tools/Report/api/sip/FetchAll", requestJson);
    log("get SIP list Response  => $responses");
    try {
      ActiveSipListData.clear();
      PauseSipListData.clear();
      ExpiredSipListData.clear();
      List Data = json.decode(responses);
      List<GetSipList> list=[];

      for(int i =0;i<Data.length;i++ ){
        Map DataSub = Data[i];
        GetSipListData = GetSipList.fromJson(DataSub);
        list.add(GetSipListData);

        if(GetSipListData.instructionState=="R"||GetSipListData.instructionState=="A"){
          ActiveSipListData.add(GetSipListData);
        }
        if(GetSipListData.instructionState=="P"){
          PauseSipListData.add(GetSipListData);
        }
        if(GetSipListData.instructionState=="S"||GetSipListData.instructionState=="C"){
          ExpiredSipListData.add(GetSipListData);
        }

      }

      // totalVal.value = 0.0;
    } catch (e) {
      var jsons = json.decode(responses);
    } finally {
      isLoading(false);
    }
    return;

  }



}
