import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:alice/alice.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:markets/style/theme.dart';
import 'package:path/path.dart' as paths;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trust_fall/trust_fall.dart';
import '../database/database_helper.dart';
import '../jmScreens/Scanners/SqliteDatabase.dart';
import '../jmScreens/Scanners/groupMember.dart';
import '../jmScreens/login/IntroScreens.dart';
import '../jmScreens/login/Login.dart';
import '../jmScreens/login/mobileScreen.dart';
import '../util/CommonFunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Connection/ResponseListener.dart';
import '../util/BrokerInfo.dart';
import '../util/ConnectionStatus.dart';
import '../util/Dataconstants.dart';
import 'package:flutter/material.dart';
import '../util/Utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// class _PiningSslData {
//   String serverURL = 'https://api.icicidirect.com';
//   Map<String, String> headerHttp = new Map();
//   String allowedSHAFingerprint =
//       'A4 20 9C 1B 2C DE 1A DA C3 FB  2E 77 E5 FF 1A 2E 5E 74 BA 19 E6 E9 B2 AF CE 11 03 53 C2 30 29 9D';
//   int timeout = 10;
//   SHA sha;
//   // String sha256 = 'A4 20 9C 1B 2C DE 1A DA C3 FB  2E 77 E5 FF 1A 2E 5E 74 BA 19 E6 E9 B2 AF CE 11 03 53 C2 30 29 9D';
// }

class _SplashScreenState extends State<SplashScreen> with ResponseListener {
  double value = 0;
  bool isForceUpdate = false;
  bool isOptionalUpdate = false;
  bool didGot = false;

  static Database _database;
  String tokenvalue = "";
  Directory directory, mastersDataDirectory;
  String folderName = 'MASTER', screenShotFolderName = 'Images';
  String equityIndicatorsTable = 'EquityIndicators';
  SqliteDatabse db = new SqliteDatabse();
  String labelvalue;
  BuildContext scaffoldContext;

  String derivativeIndicatorsTable = 'DerivativeIndicators';
  final  GlobalKey<ScaffoldMessengerState> _scaffoldKey = new GlobalKey<ScaffoldMessengerState>();
  var masterUrl =
      "https://scriptm.s3.ap-south-1.amazonaws.com/ScripMaster/Masters.mf";
      // "https://scriptm.s3.ap-south-1.amazonaws.com/ScripMaster/Masters.7z";
  var dio = Dio();

  checkMasters() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mastersDate = preferences.getString("MastersDate") ?? "";
    if (mastersDate == "") {
      DateTime now = DateTime.now();
      String MFdate = DateFormat("dd/MM/yyyy").format(now);
      await getMasters(MFdate);
      redirect();
    } else {
      var newDateFormat = new DateFormat("dd/MM/yyyy");
      var date1 = newDateFormat.parse(mastersDate);
      DateTime now = DateTime.now();
      String MFdate = DateFormat("dd/MM/yyyy").format(now);
      var date2 = newDateFormat.parse(MFdate);
      if (date1 != date2) {
        await getMasters(MFdate);
        redirect();
      } else {
        Future.delayed(Duration(milliseconds: 500), () {
          redirect();
        });
      }
    }
    Dataconstants.fileVersion = await CommonFunction.getVersionNumber();
  }

  @override
  void initState() {
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        // var isSSLSuccessful = await check(
        //     _data.serverURL,
        //     _data.allowedSHAFingerprint,
        //     SHA.SHA256,
        //     _data.headerHttp,
        //     _data.timeout);
        // if (isSSLSuccessful) {
        bool isJailBroken = await TrustFall.isJailBroken;
        bool isRealDevice = await TrustFall.isRealDevice;
        if (!kDebugMode && (isJailBroken || !isRealDevice)) {
          await CommonFunction.showAlert(
              Dataconstants.navigatorKey.currentContext,
              'Warning',
              'This application will not work on rooted devices');
          exit(0);
        }
      });
    });
    
    callMemberList(); //TODO: 21/12
    checkMasters();
    super.initState();
    // CommonFunction.getWatchListNames(4); //TODO: 21/12
    CommonFunction.removeAllCharts();
    getEvent();

    Dataconstants.fToast.init(Dataconstants.navigatorKey.currentContext);

    // Dataconstants.alice = Alice(
    //     navigatorKey: Dataconstants.navigatorKey,
    //     showNotification: true,
    //     showInspectorOnShake: true,
    //     showShareButton: true);

  }

  getEvent() async {

    CommonFunction.firebaseEvent(
      clientCode: "dummy",
      device_manufacturer: Dataconstants.deviceName,
      device_model: Dataconstants.devicemodel,
      eventId: "1.1.0.0.0",
      eventLocation: "body",
      eventMetaData: "dummy",
      eventName: "s_welcome_screen",
      os_version: Dataconstants.osName,
      location: "dummy",
      eventType:"impression",
      sessionId: "dummy",
      platform: Platform.isAndroid ? 'Android' : 'iOS',
      screenName: "welcome screen",
      serverTimeStamp: DateTime.now().toString(),
      source_metadata: "dummy",
      subType: "screen",
    );
  }

  checkIfFirstInstalled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fistInstall = prefs.getBool("firstInstall");
    if (fistInstall == null) {
      // Dataconstants.firstInstall = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("firstInstall", true);
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("firstInstall", false);
    }
  }

  callMemberList() async {
    await loadDatabaseData();
    await db.getGroupMemberist();
  }

  loadDatabaseData() async {
    await getToken().then((value) {
      getFileName().then((filePathFromServer) {
        if (filePathFromServer == '' ||
            filePathFromServer == null ||
            filePathFromServer == 'error') {
          if (loadOldData() == '') {
            showDialog(
              context: scaffoldContext,
              builder: (BuildContext context) => CommonFunction.showBasicToastForJm(
                  'Unable to establish connection to server.Please try after some time'),
            );

            return;
          } else {
            Fluttertoast.showToast(
                msg:
                'Unable to establish connection to server.Please try after some time',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
            db
                .initializeDatabaseFromPath(loadOldData())
                .then((value) => loadData());

            return;
          }
        }
        if (filePathFromServer != '' ||
            filePathFromServer != null ||
            filePathFromServer != 'error') {
          db.checkDbInStorage(filePathFromServer).then((value) {
            CommonFunction.writeLogInInternalMemory('LaunchWidget',
                'loadDatabaseData', 'File present = ' + value.toString());

            if (!value) {
              if (mounted)
                setState(() {
                  labelvalue = 'Gathering Scrips...';
                });
              downloadFile(Dataconstants.fileDownloadUrl)
                  .then((filePath) async {
                CommonFunction.writeLogInInternalMemory('LaunchWidget',
                    'loadDatabaseData', 'Download File response =' + filePath);
                if (filePath == 'Unable to fetch new master.') {
                  if (loadOldData() == '') {
                    showDialog(
                      context: scaffoldContext,
                      builder: (BuildContext context) =>
                          CommonFunction.showBasicToastForJm(
                              'Unable to establish connection to server.Please try after some time'),
                    );

                    return;
                  } else {
                    Fluttertoast.showToast(
                        msg:
                        'Unable to establish connection to server.Please try after some time',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3);
                    db
                        .initializeDatabaseFromPath(loadOldData())
                        .then((value) => loadData());
                  }
                } else if (filePath == 'Cannot download') {
                  if (loadOldData() == '') {
                    showDialog(
                      context: scaffoldContext,
                      builder: (BuildContext context) =>
                          CommonFunction.showBasicToastForJm(
                              'Unable to establish connection to server.Please try after some time'),
                    );

                    return;
                  } else {
                    Fluttertoast.showToast(
                        msg:
                        'Unable to establish connection to server.Please try after some time',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3);
                    db
                        .initializeDatabaseFromPath(loadOldData())
                        .then((value) => loadData());
                  }
                } else if (filePath == null || filePath == '') {
                  if (loadOldData() == '') {
                    showDialog(
                      context: scaffoldContext,
                      builder: (BuildContext context) =>
                          CommonFunction.showBasicToastForJm(
                              'Unable to establish connection to server.Please try after some time'),
                    );

                    return;
                  } else {
                    Fluttertoast.showToast(
                        msg:
                        'Unable to establish connection to server.Please try after some time',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3);
                    db
                        .initializeDatabaseFromPath(loadOldData())
                        .then((value) => loadData());
                  }
                } else {
                  final zipFile = File(filePath);
                  final destinationDir =
                  Directory('${mastersDataDirectory.path}');
                  try {
                    ZipFile.extractToDirectory(
                        zipFile: zipFile, destinationDir: destinationDir)
                        .then((value) {
                      filePath = filePath.replaceAll('.zip', '.db');

                      db
                          .initializeDatabaseFromPath(filePath)
                          .then((value) => loadData());

                      ///Deleting zip file
                      final file = File(filePath.replaceAll('.db', '.zip'));
                      file.delete();

                      delete(filePathFromServer.replaceAll('.zip', ''));
                    });
                  } catch (ex, stackTrace) {
                    if (loadOldData() == '') {
                      showDialog(
                        context: scaffoldContext,
                        builder: (BuildContext context) =>
                            CommonFunction.showBasicToastForJm(
                                'Unable to establish connection to server.Please try after some time'),
                      );
                      CommonFunction.sendDataToCrashlytics(
                          ex, stackTrace, 'LaunchPage-loaddatabase Exception');

                      return;
                    } else {
                      Fluttertoast.showToast(
                          msg:
                          'Unable to establish connection to server.Please try after some time',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3);
                      db
                          .initializeDatabaseFromPath(loadOldData())
                          .then((value) => loadData());
                    }
                  }
                }
              });
            } else {
              db
                  .getPresentFilePath(
                  filePathFromServer.replaceAll('.zip', '.db'))
                  .then((filePath) async {
                db.initializeDatabaseFromPath(
                    mastersDataDirectory.path + filePath);
                CommonFunction.writeLogInInternalMemory(
                    'LaunchWidget',
                    'loadDatabaseData',
                    'Already present file path = ' + filePath);

                loadData();
              });
            }
          });
        }
      });
    });
  }

  Future<void> getToken() async {
    try {
      tokenvalue = await SendTokenToServer().createToken();
      directory = await getApplicationDocumentsDirectory();
      final Directory _appDocDirFolder =
      Directory('${directory.path}/$folderName/');

      if (await _appDocDirFolder.exists()) {
        //if folder already exists return path
        mastersDataDirectory = _appDocDirFolder;
      } else {
        //if folder not exists create folder and then return its path
        mastersDataDirectory = await _appDocDirFolder.create(recursive: true);
        //print(mastersDataDirectory.path);
      }
    } catch (ex, stackTrace) {
      // CommonFunction.writeLog('LaunchWidget', '_getToken', ex.toString());

      CommonFunction.sendDataToCrashlytics(
          ex, stackTrace, 'LaunchPage-getToken Exception');
    }
  }


  String loadOldData() {
    String filePath = '';
    var parentDirectory = mastersDataDirectory;
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

      if (currentFIleName.toLowerCase().contains('exchangedata_')) {
        if (currentFIleName.toLowerCase().endsWith('.db')) {
          filePath = (parentDirectory.path + '/' + currentFIleName);
        }
      }
    }
    return filePath;
  }

  loadData() async {
    Dataconstants.setNumberFormatValues();
    if (mounted) {
      setState(() {
        labelvalue = 'Preparing Scrips...';
      });
    }

    if (mounted) {
      setState(() {
        labelvalue = 'Preparing watchlist...';
      });
    }
    await db.addColumn();
    // await _database.fillWatchListData();

    if (mounted) {
      setState(() {
        labelvalue = 'Making scrips ready...';
      });
    }

    // await db.getEquityMaster();
    Dataconstants.masterLoaded = true;
    //await db.getDerivativeMaster();
    // await db.getEquityDataForCarousel('nifty'.toUpperCase(),
    //     'banknifty'.toUpperCase(), 'india vix'.toUpperCase());
    // await db.getSymbolName();

    await db.getGroupMemberist();
    // await _database.tableIsEmpty();
    // await _database.getFavouriteScannerList();
    //await Global.fetchLiveNewsData();
    // await Global.getIPOlist();

    // Global.fetchLiveNewsData();
    // startUpBgTask();
    // loadHomePage();
    // WebSocketController().connect(isnotreconnecting: false);
  }

  void delete(filePath) {
    var parentDirectory = mastersDataDirectory;
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

      if (currentFIleName.toLowerCase().contains('exchangedata_')) {
        var filename =
        currentFIleName.replaceRange(27, currentFIleName.length, '');
        if (filePath != filename) {
          final file = File(parentDirectory.path + '/' + currentFIleName);
          file.delete();
        }
      }
    }
  }
  Future<String> getFileName() async {
    String filePath = '';
    try {
      final response = await http
          .get(
        Uri.parse(Dataconstants.dbFileName),
      )
          .timeout(Duration(seconds: 25));
      if (response.statusCode == 200) {
        filePath = jsonDecode(response.body);
      }
      return filePath;
    } catch (ex, stackTrace) {
      if (ex.message == 'Future not completed') {
        Fluttertoast.showToast(
            msg: 'Unable to establish connection to server.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 4);
      }
      // CommonFunction.writeLog('LaunchWidget', 'getFileName', ex.toString());
      CommonFunction.sendDataToCrashlytics(
          ex, stackTrace, 'LaunchPage-getFileName Exception');

      return 'error';
    }
  }

  Future<String> downloadFile(String url) async {
    try {
      HttpClient httpClient = new HttpClient();
      File file;
      String filePath = '';
      try {
        // directory = await getApplicationDocumentsDirectory();
        var request = await httpClient
            .getUrl(Uri.parse(url))
            .timeout(Duration(seconds: 25));

        var response = await request.close();
        String fileName = '';
        if (response.statusCode == 200) {
          response.headers.forEach((name, values) {
            if (name.contains('content-disposition')) {
              values.forEach((element) {
                fileName = element.split('=').last;
              });
            }
          });

          var bytes = await consolidateHttpClientResponseBytes(response);
          filePath = '${mastersDataDirectory.path}/$fileName';
          file = File(filePath);
          await file.writeAsBytes(bytes);
        } else {
          filePath = 'Cannot download';
        }
      } catch (ex, stackTrace) {
        if (ex.message == 'Future not completed') {
          Fluttertoast.showToast(
              msg:
              'Slow or no internet connection.Some features may not work as expected',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 4);
        }
        CommonFunction.sendDataToCrashlytics(
            ex, stackTrace, 'LaunchPage-downloadFile Exception');
        CommonFunction.writeLog(
          'LaunchPage',
          'downloadFile',
          ex.toString(),
        );
        filePath = 'Unable to fetch new master.';
      }

      return filePath;
    } catch (ex, stackTrace) {
      CommonFunction.writeLog(
        'LaunchPage',
        'downloadFile',
        ex.toString(),
      );
      CommonFunction.sendDataToCrashlytics(
          ex, stackTrace, 'LaunchPage-downloadFile Exception');

      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) =>
      //         _buildPopupDialog(context, 'Unable to fetch new master.'));

      return '';
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

  @override
  Widget build(BuildContext context) {
    Dataconstants.context = context;
    if (Platform.isIOS)
      ThemeConstants.themeMode.value == ThemeMode.dark
          ? SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.white,
          ))
          : SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.black,
          ));
    var size = MediaQuery.of(context).size.width;
    this.scaffoldContext = context;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Builder(builder: (BuildContext context) {
          this.scaffoldContext = context;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //  SvgPicture.asset(
                //   "assets/images/logo/jm-primary.svg",
                // ),
                Hero(
                  tag: 'logoHero',
                  child: Image(
                    width: MediaQuery.of(context).size.width * 0.45,
                    fit: BoxFit.fitWidth,
                    image: new AssetImage("assets/images/logo/jm-primary.png"),
                  ),
                ),
              ],
            ),
          );
        }));
  }

  // Future<Map<String, dynamic>> getUpdateData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   try {
  //     var response = await get('http://43.242.214.184:8078/iciciupdate.json')
  //         .timeout(const Duration(seconds: 2));
  //     //print('force update json ${response.body}');
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       return data;
  //     } else {
  //       return null;
  //     }
  //   } on TimeoutException {
  //     return null;
  //   } catch (e) {
  //     //print(e);
  //     return null;
  //   }
  // }

  void getLoadBalancerIP() async {
    var randomIp = CommonFunction.getRandomIp();
    // connectDefaultIp(randomIp);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      var response =
      await get(Uri.parse(BrokerInfo.loadBalancerLink), headers: {
        "User-Agent":
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36"
      }).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.replaceAll('\\', ''));
        Dataconstants.iqsIP = data['MachineIP']; //'3.7.7.63';
        Dataconstants.eodIP = data['MachineIP'];
        Dataconstants.newsIP = data['MachineIP'];
        //print("ip = > ${data['MachineIP']}");
        var MFdate = data["MfTimestamp"].toString();
        masterUrl = data["MfDownloadUrl"].toString();
        // //print(MFdate.toString());
        // var MFdate = "18/08/2022 09.11.06.929";


        var mastersDate = preferences.getString("MastersDate") ?? "";
        if (mastersDate == "") {
          getMasters(MFdate);
          redirect();
        } else {
          var newDateFormat = new DateFormat("dd/MM/yyyy hh.mm.ss.SSS");
          var date1 = newDateFormat.parse(mastersDate);
          var date2 = newDateFormat.parse(MFdate);
          if (date1!=date2) {
            getMasters(MFdate);
            redirect();
          } else {
            redirect();
          }
        }

        // //print('------------ + ${Dataconstants.iqsIP}');
        // preferences.setString("iciciIP", Dataconstants.eodIP);
        // connectEOD(scaffoldContext);
        // //print("Connection IP " + data["MachineIP"]);
      } else {
        connectDefaultIp(randomIp);
      }
    } on TimeoutException catch (e, s) {
      connectDefaultIp(randomIp);
      FirebaseCrashlytics.instance.recordError(e, s);
    } catch (e) {
      // //print(e);
      connectDefaultIp(randomIp);
    }
  }

  checkMaster() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // var MFdate = data["MfTimestamp"].toString();
    // //print(MFdate.toString());
    // var MFdate = "18/08/2022 09.11.06.929";

    var mastersDate = preferences.getString("MastersDate") ?? "";
    if (mastersDate == "") {
      showDialogs();
    } else {
      redirect();
    }
  }

  var tryingToRestart = 0;

  showDialogs() {
    showDialog(
      context: scaffoldContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(""),
          content: new Text(
              "Failed to connect to the server. This usually means there’s a network issue. If the issue persists, please try restarting the app"),
          actions: <Widget>[
            new TextButton(
              child: new Text(tryingToRestart != 2 ? "Retry" : "Exit App"),
              onPressed: () async {
                if (tryingToRestart == 2) {
                  exit(0);
                  // //print(result.toString());
                } else {
                  getLoadBalancerIP();
                  Navigator.of(context).pop(false);
                }
                tryingToRestart++;
              },
            ),
          ],
        );
      },
    );
  }

  // void _verifyFiles(Directory filesDir) {
  //   //print("Verifying files at: ${filesDir.path}");
  //   final extractedItems = filesDir.listSync(recursive: true);
  //   for (final item in extractedItems) {
  //     //print("extractedItem: ${item.path}");
  //   }
  //   //print("File count: ${extractedItems.length}");
  //   assert(extractedItems.whereType<File>().length == _dataFiles.length,
  //   "Invalid number of files");
  //   for (final fileName in _dataFiles.keys) {
  //     final file = File('${filesDir.path}/$fileName');
  //     //print("Verifying file: ${file.path}");
  //     assert(file.existsSync(), "File not found: ${file.path}");
  //     final content = file.readAsStringSync();
  //     assert(content == _dataFiles[fileName],
  //     "Invalid file content: ${file.path}");
  //   }
  //   //print("All files ok");
  // }



  // Bhavesh's masters
  getMasters(MFdate) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      Response response = await dio.get(
        masterUrl,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );

      // var path = await getExternalStorageDirectory();
      // final zipFilePath = join(await path.path, "masters.7z");
      // final zipFile = File(zipFilePath);
      // zipFile.writeAsBytesSync(response.data, flush: true);
      //
      // final zipFileNew = File(zipFilePath);
      // final destinationDir =
      // Directory('${zipFileNew.path}');
      //
      // CommonFunction.zipDecoder(path: zipFileNew.path);
      //
      // var value  = await ZipFile.extractToDirectory(
      //     zipFile: zipFile, destinationDir: destinationDir)
      //     .then((value) {
      //
      //   // filePath = filePath.replaceAll('.zip', '.db');
      //   //
      //   // db
      //   //     .initializeDatabaseFromPath(filePath)
      //   //     .then((value) => loadData());
      //   //
      //   // ///Deleting zip file
      //   // final file = File(filePath.replaceAll('.db', '.zip'));
      //   // file.delete();
      //
      //   // delete(filePathFromServer.replaceAll('.zip', ''));
      //
      //       //print("");
      //
      //   // filePath = filePath.replaceAll('.zip', '.db');
      //
      //   // db
      //   //     .initializeDatabaseFromPath(filePath)
      //   //     .then((value) => loadData());
      //   //
      //   // ///Deleting zip file
      //   // final file = File(filePath.replaceAll('.db', '.zip'));
      //   // file.delete();
      //   //
      //   // delete(filePathFromServer.replaceAll('.zip', ''));
      // });

      final databasePath = join(await getDatabasesPath(), "masters.mf");
      final dbFile = File(databasePath);
      final masterExists = await dbFile.exists();
      if (masterExists) await dbFile.delete();
      dbFile.writeAsBytesSync(response.data, flush: true);

      var result = await DatabaseHelper.getAllScripDetailFromMemory(
        sendProgressResponse,
        true,
      );
      preferences.setString("MastersDate", MFdate);
      return;
      // final databasePath = join(await getDatabasesPath(), "masters.mf");
      // Uint8List data = Uint8List(response.);
      // eodBuff.read(data, header.replyLen.getValue());
      // final dbFile = File(databasePath);
      // final masterExists = await dbFile.exists();
      // if (masterExists) await dbFile.delete();
      // dbFile.writeAsBytesSync(data, flush: true);

    } catch (e) {
      //print(e);
    }
  }

  // aakash masters
  // getMasters(MFdate) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   try {
  //     Response response = await dio.get(
  //       masterUrl,
  //       onReceiveProgress: showDownloadProgress,
  //       //Received data with List<int>
  //       options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           validateStatus: (status) {
  //             return status < 500;
  //           }),
  //     );
  //
  //     // var path = await getExternalStorageDirectory();
  //     // final zipFilePath = join(await path.path, "masters.7z");
  //     // final zipFile = File(zipFilePath);
  //     // zipFile.writeAsBytesSync(response.data, flush: true);
  //
  //     // final zipFileNew = File(zipFilePath);
  //     // await _testUnzip(zipFileNew);
  //
  //     final databasePath = join(await getDatabasesPath(), "masters.mf");
  //     final dbFile = File(databasePath);
  //     final masterExists = await dbFile.exists();
  //     if (masterExists) await dbFile.delete();
  //     dbFile.writeAsBytesSync(response.data, flush: true);
  //
  //     var result = await DatabaseHelper.getAllScripDetailFromMemory(
  //       sendProgressResponse,
  //       true,
  //     );
  //     preferences.setString("MastersDate", MFdate);
  //     return;
  //     // final databasePath = join(await getDatabasesPath(), "masters.mf");
  //     // Uint8List data = Uint8List(response.);
  //     // eodBuff.read(data, header.replyLen.getValue());
  //     // final dbFile = File(databasePath);
  //     // final masterExists = await dbFile.exists();
  //     // if (masterExists) await dbFile.delete();
  //     // dbFile.writeAsBytesSync(data, flush: true);
  //
  //   } catch (e) {
  //     //print(e);
  //   }
  // }

  void sendProgressResponse(double value) {
    // //print('sendProgressResponse ---$value');
    if(value == 1.0) {
      // Dataconstants.iqsClient.createHeaderRecord('DEVESH');
      // Dataconstants.iqsClient.connect();
      // CommonFunction.getMarketWatch();
      // CommonFunction.getOtherAssets();
    }
    // mResponseListener.onResponseReceieved((value).toString(), 999);
  }

  void showDownloadProgress(received, total) {
    // if (total != -1) {
    //   //print((received / total * 100).toStringAsFixed(0) + "%");
    // }
  }

  var isRedirected = false;

  redirect() async {
    if (!isRedirected) {
      isRedirected = true;
      var LoggedInApp = await Utils.getSharedPreferences("LoggedInApp", "Bool");
      if (LoggedInApp) {
        Dataconstants.navigatorKey.currentState.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Login(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      } else {
        var isIntroDone = await Utils.getSharedPreferences("IntroDone", "Bool");
        Dataconstants.navigatorKey.currentState.pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
            isIntroDone ? MobileNoScreen() : IntroScreens(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      }
    }
  }

  connectDefaultIp(ip) {
    Dataconstants.eodIP = ip;
    Dataconstants.iqsIP = ip; //'3.7.7.63';
    Dataconstants.newsIP = ip;
    // connectEOD(Dataconstants.context);
    // if (Dataconstants.masterExists) redirect();
    checkMaster();
    //print("Default Connection IP " + ip);
  }

  void connectEOD(BuildContext context) async {
    if (!Dataconstants.eodClient.isConnected) {
      Dataconstants.eodClient.mResponseListener = this;
      Dataconstants.eodClient.connect();
    }
  }

  void setListener() {
    // if (!Dataconstants.eodClient.isConnected) {
    Dataconstants.eodClient.mResponseListener = this;
    // }
  }

  @override
  void onErrorReceived(String error, int type) {}

  @override
  void onResponseReceieved(String resp, int type) async {
    if (!didGot) {
      didGot = true;
      redirect();
      // var forcedVersion, optionalVersion;
      // var response = await get(Uri.parse(
      //     'https://marketstreams.icicidirect.com/iciciupdate/iciciupdate.json'));
      // // var response = await get('http://43.242.214.184:8078/iciciupdate.json');
      //
      // bool forcedUpdateBool = false, optionalUpdateBool = false;
      // // //print(response.body);
      // var updateData = jsonDecode(response.body);
      // Dataconstants.fileVersion = await CommonFunction.getVersionNumber();
      // var installedVersion = int.parse(version.split('.').join());
      // var meanUpdateVersion =
      //     int.parse(updateData['meanValue'].split('.').join());
      //
      // if (meanUpdateVersion >= installedVersion) {
      //   forcedVersion =
      //       int.parse(updateData['forceLiveUpdate'].split('.').join());
      //   optionalVersion =
      //       int.parse(updateData['optionalLiveUpdate'].split('.').join());
      // } else if (meanUpdateVersion <= installedVersion) {
      //   forcedVersion =
      //       int.parse(updateData['forceBetaUpdate'].split('.').join());
      //   optionalVersion =
      //       int.parse(updateData['optionalBetaUpdate'].split('.').join());
      // }
      //
      // //17 <= 17 >= 21
      //
      // // //print("$installedVersion $forcedVersion $optionalVersion");
      // if (forcedVersion > installedVersion) forcedUpdateBool = true;
      // if (optionalVersion > installedVersion) optionalUpdateBool = true;

      // // //print("$forcedUpdateBool $optionalUpdateBool ");
      // if (forcedUpdateBool || optionalUpdateBool)
      //   Dataconstants.navigatorKey.currentState.pushReplacement(
      //     PageRouteBuilder(
      //       pageBuilder: (_, __, ___) => ForceUpdate(
      //         forceUpdate: forcedUpdateBool,
      //         optionalUpdate: optionalUpdateBool,
      //       ),
      //       transitionDuration: Duration(seconds: 0),
      //     ),
      //   );

    } else if (type == 999) {
      if (mounted)
        setState(() {
          value = double.tryParse(resp) ?? 0;
        });
    }
  }

  void showDialogInternet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(""),
          content: new Text("No Internet Connection"),
          actions: <Widget>[
            new TextButton(
              child: new Text("Retry"),
              onPressed: () {
                if (ConnectionStatusSingleton.getInstance().hasConnection) {
                  Navigator.of(context).pop(false);
                  connectEOD(context);
                } else {
                  Navigator.of(context).pop(false);
                  showDialogInternet(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
