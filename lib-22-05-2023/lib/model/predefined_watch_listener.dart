import 'package:flutter/foundation.dart';
import 'package:markets/model/scrip_info_model.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';
import '../widget/predefined_marketwatch.dart';
part 'predefined_watch_listener.g.dart';

class predefined_watch_listener = _predefined_watch_listener
    with _$predefined_watch_listener;

abstract class _predefined_watch_listener with Store {
  final int id;
  int selectedFilter =
      0; //0-nse,1-nseIndus,2-nsebussiness,3-bse,4-bseindus,5-bsebusiness
  //(Summary) 0-toptraded,1-20best,2-20worst,3-52weekhigh,4-52weeklow
  int summaryExchPos = 0; //(Summary)0-nseCash,1-nsefuture,2-bsecash,3-bsecurr
  String grType = 'P';
  String grCode = 'NFTY';
  List<String> summaryExchanges = const [
    'NSE Cash',
    'NSE Future',
    'BSE Cash',
    /* BOB requirement */
    //'BSE Currency'
  ];
  List<String> summaryFilterTypes = const [
    'Top Traded',
    'Best 20',
    'Worst 20',
    'Year High',
    'Year Low'
  ];

  _predefined_watch_listener(this.id);

  @observable
  ObservableList<ScripInfoModel> watchList = ObservableList<ScripInfoModel>();

  @observable
  String watchListName = "";

  int getWatchLength() {
    return watchList.length;
  }

  void fetchPredefinedFromPref() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /* Getting Gr Type and Gr Code from shared preferences */
      grType = (prefs.getString('predefinedGrType${id}'));
      grCode = (prefs.getString('predefinedGrCode${id}'));
      if (grType != null) {
        // grType = 'P';
        // grCode = 'NFTY';
        /* Getting grName from predefinedGrName shared preferences */
        String grName = (prefs.getString('predefinedGrName${id}'));
        // if (grName == null) grName = 'Nifty 50';
        //setWatchListName(grName);
        var members = CommonFunction.getMembers(grType, grCode);
        /* Adding models To Predefined Watch List as Bulk */
        addToPredefinedWatchListBulk(
          values: members,
          grType: grType,
          grCode: grCode,
          grName: grName,
          sendRequest: true,
        );
      }
    } catch (e, s) {
      CommonFunction.firebaseCrashlytics(e, s);
      //print(e);
    }
  }

  @action
  Future<void> addToPredefinedWatchListBulk({
    @required List<MemberData> values,
    @required String grType,
    @required String grCode,
    @required String grName,
    bool sendRequest = true,
  }) async {
    try {
      /* remove bulk models From Predefined Watch List */
      removeBulkFromPredefinedWatchList();
      List<ScripInfoModel> models = [];

      for (int i = 0; i < values.length; i++) {
        var model = CommonFunction.getScripDataModel(
          exch: values[i].exch,
          exchCode: values[i].exchCode,
          sendReq: sendRequest,
          getChartDataTime: 15,
        );

        if (model.exch.isNotEmpty) models.add(model);
      }
      watchList.clear();
      for (int i = 0; i < models.length; i++) {
        watchList.add(models[i]);
      }
      this.grType = grType;
      this.grCode = grCode;
      /* Setting WatchList Name */
      setWatchListName(grName);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('predefinedGrType${id}', grType);
      prefs.setString('predefinedGrCode${id}', grCode);
      prefs.setString('predefinedGrName${id}', grName);
    } catch (e, s) {
      CommonFunction.firebaseCrashlytics(e, s);
      //print(e);
    }
  }

  @action
  void sortListbyName(bool isDescending) {
    if (isDescending)
      watchList.sort((b, a) => a.name.compareTo(b.name));
    else
      watchList.sort((a, b) => a.name.compareTo(b.name));
  }

  /* sortListbyPrice function is used to sort List by LTP */
  @action
  void sortListbyPrice(bool isDescending) {
    if (isDescending)
      watchList.sort((b, a) => a.close.compareTo(b.close));
    else
      watchList.sort((a, b) => a.close.compareTo(b.close));
  }

  /* sortListbyPercent function is used to sort List by percent Change */
  @action
  void sortListbyPercent(bool isDescending) {
    if (isDescending)
      watchList.sort((b, a) => a.percentChange.compareTo(b.percentChange));
    else
      watchList.sort((a, b) => a.percentChange.compareTo(b.percentChange));
  }

  @action
  void removeBulkFromPredefinedWatchList() {
    try {
      var list = watchList.toList();
      watchList.clear();
      for (int index = 0; index < list.length; index++) {
        /* Sending all Script Request To IQS */
        Dataconstants.iqsClient.sendScripRequestToIQS(list[index], false);
      }
    } catch (e, s) {
      CommonFunction.firebaseCrashlytics(e, s);
      //print(e);
    }
  }

  /* setWatchListName function is used set Watch List Name of every watchList */
  @action
  void setWatchListName(String newName) => watchListName = newName;

// void fetchWatchListFromDb() async {
//   try {
//     /* Getting list of scripts (models) by thits watchlist id */
//     var list = await WatchlistDatabase.instance.getWatchList(id);
//     /* Keep this code if required in future */
//     /* It reversed the list */
//     list = list.reversed.toList();
//     if (list.length > 0)
//       /* Adding list of model To Watch List as Bulk */
//       addToWatchListBulk(
//           list, id == InAppSelection.marketWatchID ? true : false);
//   } catch (e, s) {
//     CommonFunction.firebaseCrashlytics(e, s);
//     //print(e);
//   }
// }

}
