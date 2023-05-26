import 'dart:developer';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:markets/util/DateUtil.dart';

import '../Connection/News/NewsClient.dart';
import '../util/Dataconstants.dart';
import '../widget/predefined_marketwatch.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static const _databaseName = "masters.mf";
  //static const _databaseVersion = 3;

  static Future<void> _closeDb(Database db) async {
    if (db != null) {
      try {
        if (db.isOpen) {
          await db.close();
        }
      } catch (e) {
        // //print("Could not close database");
      }
    }
  }

  static Future<int> getMasterDate() async {
    Database database;
    int masterDate = 0;
    try {
      var path = join(await getDatabasesPath(), _databaseName);
      database = await openDatabase(
        path,
        version: 3,
      );
      masterDate = Sqflite.firstIntValue(
          await database.rawQuery('SELECT * from MasterDate'));
      // //print('this is master date current => ' + masterDate.toString());
      var dates =
          DateUtil.getAnyFormattedExchDate(masterDate, "dd-MM-yyyy HH:mm:ss");
      // //print(" dates $dates");
      database.close();
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      if (database != null && database.isOpen) database.close();
    }
    return masterDate;
  }

  static Future<bool> getAllScripDetailFromMemory(
      Function sendProgressResponse, bool isMasterDownload) async {
    List<Map<String, dynamic>> derivData = [];
    sqfliteFfiInit();
    var path = join(await getDatabasesPath(), _databaseName);
    Database database = await openDatabase(
      path,
      version: 3,
    );
    List<Map<String, dynamic>> tables = await database
        .rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    List<String> tableNames = [];
    for (var table in tables) tableNames.add(table.values.first);
    database.close();
    database = null;
    var databaseInstance = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        singleInstance: false,
      ),
    );
    if (isMasterDownload)
      sendProgressResponse(0.82);
    else
      sendProgressResponse(0.05);
    try {
      await databaseInstance.rawQuery("ATTACH DATABASE ? as mst", [path]);

      // #region Groups
      if (tableNames.contains('Groups')) {
        await databaseInstance
            .rawQuery("CREATE TABLE Groups AS SELECT * FROM mst.Groups");
        var groupData = await databaseInstance.rawQuery('SELECT * FROM Groups');
        Dataconstants.groupData.clear();
        Dataconstants.groupData.addAll(
          groupData.map(
            (e) => GroupData(
              e['GrType'],
              e['GrCode'],
              e['GrName'],
            ),
          ),
        );
      }
      if (isMasterDownload)
        sendProgressResponse(0.85);
      else
        sendProgressResponse(0.1);
      // #endregion

      // #region Members
      if (tableNames.contains('Members')) {
        await databaseInstance
            .rawQuery("CREATE TABLE Members AS SELECT * FROM mst.Members");
        var memberData =
            await databaseInstance.rawQuery('SELECT * FROM Members');
        Dataconstants.memberData.clear();
        Dataconstants.memberData.addAll(
          memberData.map(
            (e) => MemberData(
              grType: e['GrType'],
              grCode: e['GrCode'],
              exch: e['Exch'],
              exchCode: e['Code'],
              exchType: e['ExchType'],
              name: e['Name'],
            ),
          ),
        );
      }
      if (isMasterDownload)
        sendProgressResponse(0.87);
      else
        sendProgressResponse(0.2);
      // #endregion

      // #region Nse Equity
      if (tableNames.contains('NseEquityMaster')) {
        await databaseInstance.rawQuery(
            "CREATE TABLE NseEquityMaster AS SELECT * FROM mst.NseEquityMaster");
        var nseEQData =
            await databaseInstance.rawQuery('SELECT * FROM NseEquityMaster');
        Dataconstants.exchData[0].addAllNseEquity(nseEQData);
      }
      if (isMasterDownload)
        sendProgressResponse(0.9);
      else
        sendProgressResponse(0.3);
      // #endregion

      // #region Bse Equity
      if (tableNames.contains('BseEquityMaster')) {
        await databaseInstance.rawQuery(
            "CREATE TABLE BseEquityMaster AS SELECT * FROM mst.BseEquityMaster");
        var bseEQData =
            await databaseInstance.rawQuery('SELECT * FROM BseEquityMaster');
        Dataconstants.exchData[2].addAllBseEquity(bseEQData);
      }
      if (isMasterDownload)
        sendProgressResponse(0.93);
      else
        sendProgressResponse(0.4);
      // #endregion

      // #region Nse Deriv
      if (tableNames.contains('NseDerivMaster') || tableNames.contains('SpreadMaster')) {
        await databaseInstance.rawQuery(
            "CREATE TABLE NseDerivMaster AS SELECT * FROM mst.NseDerivMaster");
        var nseDerivData =
            await databaseInstance.rawQuery('SELECT * FROM NseDerivMaster');
        derivData.addAll(nseDerivData);
        derivData.length;
        await databaseInstance.rawQuery(
            "CREATE TABLE SpreadMaster AS SELECT * FROM mst.SpreadMaster");
        var nseDerivSpreadData =
        await databaseInstance.rawQuery('SELECT * FROM SpreadMaster');
        derivData.addAll(nseDerivSpreadData);
        derivData.length;
        Dataconstants.exchData[1].addAllNseDeriv(derivData);
      }
      if (isMasterDownload)
        sendProgressResponse(0.95);
      else
        sendProgressResponse(0.6);
      // #endregion

      // // #region Nse Deriv Spread
      // if (tableNames.contains('SpreadMaster')) {
      //   await databaseInstance.rawQuery(
      //       "CREATE TABLE SpreadMaster AS SELECT * FROM mst.SpreadMaster");
      //   var nseDerivSpreadData =
      //   await databaseInstance.rawQuery('SELECT * FROM SpreadMaster');
      //   Dataconstants.exchData[1].addAllNseDerivSpread(nseDerivSpreadData);
      // }
      // if (isMasterDownload)
      //   sendProgressResponse(0.95);
      // else
      //   sendProgressResponse(0.6);
      // // #endregion

      // await databaseInstance.rawQuery(
      //     "CREATE TABLE SpreadMaster AS SELECT * FROM mst.SpreadMaster");

      // #region Nse Currency
      if (tableNames.contains('NseCurrDerivMaster')) {
        await databaseInstance.rawQuery(
            "CREATE TABLE NseCurrDerivMaster AS SELECT * FROM mst.NseCurrDerivMaster");
        var nseCurrData = await databaseInstance.rawQuery(
            "SELECT * FROM NseCurrDerivMaster where Name like '%INR%' ");
        Dataconstants.exchData[3].addAllNseCurrDeriv(nseCurrData);
      }
      if (isMasterDownload)
        sendProgressResponse(0.97);
      else
        sendProgressResponse(0.7);
      // #endregion

      // #region Bse Currency
      //--------------------------bse currency wwill not be seen in serach--------------------------------------------------------------
      if (tableNames.contains('BseCurrDerivMaster')) {
        await databaseInstance.rawQuery(
            "CREATE TABLE BseCurrDerivMaster AS SELECT * FROM mst.BseCurrDerivMaster");
        var bseCurrData =
            await databaseInstance.rawQuery('SELECT * FROM BseCurrDerivMaster');
        Dataconstants.exchData[4].addAllBseCurrDeriv(bseCurrData);
      }
      //----------------------------------------------------------------------------------------
      if (isMasterDownload)
        sendProgressResponse(0.98);
      else
        sendProgressResponse(0.8);
      // #endregion

      // await databaseInstance.rawQuery(
      //     "CREATE TABLE CurrSpreadMaster AS SELECT * FROM mst.CurrSpreadMaster");

      // #region Mcx
      if (tableNames.contains('MCXCommodityDerivMaster')) {
        await databaseInstance.rawQuery(
            "CREATE TABLE MCXCommodityDerivMaster AS SELECT * FROM mst.MCXCommodityDerivMaster");
        var mcxData = await databaseInstance
            .rawQuery('SELECT * FROM MCXCommodityDerivMaster ');
        // //print("mcx data => $mcxData");
        Dataconstants.exchData[5].addAllMcx(mcxData);
      }
      if (isMasterDownload)
        sendProgressResponse(0.99);
      else
        sendProgressResponse(0.9);
      // #endregion

      // var nseDerivSpreadData = await db.rawQuery('SELECT * FROM SpreadMaster');
      // DataConstants.exchData[1].addAllNseDeriv(nseDerivSpreadData);

      await databaseInstance.rawQuery("DETACH DATABASE mst");
      _closeDb(databaseInstance);
      databaseInstance = null;
      sendProgressResponse(1.00);
      Dataconstants.iqsClient.createHeaderRecord('DEVESH');
      Dataconstants.iqsClient.disconnect();
      Dataconstants.iqsClient.connect();
      // Dataconstants.newsClient = NewsClient.getInstance();
      // Dataconstants.newsClient.connect();
      return true;
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
      _closeDb(databaseInstance);
      databaseInstance = null;
      Dataconstants.iqsClient.createHeaderRecord('DEVESH');
      Dataconstants.iqsClient.disconnect();
      Dataconstants.iqsClient.connect();
      // Dataconstants.newsClient = NewsClient.getInstance();
      // Dataconstants.newsClient.connect();
      return false;
    }
  }
}
