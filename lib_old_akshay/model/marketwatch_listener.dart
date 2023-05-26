// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../util/InAppSelections.dart';

import '../model/scripStaticModel.dart';
import '../model/scrip_info_model.dart';
import 'dart:math' as Math;
import '../database/watchlist_database.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';
import '../widget/predefined_marketwatch.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'marketwatch_listener.g.dart';

class MarketwatchListener = _MarketwatchListener with _$MarketwatchListener;

abstract class _MarketwatchListener with Store {
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
    'BSE Currency'
  ];
  List<String> summaryFilterTypes = const [
    'Top Traded',
    'Top Gainers',
    'Top Losers',
    'Yearly High',
    'Yearly Low'
  ];

  _MarketwatchListener(this.id);

  int getWatchLength() {
    return watchList.length;
  }

  void loadMarketwatchListener() {
    // //print("this is id $id");
    if (id >= 0) {
      fetchWatchListFromDb();
      fetchNamesFromPref();
    } else if (id == -1) {
      fetchPredefinedFromPref();
    } else if (id == -2) {
      fetchIndicesFromPref();
    } else {
      fetchSummaryFromPref();
    }
  }

  @observable
  ObservableList<ScripInfoModel> watchList = ObservableList<ScripInfoModel>();

  @observable
  String watchListName = "";

  void fetchWatchListFromDb() async {
    try {
      var list = await WatchlistDatabase.instance.getWatchList(id);
      if (list.length > 0)
        addToWatchListBulk(
            list, id == InAppSelection.marketWatchID ? true : false);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  void fetchNamesFromPref() async {
    try {
      if (id < 0) return;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String temp1 = (prefs.getString(id.toString()));
      if (temp1 != null)
        setWatchListName(temp1);
      else
        setWatchListName('Watchlist ${id + 1}');
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  void fetchPredefinedFromPref() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      /* Getting Gr Type and Gr Code from shared preferences */
      grType = (prefs.getString('predefinedGrType${id}'));
      grCode = (prefs.getString('predefinedGrCode${id}'));
      if (grType == null) {
        grType = 'P';
        grCode = 'NFTY';
      }
      /* Getting grName from predefinedGrName shared preferences */
      String grName = (prefs.getString('predefinedGrName${id}'));
      if (grName == null) grName = 'Nifty 50';
      //setWatchListName(grName);
      var members = CommonFunction.getMembers(grType, grCode);
      /* Adding models To Predefined Watch List as Bulk */
      Dataconstants.predefinedMarketWatchListener.addToPredefinedWatchListBulk(
        values: members,
        grType: grType,
        grCode: grCode,
        grName: grName,
        sendRequest: true,
      );
    } catch (e, s) {
      CommonFunction.firebaseCrashlytics(e, s);
      //print(e);
    }
  }

  void fetchSummaryFromPref() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      summaryExchPos = (prefs.getInt('summaryExchPos'));
      selectedFilter = (prefs.getInt('selectedFilter'));
      if (summaryExchPos == null) {
        summaryExchPos = 0;
        selectedFilter = 0;
      }
      // Dataconstants.iqsClient.requestForMarketSummary(
      //   Dataconstants.exchData[summaryExchPos].exch,
      //   Dataconstants.exchData[summaryExchPos].exchTypeShort,
      //   selectedFilter,
      // );
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  void fetchIndicesFromPref() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      selectedFilter = (prefs.getInt('indicesFilter'));
      if (selectedFilter == null) selectedFilter = 0;
      var list = CommonFunction.getIndices(
        getChartDataTime: 15,
        indicesMode: selectedFilter,
        sendRequest: false,
      );
      var name;
      if (selectedFilter == 0)
        name = 'ALL';
      else if (selectedFilter == 1)
        name = 'NSE';
      else
        name = 'BSE';
      // setWatchListName(name);
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // pref.setInt('indicesFilter', selectedFilter);
      addToIndicesWatchListBulk(list, name);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @action
  void addToWatchList(ScripInfoModel model) {
    try {
      /* if watchList length is greater then max Watch list Count which is 50 then return */
      if (watchList.length >= Dataconstants.maxWatchlistCount) return;
      /* Getting Exch Position Code */
      int exPos = CommonFunction.getExchPosOnCode(model.exch, model.exchCode);
      /* Getting script Position */
      int scripPos = Dataconstants.exchData[exPos].scripPos(model.exchCode);
      /* If script Position doesnot found then added to database */
      /* scripPos = -1 (not found) */
      if (scripPos < 0) {
        var result = CommonFunction.getScripDataModel(
          exch: model.exch,
          exchCode: model.exchCode,
          getNseBseMap: true,
          getChartDataTime: 15,
        );
        Dataconstants.exchData[exPos].addModel(result);
        /* Inserting every scripts at the top (starting) of the list */
        watchList.insert(0, result);
      } else {
        /* scripPos >=0 (found) */
        /* Inserting every scripts at the top (starting) of the list */
        watchList.insert(0, model);
        /* Adding model to watchList */
        WatchlistDatabase.instance.addToWatchListTable(
          id,
          model.exch,
          model.exchCode,
        );
      }
    } catch (e, s) {
      CommonFunction.firebaseCrashlytics(e, s);
      //print(e);
    }
  }

  @action
  void addToWatchListSearch(ScripStaticModel model) {
    try {
      /* if watchList length is greater then max Watch list Count which is 50 then return */
      if (watchList.length >= Dataconstants.maxWatchlistCount) return;
      /* Getting Exch Position Code */
      int exPos = CommonFunction.getExchPosOnCode(model.exch, model.exchCode);
      /* Getting script Position */
      int scripPos = Dataconstants.exchData[exPos].scripPos(model.exchCode);
      /* If script Position doesnot found then added to database */
      /* scripPos = -1 (not found) */
      if (scripPos < 0) {
        var result = CommonFunction.getScripDataModel(
          exch: model.exch,
          exchCode: model.exchCode,
          getNseBseMap: true,
          getChartDataTime: 15,
        );
        Dataconstants.exchData[exPos].addModel(result);
        /* Inserting every scripts at the top (starting) of the list */
        watchList.insert(0, result);
      } else {
        /* scripPos >=0 (found) */
        /* Inserting every scripts at the top (starting) of the list */
        var model = Dataconstants.exchData[exPos].getModel(scripPos);
        watchList.insert(0, model);
      }
      /* Adding model to watchList */
      WatchlistDatabase.instance.addToWatchListTable(
        id,
        model.exch,
        model.exchCode,
      );

      // watchList.reversed.toList();

    } catch (e, s) {
      CommonFunction.firebaseCrashlytics(e, s);
      //print(e);
    }
  }

  void saveWatchListName(String name) async {
    if (id < 0) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(id.toString(), name);
    setWatchListName(name);
  }

  @action
  void setWatchListName(String newName) => watchListName = newName;

  @action
  void setSummaryWatchList(int filter) {
    selectedFilter = filter;
    watchListName =
        '${summaryExchanges[summaryExchPos]} ${summaryFilterTypes[selectedFilter]}';
    saveSummaryDetails();
  }

  void saveSummaryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.selectedFilter = selectedFilter;

    prefs.setInt('summaryExchPos', this.summaryExchPos);
    prefs.setInt('selectedFilter', this.selectedFilter);

    setWatchListName(
        '${summaryExchanges[summaryExchPos]} ${summaryFilterTypes[selectedFilter]}');
  }

  @action
  void addToWatchListBulk(List<ScripInfoModel> values, [bool sendReq = true]) {
    try {
      watchList.clear();
      for (int i = 0; i < values.length; i++) {
        var model = CommonFunction.getScripDataModel(
          exch: values[i].exch,
          exchCode: values[i].exchCode,
          getNseBseMap: true,
          sendReq: sendReq,
          getChartDataTime: 15,
        );
        if (model.exch.isNotEmpty) watchList.add(model);
        //print("watch list - $id - ${watchList.length}");
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
      removeBulkFromPredefinedWatchList();
      List<ScripInfoModel> models = [];
      Dataconstants.indexNifty50.clear();
      Dataconstants.indexBankNifty.clear();

      for (int i = 0; i < values.length; i++) {
        var model = CommonFunction.getScripDataModel(
          exch: values[i].exch,
          exchCode: values[i].exchCode,
          sendReq: sendRequest,
          getChartDataTime: 15,
        );

        if (model.exch.isNotEmpty) models.add(model);
      }
      if(grType == 'P' && grCode == 'NFTY' && grName.contains('Nifty 50')) {
        Dataconstants.indexNifty50 = models;
      }
      if(grType == 'P' && grCode == 'P0007' && grName == 'Bank Nifty') {
        Dataconstants.indexBankNifty = models;
      }
      for (int i = 0; i < models.length; i++) {
        watchList.add(models[i]);
      }
      this.grType = grType;
      this.grCode = grCode;
      /* Setting WatchList Name */
      setWatchListName(grName);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('predefinedGrType', grType);
      prefs.setString('predefinedGrCode', grCode);
      prefs.setString('predefinedGrName', grName);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @action
  Future<void> addToIndicesWatchListBulk(
      List<ScripInfoModel> value, String name) async {
    try {
      removeBulkFromPredefinedWatchList();
      watchList.addAll(value);
      setWatchListName(name);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setInt('indicesFilter', selectedFilter);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @action
  void updateWatchList(List<ScripInfoModel> values) {
    try {
      WatchlistDatabase.instance.replaceBulkToWatchListTable(id, values);
      var removedlist = watchList.where((element) => !values.contains(element));
      watchList = ObservableList.of(values);
      removedlist.forEach((element) {
        Dataconstants.iqsClient.sendLTPRequest(element, false);
      });
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @action
  void sortListbyName(bool isDescending) {
    if (isDescending)
      watchList.sort((b, a) => a.name.compareTo(b.name));
    else
      watchList.sort((a, b) => a.name.compareTo(b.name));
  }

  @action
  void sortListbyPrice(bool isDescending) {
    if (isDescending)
      watchList.sort((b, a) => a.close.compareTo(b.close));
    else
      watchList.sort((a, b) => a.close.compareTo(b.close));
  }

  @action
  void sortListbyPercent(bool isDescending) {
    if (isDescending)
      watchList.sort((b, a) => a.percentChange.compareTo(b.percentChange));
    else
      watchList.sort((a, b) => a.percentChange.compareTo(b.percentChange));
  }

  @action
  void removeFromWatchList(ScripInfoModel value) {
    try {
      watchList.remove(value);
      Dataconstants.iqsClient.sendLTPRequest(value, false);
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @action
  removeBulkFromWatchList() {
    try {
      for (var model in watchList)
        Dataconstants.iqsClient.sendLTPRequest(model, false);
      watchList.clear();
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @action
  void removeBulkFromPredefinedWatchList() {
    try {
      var list = watchList.toList();
      watchList.clear();
      for (int index = 0; index < list.length; index++) {
        Dataconstants.iqsClient.sendLTPRequest(list[index], false);
      }
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @action
  void removeFromWatchListIndex(int index) {
    try {
      if (index >= watchList.length) return;
      ScripInfoModel temp = watchList[index];
      watchList.removeAt(index);

      Dataconstants.iqsClient.sendLTPRequest(temp, false);
      WatchlistDatabase.instance.deleteFromWatchListTable(
        id,
        temp.exch,
        temp.exchCode,
      );

      watchList.reversed.toList();
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  bool isScripInMarketWatch(String exch, int exchCode) {
    for (int i = 0; i < watchList.length; i++) {
      if (watchList[i].exch != exch) continue;
      if (watchList[i].exchCode != exchCode) continue;
      return true;
    }

    return false;
  }

  @action
  void updateSummaryWatchlist(int reportType) {
    try {
      watchList.clear();
      List<ScripInfoModel> allMsScrips;
      if (summaryExchPos == 0)
        allMsScrips = Dataconstants.exchData[summaryExchPos]
            .getAllScripsForNifty500MarketSummary();
      else if (summaryExchPos == 2)
        allMsScrips = Dataconstants.exchData[summaryExchPos]
            .getAllScripsForBse500MarketSummary();
      else
        allMsScrips = Dataconstants.exchData[summaryExchPos]
            .getAllScripsForMarketSummary();
      if (allMsScrips.length <= 0) return;
      switch (reportType) {
        case 0:
          allMsScrips.sort((b, a) => a.todayValue.compareTo(b.todayValue));
          break;
        case 1:
          allMsScrips
              .sort((b, a) => a.percentChange.compareTo(b.percentChange));
          break;
        case 2:
          allMsScrips
              .sort((a, b) => a.percentChange.compareTo(b.percentChange));
          break;
        case 3: //52week high
          allMsScrips = allMsScrips.toList();
          break;
        case 4: //52week low
          allMsScrips = allMsScrips.toList();
          break;
      }
      for (int i = 0; i < Math.min(20, allMsScrips.length); i++) {
        watchList.add(allMsScrips[i]);
        Dataconstants.iqsClient.sendLTPRequest(allMsScrips[i], true);
      }
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }
}
