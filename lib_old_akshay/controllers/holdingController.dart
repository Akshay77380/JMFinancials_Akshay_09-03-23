import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:markets/util/BrokerInfo.dart';

import '../model/jmModel/holdings.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';

class HoldingController extends GetxController {
  static var isLoading = true.obs, isLoadingMtf = true.obs, isHoldingSearch = false.obs;
  static var HoldingData = Holdings().obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static List<HoldingDatum> holdingList = <HoldingDatum>[].obs;
  static List<HoldingDatum> mtfHoldingList = <HoldingDatum>[].obs;
  static List<HoldingDatum> holdingFilteredList = <HoldingDatum>[].obs;
  static List<HoldingDatum> mtfHoldingFilteredList = <HoldingDatum>[].obs;
  static var HoldigsLength = 0;
  static RxDouble totalVal = 0.0.obs;
  static RxDouble totalVal2 = 0.0.obs;
  static RxDouble mtfTotalVal = 0.0.obs;
  static var advances = 0.obs;
  static var declines = 0.obs;

  static var MtfAdvances = 0.obs;
  static var MtfDeclines = 0.obs;

  @override
  void onInit() {
    // fetchHolding();
    super.onInit();
  }

  // void fetchOrderBook() async {
  //   try {
  //     isLoading(true);
  //     var products = await HttpService.fetchOrderBook();
  //     if (products != null) {
  //       OrderBookList.value = products;
  //     }
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> fetchHolding() async {
    print("Fetchholdings");
    var requestJson = {"producttype": "CNC"};

    isLoading(true);
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "GetHoldings", requestJson, Dataconstants.loginData.data.jwtToken);
    var responses = response.body.toString();
    try {
      var jsons = json.decode(responses);
      if (jsons['status'] == false) {
        if (jsons["emsg"].toString() != 'No Data') CommonFunction.showBasicToast(jsons["emsg"].toString());
      } else {
        holdingList = [];
        holdingFilteredList = [];
        totalVal.value = 0.0;
        totalVal2.value = 0.0;
        HoldingData.value = holdingsFromJson(responses);
        HoldigsLength = HoldingData.value.data.length;
        holdingList.addAll(HoldingData.value.data);
        holdingFilteredList.addAll(HoldingData.value.data);
        holdingList.forEach((element) {
          totalVal.value += double.tryParse(element.profitandloss.replaceAll(',', ''));
          totalVal2.value += (element.model.close.toDouble() * int.parse(element.quantity).toDouble());
        });
      }

      advances.value = 0;
      declines.value = 0;
      for (var i = 0; i < HoldigsLength; i++) {
        if (holdingList[i].model.percentChange > 0) {
          advances++;
        } else {
          declines++;
        }
      }
    } catch (e, s) {
      print(e);
      // var jsons = json.decode(responses);
      // CommonFunction.showBasicToast(jsons["message"].toString());
    } finally {
      isLoading(false);
    }
    isLoading(false);
    return;
  }

  Future<void> fetchMtfHolding() async {
    var requestJson = {"producttype": "MTF"};

    isLoadingMtf(true);

    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "GetHoldings", requestJson, Dataconstants.loginData.data.jwtToken);

    var responses = response.body.toString();

    try {
      var jsons = json.decode(responses);
      if (jsons['status'] == false) {
        if (jsons["emsg"].toString() != 'No Data') CommonFunction.showBasicToast(jsons["emsg"].toString());
      } else {
        mtfHoldingList = [];
        mtfHoldingFilteredList = [];
        HoldingData.value = holdingsFromJson(responses);
        mtfHoldingList.addAll(HoldingData.value.data);
        mtfHoldingFilteredList.addAll(HoldingData.value.data);
        //log("holding data => $responses");

        MtfAdvances.value = 0;
        MtfDeclines.value = 0;
        mtfTotalVal.value = 0.0;
        mtfHoldingList.forEach((element) {
          mtfTotalVal.value += double.tryParse(element.profitandloss.replaceAll(',', ''));
        });
        for (var i = 0; i < mtfHoldingList.length; i++) {
          if ((mtfHoldingList[i].model.close * double.parse(mtfHoldingList[i].quantity.replaceAll(',', ''))) - double.parse(mtfHoldingList[i].profitandloss.replaceAll(',', '')) > 0) {
            MtfAdvances++;
          } else {
            MtfDeclines++;
          }
        }
      }
    } catch (e) {
      // var jsons = json.decode(responses);
      // CommonFunction.showBasicToast(jsons["message"].toString());
    } finally {
      isLoadingMtf(false);
    }
    isLoadingMtf(false);
    return;
  }

  void updateHoldingsBySearch([String filterText = '']) {
    isLoading.value = true;
    isLoadingMtf.value = true;
    if (filterText != '' && filterText.isNotEmpty) {
      HoldingController.holdingList = HoldingController.holdingFilteredList.where((element) => element.model.name.toLowerCase().contains(filterText.toLowerCase())).toList();
      HoldingController.mtfHoldingList = HoldingController.mtfHoldingFilteredList.where((element) => element.model.name.toLowerCase().contains(filterText.toLowerCase())).toList();
    } else {
      HoldingController.holdingList = HoldingController.holdingFilteredList;
      HoldingController.mtfHoldingList = HoldingController.mtfHoldingFilteredList;
    }
    // filterSortOrderBookOrders();
    isLoading.value = false;
    isLoadingMtf.value = false;
  }

  void sortHoldings() {
    isLoading.value = true;
    isLoadingMtf.value = true;
    if (sortVal == 0) {
      holdingList.sort((a, b) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
      mtfHoldingList.sort((a, b) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
    } else if (sortVal == 1) {
      holdingList.sort((b, a) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
      mtfHoldingList.sort((b, a) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
    } else if (sortVal == 2) {
      holdingList.sort((a, b) => a.profitandloss.compareTo(b.profitandloss));
      mtfHoldingList.sort((a, b) => a.profitandloss.compareTo(b.profitandloss));
    } else if (sortVal == 3) {
      holdingList.sort((b, a) => a.profitandloss.compareTo(b.profitandloss));
      mtfHoldingList.sort((b, a) => a.profitandloss.compareTo(b.profitandloss));
    }
    isLoading.value = false;
    isLoadingMtf.value = false;
  }
}
