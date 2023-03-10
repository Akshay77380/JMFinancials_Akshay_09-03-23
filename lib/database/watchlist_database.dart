import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/marketwatch_listener.dart';
import '../model/predefined_watch_listener.dart';
import '../model/scrip_info_model.dart';
import '../util/CommonFunctions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../util/Dataconstants.dart';
import '../util/InAppSelections.dart';

class WatchlistDatabase {
  static const _databaseName = "watchlist.db";
  static const _databaseVersion = 4;
  static Database _database;
  static var lastWatchListIndex = 0;
  static var allWatchlist = [];

  WatchlistDatabase._privateConstructor();

  static final WatchlistDatabase instance =
      WatchlistDatabase._privateConstructor();

  // only have a single app-wide reference to the database
  void initDB() async {
    var path = join(await getDatabasesPath(), _databaseName);
    _database = await openDatabase(path, version: _databaseVersion,
        onUpgrade: (Database db, int version, int tp) async {
      await db.execute(
          'CREATE TABLE AllWatchlist (watchListNo STRING, watchListName STRING, position STRING)');
      db.transaction((txn) async {
        Batch batch = txn.batch();
        batch.insert('AllWatchlist', {
          'watchListNo': '0',
          'watchListName': 'WatchList0',
          'position': '0'
        });
        batch.insert('AllWatchlist', {
          'watchListNo': '1',
          'watchListName': 'WatchList1',
          'position': '1'
        });
        batch.insert('AllWatchlist', {
          'watchListNo': '2',
          'watchListName': 'WatchList2',
          'position': '2'
        });
        batch.insert('AllWatchlist', {
          'watchListNo': '3',
          'watchListName': 'WatchList3',
          'position': '3'
        });
        batch.insert('AllWatchlist',
            {'watchListNo': '4', 'watchListName': 'Holdings', 'position': '4'});
        await batch.commit(noResult: true);
      });
    }, onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db
          .execute('CREATE TABLE WatchList0 (Exch STRING, ExchCode INTEGER)');
      await db
          .execute('CREATE TABLE WatchList1 (Exch STRING, ExchCode INTEGER)');
      await db
          .execute('CREATE TABLE WatchList2 (Exch STRING, ExchCode INTEGER)');
      await db
          .execute('CREATE TABLE WatchList3 (Exch STRING, ExchCode INTEGER)');
      await db.execute(
          'CREATE TABLE AllWatchlist (watchListNo STRING, watchListName STRING, position STRING)');
      db.transaction((txn) async {
        Batch batch = txn.batch();
        batch.insert('AllWatchlist', {
          'watchListNo': '0',
          'watchListName': 'Watchlist0',
          'position': '0'
        });
        batch.insert('AllWatchlist', {
          'watchListNo': '1',
          'watchListName': 'Watchlist1',
          'position': '1'
        });
        batch.insert('AllWatchlist', {
          'watchListNo': '2',
          'watchListName': 'Watchlist2',
          'position': '2'
        });
        batch.insert('AllWatchlist', {
          'watchListNo': '3',
          'watchListName': 'Watchlist3',
          'position': '3'
        });
        batch.insert('AllWatchlist',
            {'watchListNo': '4', 'watchListName': 'Holdings', 'position': '4'});
        await batch.commit(noResult: true);
      });
    });

    getAllWatchList();
  }

  Future<void> addNewWatchlist(watchListNo, watchListName, position) async {
    await _database.execute(
        'CREATE TABLE WatchList$watchListNo (Exch STRING, ExchCode INTEGER)');
    await _database.transaction((txn) async {
      Batch batch = txn.batch();
      batch.insert('AllWatchlist', {
        'watchListNo': watchListNo.toString(),
        'watchListName': watchListName.toString(),
        'position': position.toString()
      });
      await batch.commit(noResult: true);
      var jsons = {
        "LoginID": Dataconstants.feUserID.toString(),
        "Operation": "INSERT",
        "Watchlistname": watchListName.toString(),
        "Watchlistscrips": " "
      };
      CommonFunction.insertWatchList(jsons);
    });
    getAllWatchList();
    return true;
  }

  static Future<void> deleteWatchList(watchListNo) async {
    await _database.execute("DROP TABLE IF EXISTS WatchList$watchListNo");
    String query = 'DELETE FROM AllWatchlist WHERE watchListNo = $watchListNo';

    await _database.transaction((txn) async {
      await txn.rawDelete(query);
    });
    getAllWatchList();
    return true;
  }

  Future<bool> updateWatchListName(watchListNo, watchListName) async {
    String query =
        "UPDATE AllWatchlist set watchListName = '$watchListName' WHERE watchListNo = '$watchListNo'";

    await _database.transaction((txn) async {
      await txn.rawQuery(query);
    });
    // await getAllWatchList();
    Dataconstants.isWatchListChanged = true;
    //print("updated");
    return true;
  }

  static Future<bool> getAllWatchList() async {
    allWatchlist = [];
    String query =
        "SELECT watchListNo,watchListName,position from AllWatchlist";
    var results = await _database.rawQuery(query);
    lastWatchListIndex = results.last["watchListNo"];
    // InAppSelection.tabsView.clear();
    if (Dataconstants.isWatchListChanged) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        InAppSelection.tabsView =
            json.decode(prefs.getString("tabsView")) ?? [];
      } catch (ex) {
        InAppSelection.tabsView = [];
      }
    }
    Dataconstants.isWatchListChanged = false;
    if (InAppSelection.tabsView.isEmpty) {
      for (var i = 0; i < results.length; i++) {
        allWatchlist.add(results[i]);
        if (i < 4) {
          if (allWatchlist[i]["watchListName"].toString().toUpperCase() !=
              "HOLDINGS")
            InAppSelection.tabsView.add([
              allWatchlist[i]["watchListName"].toString(),
              "watchlist",
              allWatchlist[i]["watchListNo"].toString()
            ]);
          else
            InAppSelection.tabsView.add([
              allWatchlist[i]["watchListName"].toString(),
              "holdings",
              "na"
            ]);
        }
      }
    } else {
      for (var i = 0; i < results.length; i++) {
        allWatchlist.add(results[i]);
      }
    }

    // allWatchlist.sort((a, b) => a["position"].compareTo(b["position"]));
    var listenersList = [];
    var preDefinedListenersList = [];
    for (var i = 0; i < InAppSelection.tabsView.length; i++) {
      preDefinedListenersList.add(predefined_watch_listener(i));
      if (InAppSelection.tabsView[i][1].toString().toUpperCase() != "HOLDINGS")
        try {
          listenersList.add(
              MarketwatchListener(int.parse(InAppSelection.tabsView[i][2])));
        } catch (e) {}
      else
        try {
          listenersList.add(MarketwatchListener(0));
        } catch (e) {}
    }

    Dataconstants.marketWatchListeners = List.unmodifiable(listenersList);
    Dataconstants.preDefinedWatchListeners =
        List.unmodifiable(preDefinedListenersList);

    for (var list in Dataconstants.marketWatchListeners)
      list.loadMarketwatchListener();

    for (var list in Dataconstants.preDefinedWatchListeners)
      list.fetchPredefinedFromPref();

    //print("AllWatchlist - ${results.length}");
    return true;
  }

  void addToWatchListTable(int id, String exch, int exchCode) async {
    String query;
    query =
        'INSERT INTO WatchList$id (Exch, ExchCode) VALUES("$exch",$exchCode)';
    await _database.transaction((txn) async {
      await txn.rawInsert(query);
    });
  }

  Future<void> replaceAllWatchList(List data) async {
    await _database.transaction((txn) async {
      for (var i = 0; i < data.length; i++) {
        String query =
            "UPDATE AllWatchlist set position='$i' WHERE watchListNo = ${data[i]["watchListNo"]}";
        //print(query);
        await txn.rawQuery(query);
      }
    });
    getAllWatchList();
  }

  void replaceBulkToWatchListTable(int id, List<ScripInfoModel> data) async {
    try {
      if (id < 0 || id > 4) return;

      await _database.transaction((txn) async {
        Batch batch = txn.batch();
        batch.delete('WatchList$id');
        if (data.length > 0) {
          data.forEach((element) {
            batch.insert('WatchList$id',
                {'Exch': '${element.exch}', 'ExchCode': '${element.exchCode}'});
          });
        }
        await batch.commit(noResult: true);
      });
    } catch (e, s) {
      //print(e);
    }
  }

  void deleteFromWatchListTable(int id, String exch, int exchCode) async {
    String query =
        'DELETE FROM WatchList$id WHERE Exch = "$exch" AND Exchcode=$exchCode';

    await _database.transaction((txn) async {
      await txn.rawDelete(query);
    });
  }

  Future<List<ScripInfoModel>> getWatchList(int id) async {
    try {
      String query = "SELECT Exch,ExchCode from WatchList$id";
      var results = await _database.rawQuery(query);
      List<ScripInfoModel> models = [];
      for (int i = 0; i < results.length; i++) {
        var model = CommonFunction.getScripDataModel(
            exch: results[i]['Exch'],
            getChartDataTime: 15,
            sendReq: true,
            exchCode: results[i]['ExchCode'],
            getNseBseMap: true);
        models.add(model);
      }
      return models;
    } catch (e) {}
  }
}
