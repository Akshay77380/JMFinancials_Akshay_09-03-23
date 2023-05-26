import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/jmModel/netPosition.dart';
import '../util/BrokerInfo.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';

class NetPositionController extends GetxController {
  static var isLoading = true.obs;
  static var NetPositionList = NetPositions().obs;
  static List<NetPositionDatum> closePositionList = <NetPositionDatum>[].obs;
  static List<NetPositionDatum> closePositionFilteredList = <NetPositionDatum>[];
  static List<NetPositionDatum> openPositionList = <NetPositionDatum>[].obs;
  static List<NetPositionDatum> openPositionFilteredList = <NetPositionDatum>[];
  static var NetPositionLength = 0, OpenPositionLength = 0, ClosePositionLength = 0;
  static RxDouble totalBuy = 0.0.obs, totalSell = 0.0.obs, totalNet = 0.0.obs;
  static RxDouble totalRealisedPL = 0.0.obs;
  static RxInt squareOffCount = 0.obs;

  @override
  void onInit() {
    // fetchNetPosition();
    super.onInit();
  }

  Future<void> fetchNetPosition() async {
    isLoading(true);
    var requestJson = {};
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "GetNetPositions", requestJson, Dataconstants.loginData.data.jwtToken);
    NetPositionList.value = NetPositionList();
    NetPositionLength = 0;
    var responses = response.body.toString();
    try {
      var jsons = json.decode(responses);
      if (jsons['status'] == false) {
        if (jsons["emsg"].toString() != 'No Data') CommonFunction.showBasicToast(jsons["emsg"].toString());
      } else {
        NetPositionList.value = netPositionsFromJson(responses);
        closePositionList = [];
        closePositionFilteredList = [];
        openPositionList = [];
        openPositionFilteredList = [];
        totalBuy.value = 0.0;
        totalSell.value = 0.0;
        totalNet.value = 0.0;
        totalRealisedPL.value = 0.0;
        //log("net position log${NetPositionList.value}");
        squareOffCount.value = NetPositionLength;
        for (var i = 0; i < NetPositionList.value.data.length; i++) {
          if (NetPositionList.value.data[i].netqty == '0') {
            closePositionList.add(NetPositionList.value.data[i]);
            closePositionFilteredList.add(NetPositionList.value.data[i]);
            totalRealisedPL.value += NetPositionList.value.data[i].pl;
          } else {
            openPositionList.add(NetPositionList.value.data[i]);
            openPositionFilteredList.add(NetPositionList.value.data[i]);
          }
          totalBuy += double.tryParse(NetPositionList.value.data[i].totalbuyvalue.replaceAll(",", ''));
          totalSell += double.tryParse(NetPositionList.value.data[i].totalsellvalue.replaceAll(",", ''));
          // totalNet.value += double.tryParse(NetPositionList.value.data[i].netvalue.replaceAll(",", ''));
        }
        totalNet.value = totalBuy.value - totalSell.value;
        OpenPositionLength = openPositionList.length;
        ClosePositionLength = closePositionList.length;
        NetPositionLength = NetPositionList.value.data.length;
        // log('net position -- ${response.body}');
        isLoading(false);
      }
    } catch (e) {
      // var jsons = json.decode(responses);
      // CommonFunction.showBasicToast(jsons["message"].toString());
      NetPositionList.value = NetPositionList();
      NetPositionLength = 0;
      isLoading(false);
    } finally {
      isLoading(false);
    }
    isLoading(false);
    return;

    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (_) => MainScreen(),
    //   ),
    // );
  }
}
