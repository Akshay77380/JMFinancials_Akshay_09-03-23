import 'dart:io';

import 'package:googleapis/cloudsearch/v1.dart';
import 'package:intl/intl.dart';
import 'package:markets/util/DateUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/news_record_model.dart';
import '../model/scripStaticModel.dart';
import '../util/Dataconstants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NewsDatabase {
  static const _databaseName = "news.db";
  static const _databaseVersion = 6;
  static Database _database;
  static bool dbInitialized = false;

  NewsDatabase._privateConstructor();

  static final NewsDatabase instance = NewsDatabase._privateConstructor();

  // only have a single app-wide reference to the database
  Future<void> initDB() async {
    if (dbInitialized) return;
    bool checkNewsDate = false;
    var path = join(await getDatabasesPath(), _databaseName);
    File newsFile = File(path);
    if (newsFile.existsSync()) checkNewsDate = true;
    _database = await openDatabase(path, version: _databaseVersion,
        onCreate: (Database db, int version) async {
          int date =
              DateTime.now().difference(Dataconstants.exchStartDate).inSeconds;
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE News (Category varchar(30), NewsDescription varchar(1000), CompanyName varchar(50), NseCode int, BseCode int, NewsDate int, actualDate TEXT)');
          await db.execute('CREATE TABLE NewsCreationDate (Date int)');
          await db.transaction((txn) async {
            await txn
                .rawInsert('INSERT INTO NewsCreationDate (Date) VALUES ($date)');
          });
        }, onUpgrade: (Database db, int version, int tp) async {
          int date =
              DateTime.now().difference(Dataconstants.exchStartDate).inSeconds;

          await db.execute('DROP TABLE IF EXISTS News');
          await db.execute('DROP TABLE IF EXISTS NewsCreationDate');
          await db.execute('CREATE TABLE NewsCreationDate (Date int)');
          await db.transaction((txn) async {
            await txn
                .rawInsert('INSERT INTO NewsCreationDate (Date) VALUES ($date)');
          });
        });
    if (checkNewsDate) {
      int masterDate = 0;
      try {
        masterDate = Sqflite.firstIntValue(
            await _database.rawQuery('SELECT Date from NewsCreationDate'));
      } catch (ex) {}
      DateTime date =
      Dataconstants.exchStartDate.add(Duration(seconds: masterDate));
      if (DateTime.now().difference(date) > Duration(days: 30)) {
        if (_database != null && _database.isOpen) _database.close();
        newsFile.deleteSync();
        _database = await openDatabase(path, version: _databaseVersion,
            onCreate: (Database db, int version) async {
              int date =
                  DateTime.now().difference(Dataconstants.exchStartDate).inSeconds;
              // When creating the db, create the table
              await db.execute(
                  'CREATE TABLE News (Category varchar(30), NewsDescription varchar(1000), CompanyName varchar(50), NseCode int, BseCode int, NewsDate int, actualDate TEXT)');
              await db.execute('CREATE TABLE NewsCreationDate (Date int)');
              await db.transaction((txn) async {
                await txn.rawInsert(
                    'INSERT INTO NewsCreationDate (Date) VALUES ($date)');
              });
            });
      }
      dbInitialized = true;
    }
  }

  void addToNewsTable(NewsRecordModel newsRecord) async {
    try {
      var date1 = DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(date1);
      // //print(formattedDate);
      String query =
          'INSERT INTO News (Category, NewsDescription, CompanyName, NseCode, BseCode, NewsDate, actualDate) VALUES("${newsRecord.category}","${newsRecord.description}","${newsRecord.companyName}",${newsRecord.nseCode},${newsRecord.bseCode},${newsRecord.date},$formattedDate)';
      await _database.transaction((txn) async {
        await txn.rawInsert(query);
      });
    } catch (e) {
      // //print(e);
    }
  }

  void addToNewsTableBulk(List<NewsRecordModel> data) async {
    try {
      await _database.transaction((txn) async {
        Batch batch = txn.batch();
        var date1 = DateTime.now();
        var formatter = new DateFormat('dd-MM-yyyy');
        String formattedDate = formatter.format(date1);
        // //print(formattedDate);
        if (data.length > 0) {
          for (var element in data) {
            var newsdata = {
              'Category': element.category,
              'NewsDescription': element.description,
              'CompanyName': element.companyName,
              'NseCode': element.nseCode,
              'BseCode': element.bseCode,
              'NewsDate': element.date,
              'actualDate': formattedDate,
            };
            batch.insert('News', newsdata);

            // //print("news data - $newsdata");
          }
        }
        await batch.commit(noResult: true);
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString("lastNewsDate", formattedDate);
        loadAllNews();
      });
    } catch (e) {
      // //print(e);
    }
  }

  cleanOldNews() async {
    try {
      var today = DateTime.now();
      // //print(DateTime(today.year, today.month, today.day).toString());
      var date = DateTime(today.year, today.month, today.day)
          .difference(Dataconstants.exchStartDate)
          .inSeconds;
      var date1 = DateTime.now();
      var formatter = new DateFormat('dd-MM-yyyy');
      String formattedDate = formatter.format(date1);
      // //print(formattedDate);
      // var results = await _database.rawQuery(
      //     'SELECT * from News where actualDate = "$formattedDate" order by NewsDate DESC');
      // //print(results.length);
      // String query;
      // query =
      //     'DELETE from News WHERE actualDate = "$formattedDate" AND NseCode = 0';
      await _database.transaction((txn) async {
        await txn.rawDelete(
          'DELETE FROM News WHERE actualDate = ?',
          [formattedDate],
        );
        // await txn.rawQuery('vacuum');
      });
      // var results2 = await _database.rawQuery(
      //     'SELECT * from News where actualDate = "$formattedDate" order by NewsDate DESC');
      // //print(results2);
      // var count = Sqflite.firstIntValue(await _database.rawQuery(
      //     'select Count(*) from News where actualDate = "$formattedDate"'));
      // //print("after deleting news - $count");
      return true;
    } catch (e) {
      // //print(e);
      return false;
    }
  }

  Future<int> getLastestDate() async {
    try {
      await cleanOldNews();
      var count = Sqflite.firstIntValue(
          await _database.rawQuery('select Count(*) from News'));
      if (count <= 0)
        return 0;
      else {
        var date;
        var results = await _database
            .rawQuery('SELECT * from News order by NewsDate DESC limit 1');
        //print(results.length);
        date = DateUtil.getIntFromDate2(results[0]["actualDate"]);
        return date;
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // var latestDate = prefs.get("lastNewsDate");
        // if (latestDate == null) {
        //   var date1 = DateTime.now();
        //   var formatter = new DateFormat('dd-MM-yyyy');
        //   String formattedDate = formatter.format(date1);
        //   date = DateUtil.getIntFromDate2(formattedDate);
        //   return date;
        // } else {
        //   date = DateUtil.getIntFromDate2(latestDate);
        //   return date;
        // }
        // return Sqflite.firstIntValue(
        //     await _database.rawQuery('select max(NewsDate) from News'));
      }
    } catch (e) {
      // //print(e);
      return 0;
    }
  }

  Future<List<NewsRecordModel>> getTodayNews() async {
    try {
      var now = DateTime.now();
      int date = DateTime(now.year, now.month, now.day)
          .difference(Dataconstants.exchStartDate)
          .inSeconds;
      var results = await _database.rawQuery(
          'SELECT * from News where NewsDate>=$date order by NewsDate DESC');
      List<NewsRecordModel> todayNews = [];
      for (int i = 0; i < results.length; i++) {
        ScripStaticModel model;
        if (0 < results[i]['NseCode'])
          model =
              Dataconstants.exchData[0].getStaticModel(results[i]['NseCode']);
        else if (0 < results[i]['BseCode'])
          model =
              Dataconstants.exchData[2].getStaticModel(results[i]['BseCode']);
        var newsFlag = false;
        todayNews.forEach((news) {
          if (news.description == results[i]['NewsDescription'])
            newsFlag = true;
        });
        if (!newsFlag)
          todayNews.add(NewsRecordModel.init(
            results[i]['Category'],
            results[i]['CompanyName'],
            results[i]['NewsDescription'],
            results[i]['NseCode'],
            results[i]['BseCode'],
            results[i]['NewsDate'],
            model,
          ));
      }
      return todayNews;
    } catch (e) {
      // //print(e);
      return [];
    }
  }

  loadAllNews() async {
    Dataconstants.allNews =
    await _database.rawQuery("SELECT * from News order by NewsDate DESC");
    // //print("All news count ${Dataconstants.allNews.length}");
  }

  Future<List<NewsRecordModel>> getScripNews(int nseCode) async {
    try {
      // var results = await _database.rawQuery(
      //     "SELECT * from News where NseCode='$nseCode' order by NewsDate DESC");
      List<NewsRecordModel> scripNews = [];
      ScripStaticModel model =
      Dataconstants.exchData[0].getStaticModel(nseCode);
      for (int i = 0; i < Dataconstants.allNews.length; i++) {
        if (Dataconstants.allNews[i]["NseCode"] == nseCode) {
          var newRecord = NewsRecordModel.init(
            Dataconstants.allNews[i]['Category'],
            Dataconstants.allNews[i]['CompanyName'],
            Dataconstants.allNews[i]['NewsDescription'],
            Dataconstants.allNews[i]['NseCode'],
            Dataconstants.allNews[i]['BseCode'],
            Dataconstants.allNews[i]['NewsDate'],
            model,
          );
          // //print(newRecord);
          scripNews.add(newRecord);
        }
      }
      return scripNews;
    } catch (e) {
      // //print(e);
      return [];
    }
  }
  List<NewsRecordModel> getScripNewsForPortfolio(int nseCode) {
    try {
      // var results = await _database.rawQuery(
      //     "SELECT * from News where NseCode='$nseCode' order by NewsDate DESC");
      List<NewsRecordModel> scripNews = [];
      ScripStaticModel model =
      Dataconstants.exchData[0].getStaticModel(nseCode);
      for (int i = 0; i < Dataconstants.allNews.length; i++) {
        if (Dataconstants.allNews[i]["NseCode"] == nseCode) {
          var newRecord = NewsRecordModel.init(
            Dataconstants.allNews[i]['Category'],
            Dataconstants.allNews[i]['CompanyName'],
            Dataconstants.allNews[i]['NewsDescription'],
            Dataconstants.allNews[i]['NseCode'],
            Dataconstants.allNews[i]['BseCode'],
            Dataconstants.allNews[i]['NewsDate'],
            model,
          );
          print(newRecord);
          // print('check----->${Dataconstants.allNews}');
          scripNews.add(newRecord);
        }
      }
      return scripNews;
    } catch (e) {
      // //print(e);
      return [];
    }
  }
}

