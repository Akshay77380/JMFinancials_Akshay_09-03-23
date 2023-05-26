import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as paths;
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import 'DerivativeControllerClass.dart';
import 'EquityAndDerivativeIndicatorData.dart';
import 'EquityControllerClass.dart';

String nseEquityTable = 'MST_N_NseEquity';

String nseDerivativeTable = 'MST_D_NseDeriv';

String nseGroupMember = 'MST_GroupMember';

String equityIndicatorsTable = 'EquityIndicators';

String derivativeIndicatorsTable = 'DerivativeIndicators';

String descColumnName = 'Desc';

String liveFeedClass = 'LiveFeedData';
Directory mastersDataDirectory;

class SqliteDatabse {
  static Database _database;
  var filePath = '';

  Future<bool> checkDbInStorage(filePath) async {
    try {
      filePath = filePath.replaceAll('.zip', '.db');
      var parentDirectory = mastersDataDirectory;
      var files = parentDirectory.listSync();
      List<FileSystemEntity> listOfFiles = [];
      for (var i = 0; i < files.length; i++) {
        var fileType = files[i].runtimeType;
        if (fileType.toString() == "_File") {
          listOfFiles.add(files[i]);
        }
      }
      var filePresent = false;
      for (var i = 0; i < listOfFiles.length; i++) {
        var currentFIleName = paths.basename(listOfFiles[i].path);
        if (filePath == currentFIleName) {
          filePresent = true;
          filePath = paths.basename(listOfFiles[i].path);
        }
      }
      return filePresent;
    } catch (e, stackTrace) {
      // CommonFunction.sendDataToCrashlytics(
      //     e, stackTrace, 'SqliteDatabase-checkDbInStorage Exception');
      return false;
    }
  }

  bool isValidDate(String input) {
    try {
      DateTime.parse(input);
      return true;
    } catch (e, stackTrace) {
      // CommonFunction.sendDataToCrashlytics(
      //     e, stackTrace, 'SqliteDatabase-isValidDate Exception');
      return false;
    }
  }

  Future<String> getPresentFilePath(filePath) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      var parentDirectory = directory.parent;
      var files = parentDirectory.listSync();
      List<FileSystemEntity> listOfFiles = [];
      for (var i = 0; i < files.length; i++) {
        var fileType = files[i].runtimeType;
        if (fileType.toString() == "_File") {
          listOfFiles.add(files[i]);
        }
      }

      for (var i = 0; i < listOfFiles.length; i++) {
        var currentFIleName = paths.basename(listOfFiles[i].path);
        if (filePath == currentFIleName) {
          filePath = listOfFiles[i].path;
        }
      }
      return filePath;
    } catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-getPresentFilePath Exception');
      return "";
    }
  }

  Future<Database> initializeDatabaseFromPath(String path) async {
    try {
      CommonFunction.writeLogInInternalMemory(
          'LaunchWidget', 'loadDatabaseData', 'Database opening path' + path);
      Dataconstants.globalFilePath = path;
      _database = await openDatabase(path, version: 2);

      return _database;
    } catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-initializeDatabaseFromPath Exception');
      return null;
    }
  }

  Future<void> addColumn() async {
    List<String> list = [];
    if (_database == null) {
      _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
    }
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('PRAGMA table_info($nseDerivativeTable)');
    list = (List.generate(
      maps.length,
      (i) {
        return maps[i]['name'];
      },
    ));
    try {
      if (list.contains('Desc') == false) {
        list.clear();

        await _database.rawQuery(
            'ALTER TABLE $nseDerivativeTable ADD COLUMN $descColumnName TEXT');
        await _database
            .execute('CREATE INDEX desc_index ON $nseDerivativeTable(desc)');
        // String Query="Update"+nseDerivativeTable+"set";
        String date =
            'case substr(Expiry,6,2) when \"01\" then \"JAN\" when \"02\" then \"FEB\" when \"03\" then \"MAR\" when \"04\" then \"APR\"  when \"05\" then \"MAY\" when \"06\" then \"JUN\" when \"07\" then \"JUL\" when \"08\" then \"AUG\" when \"09\" then \"SEP\" when \"10\" then \"OCT\" when \"11\" then \"NOV\" else \"DEC\" end';
        String fUT = 'substr(Expiry,9,2) ||\" \"||' +
            date +
            '||\" \"|| substr(Expiry,1,4) ';
        String cEPE = 'substr(Expiry,9,2) ||\" \"||' +
            date +
            '||\" \"||substr(Expiry,1,4)';
        //NOW FUT HANDLED IN API
        await _database.rawQuery(
            'UPDATE $nseDerivativeTable SET desc=(ULNAMe  || \" \" || CASE when CP IN (0,1,2) AND Expiry IN(Select DISTINCT Expiry FROM $nseDerivativeTable where CP=0) then $fUT  else $cEPE end ||\" \"||CASE CP when 0 then \"\" when 1 then \"CE\"||\" \" || CAST(Strike as INT) else \"PE\"||\" \" || CAST(Strike as INT) END)');
      }
      if (list.contains('Desc') == true) {
        String date =
            'case substr(Expiry,6,2) when \"01\" then \"JAN\" when \"02\" then \"FEB\" when \"03\" then \"MAR\" when \"04\" then \"APR\"  when \"05\" then \"MAY\" when \"06\" then \"JUN\" when \"07\" then \"JUL\" when \"08\" then \"AUG\" when \"09\" then \"SEP\" when \"10\" then \"OCT\" when \"11\" then \"NOV\" else \"DEC\" end';
        String fUT = 'substr(Expiry,9,2) ||\" \"||' +
            date +
            '||\" \"|| substr(Expiry,1,4) ';
        String cEPE = 'substr(Expiry,9,2) ||\" \"||' +
            date +
            '||\" \"||substr(Expiry,1,4)';

        // final List<Map<String, dynamic>> maps = await _database.rawQuery(
        //   'Select DISTINCT Expiry FROM $nseDerivativeTable where CP=0',
        // );
        // List<String> monthlyExpiry = [];
        // for (int i = 0; i < maps.length; i++) {
        //   monthlyExpiry.add(maps[i]['Expiry']);
        // }

        await _database.rawQuery(
            'UPDATE $nseDerivativeTable SET desc=(ULNAMe  || \" \" || CASE when CP IN (0,1,2) AND Expiry IN(Select DISTINCT Expiry FROM $nseDerivativeTable where CP=0) then $fUT  else $cEPE end ||\" \"||CASE CP when 0 then \"FUT\" when 1 then \"CE\"||\" \" || CAST(Strike as INT) else \"PE\"||\" \" || CAST(Strike as INT) END)');
      }
    } catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-addColumn Exception');
    }
  }

  Future<List<EquityControllerClass>> getEquitydata() async {
    List<EquityControllerClass> datalist = [];
    try {
      // _database = await db.database;
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      // _database = await db.database;
      if (_database != null) {
        var res = _database.path;
        var res1 = res.split("/");
        var dbName = res1[res1.length - 1];
        if (dbName != 'Can not fetch url') {
          final List<Map<String, dynamic>> maps =
              await _database.query(nseEquityTable);

          for (var i = 0; i < maps.length; i++) {
            var masterList = new EquityControllerClass(
              scCode: maps[i]['ScCode'] ?? 0,
              scName: maps[i]['Name'] ?? "",
              date: maps[i]['Date'] ?? "",
              open: maps[i]['OpenPrice'] ?? 0.0,
              high: maps[i]['HighPrice'] ?? 0.0,
              low: maps[i]['LowPrice'] ?? 0.0,
              close: maps[i]['ClosePrice'] ?? 0.0,
              qty: maps[i]['Qty'] ?? 0,
              value: maps[i]['Value'] ?? 0.0,
              trades: maps[i]['Trade'] ?? 0.0,
              pOpen: maps[i]['POpen'] ?? 0.0,
              pHigh: maps[i]['PHigh'] ?? 0.0,
              pLow: maps[i]['PLow'] ?? 0.0,
              pClose: maps[i]['PClose'] ?? 0.0,
              desc: maps[i]['SDescription'] ?? "",
              pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
                  ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
                          maps[i]['PClose']) *
                      100
                  : 0.0,
              pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
            );
            datalist.add(masterList);
          }
        }
      }

      CommonFunction.writeLogInInternalMemory(
          'LaunchWidget',
          'loadDatabaseData',
          'Equity data loaded with ' + datalist.length.toString());
      return datalist;
    } catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-getEquitydata Exception');
      CommonFunction.writeLog(
        'SqliteDatabase',
        'getEquitydata',
        e.toString(),
      );
      return [];
    }
  }




  //
  // Future<void> _updateEquityMaster2(List<EquityControllerClass> eqLive) async {
  //   try {
  //     EquityControllerClass eq = new EquityControllerClass();
  //     int pos = -1;
  //     for (var i = 0; i < eqLive.length; i++) {
  //       eq = eqLive[i];
  //
  //       ScripInfoModel model = new ScripInfoModel();
  //       model.exchCode = eq.scCode;
  //       // final scripPos = DataConstants.exchData[0].scripPos(model.exchCode);
  //       // model = DataConstants.exchData[1]
  //       //     .getModel(DataConstants.exchData[0].scPosMap[deriv.scCode]);
  //       pos = DataConstants.exchData[0].scPosMap[eq.scCode];
  //       model = DataConstants.exchData[0].scripData[pos];
  //       // if (model.exchCode == 54816) {
  //       //   //print('object');
  //       // }
  //       if (model.lastTradeTime == 0) {
  //         model.prevDayOpen = model.open;
  //         model.prevDayHigh = model.high;
  //         model.prevDayLow = model.low;
  //         model.prevDayClose = model.close;
  //       }
  //       model.lastTradeTime = eq.lastticktime;
  //       model.open = eq.open;
  //       model.high = eq.high;
  //       model.low = eq.low;
  //       model.close = eq.close;
  //       model.exchQty = eq.qty;
  //       model.percentChange = CommonFunction.roundDouble(
  //           eq.close != 0 && model.prevDayClose != 0
  //               ? ((eq.close - model.prevDayClose) / model.prevDayClose) * 100
  //               : 0.0,
  //           2);
  //
  //       //DataConstants.exchData[0].updateModel(model, scripPos);
  //     }
  //     eqLive.clear();
  //   } catch (e, stackTrace) {
  //     CommonFunction.sendDataToCrashlytics(
  //         e, stackTrace, 'SqliteDatabase-_updateDerivMaster');
  //     CommonFunction.writeLog(
  //       'SqliteDatabase',
  //       '_updateDerivMaster',
  //       e.toString(),
  //     );
  //   }
  // }

  // Future<void> getDerivativeMaster() async {
  //   try {
  //     if (_database == null) {
  //       _database = await initializeDatabaseFromPath(DataConstants.globalFilePath);
  //     }
  //     // List<Map<String, dynamic>> maps = await _database.rawQuery(
  //     //     'Select * FROM $nseDerivativeTable WHERE ClosePrice<>0 and PClose<>0  ORDER BY Code asc');
  //     List<Map<String, dynamic>> maps = await _database
  //         .rawQuery('Select * FROM $nseDerivativeTable ORDER BY Code asc');
  //     int eI = DataConstants.eINseDeriv;
  //     DataConstants.exchData[eI].resizeScripData(maps.length);
  //     int cp;
  //     var i = 0;
  //     bool premium = Global.productType.index > ProductType.Pro.index;
  //     DerivativeController deriv = new DerivativeController();
  //
  //     for (i = 0; i < maps.length; i++) {
  //       deriv.qty = maps[i]['Qty'];
  //       deriv.trdOI = maps[i]['TrdOI'];
  //       deriv.pTrdOI = maps[i]['PTrdOI'].toInt();
  //       deriv.pOpen = maps[i]['POpen'];
  //       deriv.pHigh = maps[i]['PHigh'];
  //       deriv.pLow = maps[i]['PLow'];
  //       deriv.pClose = maps[i]['PClose'];
  //       deriv.open = maps[i]['OpenPrice'];
  //       deriv.high = maps[i]['HighPrice'];
  //       deriv.low = maps[i]['LowPrice'];
  //       deriv.close = maps[i]['ClosePrice'];
  //       deriv.value = maps[i]['Value'];
  //       /*var deriv = new DerivativeController(
  //           scName: maps[i]['ULNAME'],
  //           scCode: maps[i]['Code'],
  //           expiry: maps[i]['Expiry'],
  //           cp: maps[i]['CP'] == '1'
  //               ? 'CE'
  //               : maps[i]['CP'] == '2'
  //                   ? 'PE'
  //                   : 'FUT',
  //           strike: maps[i]['Strike'],
  //           lotSize: maps[i]['LotSize'],
  //           date: maps[i]['Date'],
  //           open: maps[i]['OpenPrice'],
  //           high: maps[i]['HighPrice'],
  //           low: maps[i]['LowPrice'],
  //           close: maps[i]['ClosePrice'],
  //           qty: maps[i]['Qty'],
  //           value: maps[i]['Value'],
  //           trdOI: maps[i]['TrdOI'],
  //           pOpen: maps[i]['POpen'],
  //           pHigh: maps[i]['PHigh'],
  //           pLow: maps[i]['PLow'],
  //           pClose: maps[i]['PClose'],
  //           pTrdOI: maps[i]['PTrdOI'],
  //           pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
  //               ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
  //                       maps[i]['PClose']) *
  //                   100
  //               : 0.0,
  //           pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
  //           desc: maps[i]['Desc'],
  //           exchange: 'D',
  //           lastticktime: maps[i]['LastTickTime']);*/
  //
  //       /*DataConstants.exchData[1].scripData[i].exch = 'N';
  //       DataConstants.exchData[1].scripData[i].exchCode = maps[i]['Code'];
  //       DataConstants.exchData[1].scripData[i].name = maps[i]['ULNAME'];
  //       DataConstants.exchData[1].scripData[i].desc = maps[i]['Desc'];
  //       DataConstants.exchData[1].scripData[i].strikePrice = maps[i]['Strike'];
  //       cp = maps[i]['CP'] == '1'
  //           ? 'CE'
  //           : maps[i]['CP'] == '2'
  //               ? 'PE'
  //               : 'FUT';
  //       if (cp == 'FUT')
  //         DataConstants.exchData[1].scripData[i].exchCategory =
  //             ExchCategory.nseFuture;
  //       else
  //         DataConstants.exchData[1].scripData[i].exchCategory =
  //             ExchCategory.nseOptions;*/
  //
  //       ScripInfoModel model = new ScripInfoModel();
  //       model.exch = 'N';
  //       model.exchCode = maps[i]['Code'];
  //       // if (model.exchCode == 54816) {
  //       //   //print('object');
  //       // }
  //       model.name = maps[i]['ULNAME'];
  //       model.desc = maps[i]['Desc'];
  //       model.close = maps[i]['ClosePrice'];
  //       model.prevDayOpen = deriv.pOpen;
  //       model.prevDayHigh = deriv.pHigh;
  //       model.prevDayLow = deriv.pLow;
  //       model.prevDayClose = deriv.pClose;
  //       model.date = maps[i]['Date'];
  //       model.percentChange = CommonFunction.roundDouble(
  //           maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
  //               ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
  //                       maps[i]['PClose']) *
  //                   100
  //               : 0.0,
  //           2);
  //       model.exchQty = deriv.qty;
  //       model.openInt = deriv.trdOI;
  //       model.lastTradeTime = maps[i]['LastTickTime'];
  //       if (premium) {
  //         if (maps[i]['LastTickTime'] != 0)
  //           model.prevOpenInterest = deriv.pTrdOI;
  //         else {
  //           model.prevOpenInterest = deriv.trdOI;
  //           model.prevDayOpen = deriv.open;
  //           model.prevDayHigh = deriv.high;
  //           model.prevDayLow = deriv.low;
  //           model.prevDayClose = deriv.close;
  //         }
  //       } else {
  //         model.prevOpenInterest = deriv.pTrdOI;
  //       }
  //       model.strikePrice = maps[i]['Strike'];
  //       model.expiryDate = maps[i]['Expiry'];
  //       model.expiry =
  //           CommonFunction.datetointchart(DateTime.parse(maps[i]['Expiry']));
  //       cp = maps[i]['CP'] == '1'
  //           ? 1
  //           : maps[i]['CP'] == '2'
  //               ? 2
  //               : 0;
  //       model.cpType = cp;
  //       if (cp == 0) {
  //         model.exchCategory = ExchCategory.nseFuture;
  //
  //         if (DataConstants.exchData[eI].scPosFutMap[model.name] == null)
  //           DataConstants.exchData[eI].scPosFutMap[model.name] = [];
  //
  //         DataConstants.exchData[eI].scPosFutMap[model.name].add(i);
  //       } else {
  //         model.exchCategory = ExchCategory.nseOptions;
  //         if (DataConstants.exchData[eI].scPosOptMap[model.name] == null)
  //           DataConstants.exchData[eI].scPosOptMap[model.name] = [];
  //         DataConstants.exchData[eI].scPosOptMap[model.name].add(i);
  //       }
  //       DataConstants.exchData[eI].updateModel(model, i);
  //       // DataConstants.exchData[1].scripDataMap[maps[i]['Code']] = null;
  //       DataConstants.exchData[eI].scPosMap[model.exchCode] = i;
  //       // if (!Global.symbolsName
  //       //     .contains(DataConstants.exchData[1].scripData[i].name)) {
  //       //   Global.symbolsName.add(DataConstants.exchData[1].scripData[i].name);
  //       // }
  //     }
  //     // Global.symbolsName.clear();
  //     // for (var i = 0; i < DataConstants.exchData[1].scripData.length; i++) {
  //     //   if (!Global.symbolsName
  //     //       .contains(DataConstants.exchData[1].scripData[i].name)) {
  //     //     Global.symbolsName.add(DataConstants.exchData[1].scripData[i].name);
  //     //   }
  //     // }
  //     // Global.symbolsName.sort();
  //   } catch (e, stackTrace) {
  //     CommonFunction.writeLog(
  //       'SqliteDatabase',
  //       'getDerivativeMaster',
  //       e.toString(),
  //     );
  //     CommonFunction.sendDataToCrashlytics(
  //         e, stackTrace, 'SqliteDatabase-getDerivativeMaster Exception');
  //   }
  // }



  // Indicator data from exchange.db
  //
  Future<List<EquityAndDerivativeIndicatorClass>> getIndicatorData(
      int scCode, String exchange) async {
    try {
      List<EquityAndDerivativeIndicatorClass> list = [];

      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      if (_database != null) {
        var res = _database.path;
        var res1 = res.split("/");
        var dbName = res1[res1.length - 1];
        if (dbName != 'Can not fetch url') {
          final List<Map<String, dynamic>> maps = exchange == 'N'
              ? await _database.rawQuery(
                  'Select * FROM $equityIndicatorsTable where scCode=?',
                  [scCode])
              : await _database.rawQuery(
                  'Select * FROM $derivativeIndicatorsTable where scCode=?',
                  [scCode]);
          // listOfNames = result.map((e) => WatchListNameClass.fromJson(e)).toList();
          for (var i = 0; i < maps.length; i++) {
            var indicatorsList = new EquityAndDerivativeIndicatorClass(
              scCode: maps[i]['ScCode'],
              monPriceHighOnLastbar:
                  maps[i]['Mon   Price High On Last bar'] ?? 0,
              monPriceHighOnNthBackbar1:
                  maps[i]['Mon   Price High On Nth Back bar  1'] ?? 0,
              monPriceLowOnLastbar: maps[i]['Mon   Price Low On Last bar'] ?? 0,
              monPriceLowOnNthBackbar1:
                  maps[i]['Mon   Price Low On Nth Back bar  1'] ?? 0,
              wklyPriceHighOnNthBackbar1:
                  maps[i]['Wkl   Price High On Nth Back bar  1'] ?? 0,
              wklyPriceLowOnNthBackbar1:
                  maps[i]['Wkl   Price Low On Nth Back bar  1'] ?? 0,
              wklyPriceHighOnNthBackbar:
                  maps[i]['Wkl   Price High On Last bar'] ?? 0,
              dlyPriceHighOnNthBackbar4:
                  maps[i]['Dly   Price High On Nth Back bar  4'] ?? 0,
              dlyPriceLowOnNthBackbar2:
                  maps[i]['Dly   Price Low On Nth Back bar  2'] ?? 0,
              dlyPriceLowOnNthBackbar3:
                  maps[i]['Dly   Price Low On Nth Back bar  3'] ?? 0,
              dlyPriceLowOnNthBackbar1:
                  maps[i]['Dly   Price Low On Nth Back bar  1'] ?? 0,
              dlyPriceLowOnNthBackbar5:
                  maps[i]['Dly   Price Low On Nth Back bar  5'] ?? 0,
              dlyPriceHighOnNthBackbar5:
                  maps[i]['Dly   Price High On Nth Back bar  5'] ?? 0,
              dlyPriceLowOnNthBackbar4:
                  maps[i]['Dly   Price Low On Nth Back bar  4'] ?? 0,
              dlyPriceHighOnNthBakcBar2:
                  maps[i]['Dly   Price High On Nth Back bar  2'] ?? 0,
              dlyPriceHighOnNthBakcBar1:
                  maps[i]['Dly   Price High On Nth Back bar  1'] ?? 0,
              dlyPriceHighOnNthBakcBar3:
                  maps[i]['Dly   Price High On Nth Back bar  3'] ?? 0,
              wklyPriceLowOnNthBackbar:
                  maps[i]['Wkl   Price Low On Last bar'] ?? 0,
              fiftyTwoWeekHigh: maps[i]
                          ['Wkl   Price High Highest in N Bars  52   Value']
                      .toStringAsFixed(2) ??
                  "",
              fiftyTwoWeekLow: maps[i]
                          ['Wkl   Price Low Lowest in N Bars  52   Value']
                      .toStringAsFixed(2) ??
                  "",
              allTheTimeHigh: maps[i]
                          ['Yrl   Price High Highest in N Bars  50   Value']
                      .toStringAsFixed(2) ??
                  "",
              allTheTimeLow: maps[i]
                          ['Yrl   Price Low Lowest in N Bars  50   Value']
                      .toStringAsFixed(2) ??
                  "",
              closePriceDate:
                  maps[i]['Dly   Price Close On Last bar   Date'] ?? 0,
              closePriceValue:
                  maps[i]['Dly   Price Close On Last bar   Value'] ?? 0,
              prev1Day:
                  maps[i]['Dly   Price Close On Nth Back bar  1   Value'] ?? 0,
              wKlClosePriceValue:
                  maps[i]['Wkl   Price Close On Last bar   Value'] ?? 0,
              wKlPriceCloseOnNthBackBar1Value:
                  maps[i]['Wkl   Price Close On Nth Back bar  1   Value'] ?? 0,
              wKlPriceCloseOnNthBackBar2Value:
                  maps[i]['Wkl   Price Close On Nth Back bar  2   Value'] ?? 0,
              wKlPriceCloseOnNthBackBar3Value:
                  maps[i]['Wkl   Price Close On Nth Back bar  3   Value'] ?? 0,
              wKlPriceCloseOnNthBackBar4Value:
                  maps[i]['Wkl   Price Close On Nth Back bar  4   Value'] ?? 0,
              wKlPriceCloseOnNthBackBar5Value:
                  maps[i]['Wkl   Price Close On Nth Back bar  5   Value'] ?? 0,
              wKlPriceCloseOnNthBackBar6Value:
                  maps[i]['Wkl   Price Close On Nth Back bar  6   Value'] ?? 0,
              wKlPriceCloseOnNthBackBar7Value:
                  maps[i]['Wkl   Price Close On Nth Back bar  7   Value'] ?? 0,
              wKlPriceCloseOnNthBackBar8Value:
                  maps[i]['Wkl   Price Close On Nth Back bar  8   Value'] ?? 0,
              wKlPriceCloseOnNthBackBar9Value:
                  maps[i]['Wkl   Price Close On Nth Back bar  9   Value'] ?? 0,
              prev1Month:
                  maps[i]['Mon   Price Close On Nth Back bar  1   Value'] ?? 0,
              prev6Month:
                  maps[i]['Mon   Price Close On Nth Back bar  6   Value'] ?? 0,
              prev1Year:
                  maps[i]['Mon   Price Close On Nth Back bar  12   Value'] ?? 0,
              prev2Year:
                  maps[i]['HYr   Price Close On Nth Back bar  3   Value'] ?? 0,
              prev3Year:
                  maps[i]['HYr   Price Close On Nth Back bar  5   Value'] ?? 0,
              prev4Year:
                  maps[i]['HYr   Price Close On Nth Back bar  7   Value'] ?? 0,
              prev5Year:
                  maps[i]['HYr   Price Close On Nth Back bar  9   Value'] ?? 0,
              rsi: maps[i]['Dly   RSI(14,E,30) Rsi On Last bar   Value'] ?? 0,
              rsiAvg:
                  maps[i]['Dly   RSI(14,E,30) RsiAvg On Last bar   Value'] ?? 0,
              sma5: maps[i]['Dly   Avg(S,5)  On Last bar'] ?? 0,
              sma50: maps[i]['Dly   Avg(S,50)  On Last bar'] ?? 0,
              sma20: maps[i]['Dly   Avg(S,20)  On Last bar'] ?? 0,
              sma100: maps[i]['Dly   Avg(S,100)  On Last bar'] ?? 0,
              sma200: maps[i]['Dly   Avg(S,200)  On Last bar'] ?? 0,
              superTrend1:
                  maps[i]['Dly   STrend(1.000,10,0)  On Last bar'] ?? 0,
              superTrend2:
                  maps[i]['Dly   STrend(2.000,10,0)  On Last bar'] ?? 0,
              superTrend3:
                  maps[i]['Dly   STrend(3.000,10,0)  On Last bar'] ?? 0,
              vWap: maps[i]['Dly   AvgTP(1,N,-1.000)  On Last bar'] ?? 0,
              dlyVolOnLastbar: maps[i]['Dly   Vol  On Last bar'] ?? 0,
              dlyVolOnNthBackbar1:
                  maps[i]['Dly   Vol  On Nth Back bar  1'] ?? 0,
              dlyVolOnNthBackbar2:
                  maps[i]['Dly   Vol  On Nth Back bar  2'] ?? 0,
              priceCloseOnNthBackBar1Value:
                  maps[i]["Dly   Price Close On Nth Back bar  1   Value"] ?? 0,
              priceCloseOnNthBackBar2Value:
                  maps[i]["Dly   Price Close On Nth Back bar  2   Value"] ?? 0,
              priceCloseOnNthBackBar3Value:
                  maps[i]["Dly   Price Close On Nth Back bar  3   Value"] ?? 0,
              priceCloseOnNthBackBar4Value:
                  maps[i]["Dly   Price Close On Nth Back bar  4   Value"] ?? 0,
              priceCloseOnNthBackBar5Value:
                  maps[i]["Dly   Price Close On Nth Back bar  5   Value"] ?? 0,
              priceCloseOnNthBackBar6Value:
                  maps[i]["Dly   Price Close On Nth Back bar  6   Value"] ?? 0,
              priceCloseOnNthBackBar7Value:
                  maps[i]["Dly   Price Close On Nth Back bar  7   Value"] ?? 0,
              priceCloseOnNthBackBar8Value:
                  maps[i]["Dly   Price Close On Nth Back bar  8   Value"] ?? 0,
              priceCloseOnNthBackBar9Value:
                  maps[i]["Dly   Price Close On Nth Back bar  9   Value"] ?? 0,
              priceCloseOnNthBackBar2Date:
                  maps[i]["Dly   Price Close On Nth Back bar  2   Date"] ?? 0,
              priceCloseOnNthBackBar3Date:
                  maps[i]["Dly   Price Close On Nth Back bar  3   Date"] ?? 0,
              priceCloseOnNthBackBar4Date:
                  maps[i]["Dly   Price Close On Nth Back bar  4   Date"] ?? 0,
              priceCloseOnNthBackBar5Date:
                  maps[i]["Dly   Price Close On Nth Back bar  5   Date"] ?? 0,
              priceCloseOnNthBackBar6Date:
                  maps[i]["Dly   Price Close On Nth Back bar  6   Date"] ?? 0,
              priceCloseOnNthBackBar7Date:
                  maps[i]["Dly   Price Close On Nth Back bar  7   Date"] ?? 0,
              priceCloseOnNthBackBar8Date:
                  maps[i]["Dly   Price Close On Nth Back bar  8   Date"] ?? 0,
              priceCloseOnNthBackBar9Date:
                  maps[i]["Dly   Price Close On Nth Back bar  9   Date"] ?? 0,
              yRClosePriceValue:
                  maps[i]['Mon   Price Close On Last bar   Value'] ?? 0,
              yRPriceCloseOnNthBackBar1Value:
                  maps[i]['Mon   Price Close On Nth Back bar  1   Value'] ?? 0,
              yRPriceCloseOnNthBackBar2Value:
                  maps[i]['Mon   Price Close On Nth Back bar  2   Value'] ?? 0,
              yRPriceCloseOnNthBackBar3Value:
                  maps[i]['Mon   Price Close On Nth Back bar  3   Value'] ?? 0,
              yRPriceCloseOnNthBackBar4Value:
                  maps[i]['Mon   Price Close On Nth Back bar  4   Value'] ?? 0,
              yRPriceCloseOnNthBackBar5Value:
                  maps[i]['Mon   Price Close On Nth Back bar  5   Value'] ?? 0,
              yRPriceCloseOnNthBackBar6Value:
                  maps[i]['Mon   Price Close On Nth Back bar  6   Value'] ?? 0,
              yRPriceCloseOnNthBackBar7Value:
                  maps[i]['Mon   Price Close On Nth Back bar  7   Value'] ?? 0,
              yRPriceCloseOnNthBackBar8Value:
                  maps[i]['Mon   Price Close On Nth Back bar  8   Value'] ?? 0,
              yRPriceCloseOnNthBackBar9Value:
                  maps[i]['Mon   Price Close On Nth Back bar  9   Value'] ?? 0,
              yRPriceCloseOnNthBackBar10Value:
                  maps[i]['Mon   Price Close On Nth Back bar  10   Value'] ?? 0,
              yRPriceCloseOnNthBackBar11Value:
                  maps[i]['Mon   Price Close On Nth Back bar  11   Value'] ?? 0,
              yRPriceCloseOnNthBackBar12Value:
                  maps[i]['Mon   Price Close On Nth Back bar  12   Value'] ?? 0,
              fiveYrClosePriceValue:
                  maps[i]['HYr   Price Close On Last bar   Value'] ?? 0,
              fiveYrPriceCloseOnNthBackBar1Value:
                  maps[i]['HYr   Price Close On Nth Back bar  1   Value'] ?? 0,
              fiveYrPriceCloseOnNthBackBar2Value:
                  maps[i]['HYr   Price Close On Nth Back bar  2   Value'] ?? 0,
              fiveYrPriceCloseOnNthBackBar3Value:
                  maps[i]['HYr   Price Close On Nth Back bar  3   Value'] ?? 0,
              fiveYrPriceCloseOnNthBackBar4Value:
                  maps[i]['HYr   Price Close On Nth Back bar  4   Value'] ?? 0,
              fiveYrPriceCloseOnNthBackBar5Value:
                  maps[i]['HYr   Price Close On Nth Back bar  5   Value'] ?? 0,
              fiveYrPriceCloseOnNthBackBar6Value:
                  maps[i]['HYr   Price Close On Nth Back bar  6   Value'] ?? 0,
              fiveYrPriceCloseOnNthBackBar7Value:
                  maps[i]['HYr   Price Close On Nth Back bar  7   Value'] ?? 0,
              fiveYrPriceCloseOnNthBackBar8Value:
                  maps[i]['HYr   Price Close On Nth Back bar  8   Value'] ?? 0,
              fiveYrPriceCloseOnNthBackBar9Value:
                  maps[i]['HYr   Price Close On Nth Back bar  9   Value'] ?? 0,
              yrlPriceHighHighestinNBars6:
                  maps[i]['Yrl   Price High Highest in N Bars  6'] ?? 0,
              yrlPriceLowLowestinNBars6:
                  maps[i]['Yrl   Price Low Lowest in N Bars  6'] ?? 0,
              dlyPriceOpenOnNthBackbar9999Date: maps[i]
                      ['Dly   Price Open On Nth Back bar  9999   Date'] ??
                  "",
              dlyPriceOpenOnNthBackbar9999:
                  maps[i]['Dly   Price Open On Nth Back bar  9999'] ?? 0,
              prev3Month:
                  maps[i]["Mon   Price Close On Nth Back bar  3   Value"] ?? 0,
              //Adding Datetime in Model
              priceCloseOnNthBackBar1Date: DateTime.parse(
                  maps[i]["Dly   Price Close On Nth Back bar  1   Date"]),
              wKlPriceCloseOnNthBackBar1Date: DateTime.parse(
                  maps[i]["Wkl   Price Close On Nth Back bar  1   Date"]),
              prev1MonthDate: DateTime.parse(
                  maps[i]["Mon   Price Close On Nth Back bar  1   Date"]),
              prev3MonthDate: DateTime.parse(
                  maps[i]["Mon   Price Close On Nth Back bar  3   Date"]),
              prev6MonthDate: DateTime.parse(
                  maps[i]["Mon   Price Close On Nth Back bar  6   Date"]),
              prev1YearDate: DateTime.parse(
                  maps[i]["Mon   Price Close On Nth Back bar  12   Date"]),
              prev2YearDate: DateTime.parse(
                  maps[i]["HYr   Price Close On Nth Back bar  3   Date"]),
              prev3YearDate: DateTime.parse(
                  maps[i]["HYr   Price Close On Nth Back bar  5   Date"]),
              prev4YearDate: DateTime.parse(
                  maps[i]["Mon   Price Close On Nth Back bar  6   Date"]),
              prev5YearDate: DateTime.parse(
                  maps[i]["HYr   Price Close On Nth Back bar  7   Date"]),
            );

            list.add(indicatorsList);
          }
          Dataconstants.equityAndDerivativeIndicatorList = list;
          return list;
        }
      }
      return list;
    } catch (e, stackTrace) {
      CommonFunction.writeLog(
        'SqliteDatabase',
        'getIndicatorData',
        e.toString(),
      );
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-getIndicatorData Exception');

      return [];
    }
  }

  Future<List<DerivativeController>> getderivativeDataByScCode(
      int scCode) async {
    try {
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      List<DerivativeController> data = [];
      List<Map<String, dynamic>> maps = await _database
          .rawQuery('Select * FROM $nseDerivativeTable where Code=?', [scCode]);

      for (var i = 0; i < maps.length; i++) {
        var derivateiveList = new DerivativeController(
            scName: maps[i]['ULNAME'],
            scCode: maps[i]['Code'],
            expiry: maps[i]['Expiry'],
            cp: maps[i]['CP'] == '1'
                ? 1
                : maps[i]['CP'] == '2'
                    ? 2
                    : 0,
            strike: maps[i]['Strike'],
            lotSize: maps[i]['LotSize'],
            date: maps[i]['Date'],
            open: maps[i]['OpenPrice'],
            high: maps[i]['HighPrice'],
            low: maps[i]['LowPrice'],
            close: maps[i]['ClosePrice'],
            qty: maps[i]['Qty'],
            value: maps[i]['Value'],
            trdOI: maps[i]['TrdOI'],
            pOpen: maps[i]['POpen'],
            pHigh: maps[i]['PHigh'],
            pLow: maps[i]['PLow'],
            pClose: maps[i]['PClose'],
            pTrdOI: maps[i]['PTrdOI'].toInt(),
            pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
                ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
                        maps[i]['PClose']) *
                    100
                : 0.0,
            pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
            desc: maps[i]['Desc'],
            exchange: 'D',
            lastticktime: maps[i]['LastTickTime']);
        data.add(derivateiveList);
      }
      return data;
    } catch (e, stackTrace) {
      CommonFunction.writeLog(
        'UserPreferenceDatabase',
        'deleteWatchlistdataById',
        e.toString(),
      );
      CommonFunction.sendDataToCrashlytics(e, stackTrace,
          'UserPreferenceDatabase-getderivativeDataByScCode Exception');
      return null;
    }
  }

  Future<List<DerivativeController>> getderivativeDataByDescription(
      String Description) async {
    try {
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      List<DerivativeController> data = [];
      List<Map<String, dynamic>> maps = await _database.rawQuery(
          "Select * FROM $nseDerivativeTable where Desc=\'$Description\'", []);

      for (var i = 0; i < maps.length; i++) {
        var derivateiveList = new DerivativeController(
            scName: maps[i]['ULNAME'],
            scCode: maps[i]['Code'],
            expiry: maps[i]['Expiry'],
            cp: maps[i]['CP'] == '1'
                ? 1
                : maps[i]['CP'] == '2'
                    ? 2
                    : 0,
            strike: maps[i]['Strike'],
            lotSize: maps[i]['LotSize'],
            date: maps[i]['Date'],
            open: maps[i]['OpenPrice'],
            high: maps[i]['HighPrice'],
            low: maps[i]['LowPrice'],
            close: maps[i]['ClosePrice'],
            qty: maps[i]['Qty'],
            value: maps[i]['Value'],
            trdOI: maps[i]['TrdOI'],
            pOpen: maps[i]['POpen'],
            pHigh: maps[i]['PHigh'],
            pLow: maps[i]['PLow'],
            pClose: maps[i]['PClose'],
            pTrdOI: maps[i]['PTrdOI'].toInt(),
            pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
                ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
                        maps[i]['PClose']) *
                    100
                : 0.0,
            pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
            desc: maps[i]['Desc'],
            exchange: 'D',
            lastticktime: maps[i]['LastTickTime']);
        data.add(derivateiveList);
      }
      return data;
    } catch (e, stackTrace) {
      CommonFunction.writeLog(
        'UserPreferenceDatabase',
        'deleteWatchlistdataById',
        e.toString(),
      );
      CommonFunction.sendDataToCrashlytics(e, stackTrace,
          'UserPreferenceDatabase-getderivativeDataByScCode Exception');
      return null;
    }
  }

  Future<List<DerivativeController>> getderivativeData(String scName) async {
    try {
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      List<DerivativeController> data = [];
      List<Map<String, dynamic>> maps = await _database.rawQuery(
          'Select * FROM $nseDerivativeTable where ULNAME=?', [scName]);

      for (var i = 0; i < maps.length; i++) {
        var derivateiveList = new DerivativeController(
            scName: maps[i]['ULNAME'],
            scCode: maps[i]['Code'],
            expiry: maps[i]['Expiry'],
            cp: maps[i]['CP'] == '1'
                ? 1
                : maps[i]['CP'] == '2'
                    ? 2
                    : 0,
            strike: maps[i]['Strike'],
            lotSize: maps[i]['LotSize'],
            date: maps[i]['Date'],
            open: maps[i]['OpenPrice'],
            high: maps[i]['HighPrice'],
            low: maps[i]['LowPrice'],
            close: maps[i]['ClosePrice'],
            qty: maps[i]['Qty'],
            value: maps[i]['Value'],
            trdOI: maps[i]['TrdOI'],
            pOpen: maps[i]['POpen'],
            pHigh: maps[i]['PHigh'],
            pLow: maps[i]['PLow'],
            pClose: maps[i]['PClose'],
            pTrdOI: maps[i]['PTrdOI'].toInt(),
            pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
                ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
                        maps[i]['PClose']) *
                    100
                : 0.0,
            pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
            desc: maps[i]['Desc'],
            exchange: 'D',
            lastticktime: maps[i]['LastTickTime']);
        data.add(derivateiveList);
      }
      return data;
    } catch (e, stackTrace) {
      CommonFunction.writeLog(
        'UserPreferenceDatabase',
        'deleteWatchlistdataById',
        e.toString(),
      );
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'UserPreferenceDatabase-getderivativeData Exception');
      return null;
    }
  }

  Future<List<DerivativeController>> getderivativeContainsData(
      String searchvalue, String scName) async {
    int cpType = 0;
    try {
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      List<DerivativeController> data = [];
      List<Map<String, dynamic>> maps = await _database.rawQuery(
          'Select * FROM $nseDerivativeTable where CP=? and ULNAME=?',
          [cpType, scName]);

      for (var i = 0; i < maps.length; i++) {
        var derivateiveList = new DerivativeController(
            scName: maps[i]['ULNAME'],
            scCode: maps[i]['Code'],
            expiry: maps[i]['Expiry'],
            cp: maps[i]['CP'] == '1'
                ? 1
                : maps[i]['CP'] == '2'
                    ? 2
                    : 0,
            strike: maps[i]['Strike'],
            lotSize: maps[i]['LotSize'],
            date: maps[i]['Date'],
            open: maps[i]['OpenPrice'],
            high: maps[i]['HighPrice'],
            low: maps[i]['LowPrice'],
            close: maps[i]['ClosePrice'],
            qty: maps[i]['Qty'],
            value: maps[i]['Value'],
            trdOI: maps[i]['TrdOI'],
            pOpen: maps[i]['POpen'],
            pHigh: maps[i]['PHigh'],
            pLow: maps[i]['PLow'],
            pClose: maps[i]['PClose'],
            pTrdOI: maps[i]['PTrdOI'].toInt(),
            pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
                ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
                        maps[i]['PClose']) *
                    100
                : 0.0,
            pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
            desc: maps[i]['Desc'],
            exchange: 'D',
            lastticktime: maps[i]['LastTickTime']);
        data.add(derivateiveList);
      }
      return data;
    } catch (e, stackTrace) {
      CommonFunction.writeLog(
        'UserPreferenceDatabase',
        'deleteWatchlistdataById',
        e.toString(),
      );
      CommonFunction.sendDataToCrashlytics(e, stackTrace,
          'UserPreferenceDatabase-getderivativeContainsData Exception');
      return null;
    }
  }

  Future<List<DerivativeController>> getderivativeExpiryData(
      int scCode, String scName, String expiry) async {
    try {
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      List<DerivativeController> data = [];
      List<Map<String, dynamic>> maps = await _database.rawQuery(
          'Select * FROM $nseDerivativeTable where ULNAME=? and Expiry=? and Strike!=?',
          [scName, expiry, 0]);

      for (var i = 0; i < maps.length; i++) {
        var derivateiveList = new DerivativeController(
            scName: maps[i]['ULNAME'],
            scCode: maps[i]['Code'],
            expiry: maps[i]['Expiry'],
            cp: maps[i]['CP'] == '1'
                ? 1
                : maps[i]['CP'] == '2'
                    ? 2
                    : 0,
            strike: maps[i]['Strike'],
            lotSize: maps[i]['LotSize'],
            date: maps[i]['Date'],
            open: maps[i]['OpenPrice'],
            high: maps[i]['HighPrice'],
            low: maps[i]['LowPrice'],
            close: maps[i]['ClosePrice'],
            qty: maps[i]['Qty'],
            value: maps[i]['Value'],
            trdOI: maps[i]['TrdOI'],
            pOpen: maps[i]['POpen'],
            pHigh: maps[i]['PHigh'],
            pLow: maps[i]['PLow'],
            pClose: maps[i]['PClose'],
            pTrdOI: maps[i]['PTrdOI'].toInt(),
            pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
                ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
                        maps[i]['PClose']) *
                    100
                : 0.0,
            pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
            desc: maps[i]['Desc'],
            exchange: 'D',
            lastticktime: maps[i]['LastTickTime']);

        data.add(derivateiveList);
      }
      return data;
    } catch (e, stackTrace) {
      CommonFunction.writeLog(
        'UserPreferenceDatabase',
        'deleteWatchlistdataById',
        e.toString(),
      );
      CommonFunction.sendDataToCrashlytics(e, stackTrace,
          'UserPreferenceDatabase-getderivativeExpiryData Exception');
      return null;
    }
  }

  Future<List<EquityControllerClass>> getEquitydataByName(String scName) async {
    try {
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      List<EquityControllerClass> data = [];
      final List<Map<String, dynamic>> maps = await _database
          .rawQuery('Select * FROM $nseEquityTable where Name=?', ['$scName']);
      // 'Select Code,ULNAME,ClosePrice,PClose,desc FROM $nseDerivativeTable where desc LIKE ? ',['%$value%']);
      for (var i = 0; i < maps.length; i++) {
        var masterList = new EquityControllerClass(
            scCode: maps[i]['ScCode'] ?? 0,
            scName: maps[i]['Name'] ?? "",
            date: maps[i]['Date'] ?? "",
            open: maps[i]['OpenPrice'] ?? 0.0,
            high: maps[i]['HighPrice'] ?? 0.0,
            low: maps[i]['LowPrice'] ?? 0.0,
            close: maps[i]['ClosePrice'] ?? 0.0,
            qty: maps[i]['Qty'] ?? 0,
            value: maps[i]['Value'] ?? 0.0,
            trades: maps[i]['Trade'] ?? 0.0,
            pOpen: maps[i]['POpen'] ?? 0.0,
            pHigh: maps[i]['PHigh'] ?? 0.0,
            pLow: maps[i]['PLow'] ?? 0.0,
            pClose: maps[i]['PClose'] ?? 0.0,
            desc: maps[i]['SDescription'] ?? "",
            pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
                ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
                        maps[i]['PClose']) *
                    100
                : 0.0,
            pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
            exchange: 'N',
            lastticktime: maps[i]['LastTickTime']);
        data.add(masterList);
      }
      return data;
    } catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-getEquitydataByName');
      CommonFunction.writeLog(
        'SqliteDatabase',
        'getEquitydata',
        e.toString(),
      );
      return [];
    }
  }

  Future<List<EquityControllerClass>> getEquitydataByScCode(int scCode) async {
    try {
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      List<EquityControllerClass> data = [];
      final List<Map<String, dynamic>> maps = await _database.rawQuery(
          'Select * FROM $nseEquityTable where ScCode=?', ['$scCode']);
      // 'Select Code,ULNAME,ClosePrice,PClose,desc FROM $nseDerivativeTable where desc LIKE ? ',['%$value%']);
      for (var i = 0; i < maps.length; i++) {
        var masterList = new EquityControllerClass(
            scCode: maps[i]['ScCode'] ?? 0,
            scName: maps[i]['Name'] ?? "",
            date: maps[i]['Date'] ?? "",
            open: maps[i]['OpenPrice'] ?? 0.0,
            high: maps[i]['HighPrice'] ?? 0.0,
            low: maps[i]['LowPrice'] ?? 0.0,
            close: maps[i]['ClosePrice'] ?? 0.0,
            qty: maps[i]['Qty'] ?? 0,
            value: maps[i]['Value'] ?? 0.0,
            trades: maps[i]['Trade'] ?? 0.0,
            pOpen: maps[i]['POpen'] ?? 0.0,
            pHigh: maps[i]['PHigh'] ?? 0.0,
            pLow: maps[i]['PLow'] ?? 0.0,
            pClose: maps[i]['PClose'] ?? 0.0,
            desc: maps[i]['SDescription'] ?? "",
            pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
                ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
                        maps[i]['PClose']) *
                    100
                : 0.0,
            pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
            exchange: 'N',
            lastticktime: maps[i]['LastTickTime']);
        data.add(masterList);
      }
      return data;
    } catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-getEquitydataByScCode Exception');
      CommonFunction.writeLog(
        'SqliteDatabase',
        'getEquitydata',
        e.toString(),
      );
      return [];
    }
  }


  Future<List<GroupMemberClass>> getGroupMemberist() async {
    try {
      // _database = await db.database;
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      // _database = await db.database;
      if (_database != null) {
        var res = _database.path;
        var res1 = res.split("/");
        var dbName = res1[res1.length - 1];
        if (dbName != 'Can not fetch url') {
          final List<Map<String, dynamic>> maps =
              await _database.query(nseGroupMember);

          for (var i = 0; i < maps.length; i++) {
            var groupMemberList = new GroupMemberClass(
              scCode: maps[i]['ScCode'] ?? 0,
              groupName: maps[i]['GroupName'] ?? "",
            );
            Dataconstants.groupList.add(groupMemberList);
          }
        }
      }

      CommonFunction.writeLogInInternalMemory(
          'LaunchWidget',
          'loadDatabaseData',
          'Equity data loaded with ' + Dataconstants.groupList.length.toString());
      return Dataconstants.groupList;
    } catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-getGroupMemberist Exception');
      CommonFunction.writeLog(
        'SqliteDatabase',
        'getGroupMemberdata',
        e.toString(),
      );
      return [];
    }
  }

  Future<List<EquityControllerClass>> getEquitydataByScCodes(
      String dropDown) async {
    try {
      if (_database == null) {
        _database = await initializeDatabaseFromPath(Dataconstants.globalFilePath);
      }
      List<EquityControllerClass> data = [];
      final List<Map<String, dynamic>> maps = await _database.rawQuery(
          // 'Select * FROM $nseEquityTable where ScCode IN ( ${scCode.join(',')})'
          "select * from MST_N_NseEquity INNER join MST_GroupMember on MST_N_NseEquity.ScCode=MST_GroupMember.ScCode where GroupName='$dropDown'");
      // 'Select Code,ULNAME,ClosePrice,PClose,desc FROM $nseDerivativeTable where desc LIKE ? ',['%$value%']);
      for (var i = 0; i < maps.length; i++) {
        var masterList = new EquityControllerClass(
            scCode: maps[i]['ScCode'] ?? 0,
            scName: maps[i]['Name'] ?? "",
            date: maps[i]['Date'] ?? "",
            open: maps[i]['OpenPrice'] ?? 0.0,
            high: maps[i]['HighPrice'] ?? 0.0,
            low: maps[i]['LowPrice'] ?? 0.0,
            close: maps[i]['ClosePrice'] ?? 0.0,
            qty: maps[i]['Qty'] ?? 0,
            value: maps[i]['Value'] ?? 0.0,
            trades: maps[i]['Trade'] ?? 0.0,
            pOpen: maps[i]['POpen'] ?? 0.0,
            pHigh: maps[i]['PHigh'] ?? 0.0,
            pLow: maps[i]['PLow'] ?? 0.0,
            pClose: maps[i]['PClose'] ?? 0.0,
            desc: maps[i]['SDescription'] ?? "",
            pcntChg: maps[i]['ClosePrice'] != 0 && maps[i]['PClose'] != 0
                ? ((maps[i]['ClosePrice'] - maps[i]['PClose']) /
                        maps[i]['PClose']) *
                    100
                : 0.0,
            pcntChgAbs: maps[i]['ClosePrice'] - maps[i]['PClose'],
            exchange: 'N',
            lastticktime: maps[i]['LastTickTime']);
        data.add(masterList);
      }
      return data;
    } catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-getEquitydataByScCodes Exception');
      CommonFunction.writeLog(
        'SqliteDatabase',
        'getEquitydata',
        e.toString(),
      );
      return [];
    }
  }





}
