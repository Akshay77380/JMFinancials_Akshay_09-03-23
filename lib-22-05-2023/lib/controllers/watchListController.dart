import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../database/watchlist_database.dart';
import '../model/jmModel/watchList.dart';
import '../util/BrokerInfo.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';

class WatchListController extends GetxController {
  static var isLoading = true.obs, isHoldingSearch = false.obs;
  static var WatchListDatas = WatchListData().obs;
  static List<WatchListDatum> WatchList = <WatchListDatum>[].obs;

  @override
  void onInit() {
    // fetchWatchList();
    super.onInit();
  }

  checkWatchList() async {
    await fetchWatchList();
    if (WatchList.isEmpty) {
      for (var i = 0; i < WatchlistDatabase.allWatchlist.length - 1; i++) {
        var jsons = {
          "LoginID": Dataconstants.feUserID,
          "Operation": "INSERT",
          "Watchlistname":
              WatchlistDatabase.allWatchlist[i]["watchListName"].toString(),
          "Watchlistscrips": " "
        };
        //log("insert Watchlist request - $jsons");

        await CommonFunction.insertWatchList(jsons);
      }
    }
  }

  addScript(index){

  }

  Future<void> fetchWatchList() async {
    var requestJson = {
      "LoginID": Dataconstants.feUserID,
      "Operation": "SELECT"
    };
    isLoading(true);
    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(
        BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "Watchlistoperation",
        requestJson,
        Dataconstants.loginData.data.jwtToken);
    var responses = response.body.toString();
    try {
      var jsons = json.decode(responses);
      if (jsons['status'] == false) {
        CommonFunction.showBasicToast(jsons["emsg"].toString());
      } else {
        WatchList = [];
        WatchListDatas.value = watchListDataFromJson(responses);
        WatchList.addAll(WatchListDatas.value.data);
        //log("watchList data => $responses");
      }
    } catch (e) {
      var jsons = json.decode(responses);
      // CommonFunction.showBasicToast(jsons["message"].toString());
    } finally {
      isLoading(false);
    }
    return;
  }
}
