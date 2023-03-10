import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:alice/alice.dart';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:firebase_analytics/firebase_analytics.dart';
//
// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:markets/database/watchlist_database.dart';
import 'package:markets/util/Utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// import '../../../screens/onboarding_page_one.dart';
// import '../screens/ssl_pinning.dart';
import 'package:path/path.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trust_fall/trust_fall.dart';

// import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'Connection/EOD/EODClient.dart';
import 'database/database_helper.dart';
import 'util/CommonFunctions.dart';
import 'Connection/IQS/IQSClient.dart';
import 'Connection/News/NewsClient.dart';
import 'Connection/structHelper/BufferForSock.dart';
import 'database/news_database.dart';
import 'screens/splash_screen.dart';
import 'style/theme.dart';
import 'util/BrokerInfo.dart';
import 'util/Dataconstants.dart';
import 'util/InAppSelections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';

// AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  BrokerInfo.setClientInfo(Broker.icici);
  Dataconstants.iqsClient = IQSClient();
  IQSClient.iqsBuff = BufferForSock(1024);
  final databasePath = join(await getDatabasesPath(), "masters.mf");
  final masterExists = await File(databasePath).exists();
  Dataconstants.eodClient = EODClient(masterExists);
  Dataconstants.masterExists = masterExists;
  EODClient.eodBuff = BufferForSock(1024);
  Dataconstants.newsClient = NewsClient();
  NewsClient.newsBuff = BufferForSock(2048);

  InAppSelection.fetchSelections();
  initPlatformState();
  NewsDatabase.instance.initDB();

  // ConnectionStatusSingleton connectionStatus =
  //     ConnectionStatusSingleton.getInstance();
  // connectionStatus.initialize();

  // WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  // channel = const AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   importance: Importance.high,
  // );
  //
  // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // Dataconstants.flutterLocalNotificationsPlugin =
  //     flutterLocalNotificationsPlugin;
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  // var initializationSettingsAndroid =
  //     AndroidInitializationSettings('mipmap/ic_launcher');
  // var initializationSettingsIOS = IOSInitializationSettings();
  // var initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  void sendProgressResponse(double value) {
    // mResponseListener.onResponseReceieved((value).toString(), 999);
  }

  if (masterExists)
    var result = DatabaseHelper.getAllScripDetailFromMemory(
      sendProgressResponse,
      true,
    );

  // Dataconstants.alice = Alice(
  //   showNotification: true,
  //   showInspectorOnShake: true,
  //   darkTheme: false,
  //   maxCallsCount: 1000,
  // );

  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    // //print('runZonedGuarded: Caught error in my root zone. ');
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

Future<void> initPlatformState() async {
  String deviceId;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    Dataconstants.feUserDeviceID = await PlatformDeviceId.getDeviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      Dataconstants.deviceName = iosInfo.name;
      Dataconstants.osName = iosInfo.systemVersion;
      Dataconstants.devicemodel = iosInfo.model;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      //print("${androidInfo.brand}");
      Dataconstants.deviceName = androidInfo.brand.replaceAll(' ', '');
      Dataconstants.osName = 'Android${androidInfo.version.release}';
      Dataconstants.devicemodel = androidInfo.model;
    }
  } on PlatformException {
    deviceId = 'Failed to get deviceId.';
  }

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
  // if (!mounted) return;
}

Future<String> downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final Response response = await get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   Dataconstants.flutterLocalNotificationsPlugin =
//       flutterLocalNotificationsPlugin;
//
//   // //print('Handling a background message $message');
//
//   var initializationSettingsAndroid =
//       AndroidInitializationSettings('mipmap/ic_launcher');
//   var initializationSettingsIOS = IOSInitializationSettings();
//   var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   // //print('Handling a background message ${message.messageId}');
//   RemoteNotification notification = message.notification;
//   AndroidNotification android = message.notification?.android;
//
//   if (notification != null && android != null) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           // channel.description,
//           // TODO add a proper drawable resource to android, for now using
//           //      one that already exists in example app.
//           icon: 'launch_background',
//         ),
//       ),
//     );
//   }
//   return;
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var appId = '';
  String mysource, mymedium, mycampaign;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings initializationSettingsAndroid;
  static const IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings();
  InitializationSettings initializationSettings;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          Dataconstants.iqsClient.sendIqsReconnectWithCallback;
          Dataconstants.fToast.init(Dataconstants.navigatorKey.currentContext);
          // checkDeepLink();
          // CommonFunction.reconnect();
          // if (Dataconstants.lastClicked == "My Watchlist") {
          //   Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.marketWatchListeners[InAppSelection.marketWatchID].watchList, true);
          // } else if (Dataconstants.lastClicked == "Predefined") {
          //   Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.predefinedMarketWatchListener.watchList, true);
          // } else if (Dataconstants.lastClicked == "Indices") {
          //   Dataconstants.iqsClient.sendBulkLTPRequest(Dataconstants.indicesMarketWatchListener.watchList, true);
          // } else if (Dataconstants.lastClicked == "Summary") {
          //   Dataconstants.iqsClient.requestForMarketSummary(
          //     Dataconstants.exchData[Dataconstants.summaryMarketWatchListener.summaryExchPos].exch,
          //     Dataconstants.exchData[Dataconstants.summaryMarketWatchListener.summaryExchPos].exchTypeShort,
          //     Dataconstants.summaryMarketWatchListener.selectedFilter,
          //   );
          // }
          // CommonFunction.reconnect();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        if (Dataconstants.itsClient.isLoggedIn) {
          //   DataConstants.itsClient.stopHandshakeTimer();

          // Dataconstants.iqsClient.stopIqsTimer();
        }
        Dataconstants.fToast.removeCustomToast();
        Fluttertoast.cancel();
        InAppSelection.saveSelections();
        CommonFunction.saveRecentSearchData();
        break;
      case AppLifecycleState.detached:
        break;
      //   //print("app in detached");
      //   break;
    }
  }

  // checkDeepLink() async {
  //   await initDynamicLinksn();
  // }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();

    initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/notiicon');
    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    WidgetsBinding.instance.addObserver(this);

    getMessage();

    // getuuid(); //TODO: 21/12
    // initDynamicLinksn();
    // // CommonFunction.checkInternet();
    // initReferrerDetails();
    // initAppsFlyer(); //TODO: 21/12

    // WatchlistDatabase.instance.initDB(); //TODO: 21/12

    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage message) {
    //   if (message != null) {}
    // });
    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //
    //   // //print("Handling a background message 123: ${message.data}");
    //   //
    //   // if (message.data.containsKey('_App42CampaignName')) {
    //   //
    //   //   try {
    //   //     final mediaObj = jsonDecode(message.data['_app42RichPush']);
    //   //
    //   //     if (mediaObj['type'] == 'image') {
    //   //       CommonFunction.showBigPictureNotificationURL(message.data);
    //   //     } else {
    //   //       CommonFunction.sherptzShowNotification(message.data);
    //   //     }
    //   //   } catch (e, s) {
    //   //     // //print(e);
    //   //     CommonFunction.sherptzShowNotification(message.data);
    //   //   }
    //   // }
    //   // else
    //   // {
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           icon: 'launch_background',
    //         ),
    //       ),
    //     );
    //   }
    //   return;
    //   // }
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   // //print('A new onMessageOpenedApp event was published!');
    //   RemoteNotification notification = message.notification;
    //
    //   SharedPreferences sharedPreferences =
    //       await SharedPreferences.getInstance();
    //   var storeduuid = sharedPreferences.getString('uuid');
    //   var systemCustId = sharedPreferences.getString('systemCustId');
    //   var appInstanceId = sharedPreferences.getString('appInstanceId');
    //
    //   var parameters = {
    //     'message_title_manual': notification.title,
    //     'message_body_manual': notification.body,
    //     'tvc_client_id': storeduuid ?? "",
    //     'Cust_ID': systemCustId ?? '',
    //     'app_id': appInstanceId ?? ''
    //   };
    //   FirebaseAnalytics.instance
    //       .logEvent(name: 'manual_notification_open', parameters: parameters);
    // });
  }

  // initAppsFlyer() async {
  //   AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
  //       afDevKey: "Tsa4VgpsYjrxSCswsHZqvm",
  //       appId: Platform.isAndroid ? "com.icicidirect.markets" : "1570800408",
  //       showDebug: true,
  //       timeToWaitForATTUserAuthorization: 50,
  //       appInviteOneLink: "",
  //       disableAdvertisingIdentifier: false,
  //       disableCollectASA: false);
  //
  //   InAppSelection.appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  //
  //   InAppSelection.appsflyerSdk.initSdk(registerConversionDataCallback: true, registerOnAppOpenAttributionCallback: true, registerOnDeepLinkingCallback: true);
  //
  //   InAppSelection.appsFlyerId = await InAppSelection.appsflyerSdk.getAppsFlyerUID();
  // }

  // void getuuid() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var storeduuid = sharedPreferences.getString('uuid');
  //   if (storeduuid != null) {
  //     Dataconstants.uuid = storeduuid;
  //     return;
  //   }
  //   var uuid = Uuid();
  //   var tvcClientId = uuid.v4();
  //   Dataconstants.uuid = tvcClientId;
  //   sharedPreferences.setString('uuid', tvcClientId);
  // }

  // void initDynamicLinksn() async {
  //   //
  //   final PendingDynamicLinkData data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data?.link;
  //   // FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
  //   //   final Uri deepLink = dynamicLink?.link;
  //   //   InAppSelection.deeplink = deepLink.path;
  //   //   //print("deep link =>  ${InAppSelection.deeplink}");
  //   //
  //   //
  //   //   if (deepLink != null) {
  //   //     final Uri deepLink = dynamicLink?.link;
  //   //
  //   //     if (deepLink != null) {
  //   //       final queryParams = deepLink.queryParameters;
  //   //       mysource = queryParams['utm_source'];
  //   //       mymedium = queryParams['utm_medium'];
  //   //       mycampaign = queryParams['utm_campaign'];
  //   //     }
  //   //   }
  //   //   _handleDynamicLink(dynamicLink);
  //   // });
  // }
  //
  // // void initDynamicLinksn() async {
  // //   final PendingDynamicLinkData data =
  // //       await FirebaseDynamicLinks.instance.getInitialLink();
  // //   final Uri deepLink = data?.link;
  // //   FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
  // //     final Uri deepLink = dynamicLink?.link;
  // //
  // //     if (deepLink != null) {
  // //       final Uri deepLink = dynamicLink?.link;
  // //
  // //       if (deepLink != null) {
  // //         final queryParams = deepLink.queryParameters;
  // //         mysource = queryParams['utm_source'];
  // //         mymedium = queryParams['utm_medium'];
  // //         mycampaign = queryParams['utm_campaign'];
  // //       }
  // //     }
  // //     var link =
  // //         "https://secure.icicidirect.com/accountopening?utm_source=mktapp-$mysource&utm_medium=mktapp-$mymedium&cid=${Dataconstants.uuid}&av=${Dataconstants.fileVersion}&aid=com.icicidirect.markets&dimension%2017=MarketApp&app_id=${Dataconstants.appInstanceId}&rmcode=111111";
  // //
  // //     if (await canLaunchUrl(Uri.parse(link))) launchUrl(Uri.parse(link));
  // //     _handleDynamicLink(dynamicLink);
  // //   });
  // // }
  //
  // initReferrerDetails() async {
  //   String referrerDetailsString;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     String token = await FirebaseMessaging.instance.getToken();
  //
  //     Dataconstants.fcmToken = token;
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var utmTerm;
  //     var utmContent;
  //     var utmCampaign;
  //     ReferrerDetails referrerDetails =
  //         await AndroidPlayInstallReferrer.installReferrer;
  //     referrerDetailsString = referrerDetails.toString();
  //
  //     var utm = referrerDetails.installReferrer.split("&");
  //     Dataconstants.utmMedium = utm[1].split("=")[1];
  //     prefs.setString('utm_medium', Dataconstants.utmMedium);
  //     Dataconstants.utmSource = utm[0].split("=")[1];
  //     prefs.setString('utm_source', Dataconstants.utmSource);
  //     if (utm.length > 2) {
  //       Dataconstants.utmTerm = utm[2].split("=")[1];
  //       prefs.setString('utm_term', Dataconstants.utmTerm);
  //       Dataconstants.utmContent = utm[3].split("=")[1];
  //       prefs.setString('utm_content', Dataconstants.utmContent);
  //       Dataconstants.utmCampaign = utm[4].split("=")[1];
  //       prefs.setString('utm_campaign', Dataconstants.utmCampaign);
  //     }
  //     var parameters = {
  //       'eventCategory': 'campaign tracking',
  //       'eventAction': 'Install campaign tracking',
  //       'utm_source': Dataconstants.utmSource,
  //       'utm_medium': Dataconstants.utmMedium,
  //       'referrerDetails': referrerDetailsString,
  //       'app_id': appId
  //     };
  //     if (utm.length > 2) {
  //       parameters.addAll({
  //         'utm_term': Dataconstants.utmTerm,
  //         'utm_content': Dataconstants.utmContent,
  //         'utm_campaign': Dataconstants.utmCampaign,
  //       });
  //     }
  //     // //print("this is utm parameters => $parameters");
  //     FirebaseAnalytics.instance
  //         .logEvent(name: 'tvc_campaign', parameters: parameters);
  //   } catch (e) {
  //     referrerDetailsString = 'Failed to get referrer details: $e';
  //     // //print("error $referrerDetailsString");
  //     // //print("tvc error encountered");
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     // _referrerDetails = referrerDetailsString;
  //   });
  // }

  // void initializeFlutterFire() async {
  //   try {
  //     // Wait for Firebase to initialize and set `_initialized` state to true
  //     await Firebase.initializeApp();
  //     if (_kTestingCrashlytics) {
  //       // Force enable crashlytics collection enabled if we're testing it.
  //       await FirebaseCrashlytics.instance
  //           .setCrashlyticsCollectionEnabled(true);
  //     } else {
  //       // Else only enable it in non-debug builds.
  //       // You could additionally extend this to allow users to opt-in.
  //       await FirebaseCrashlytics.instance
  //           .setCrashlyticsCollectionEnabled(!kDebugMode);
  //     }
  //
  //     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  //     Isolate.current.addErrorListener(RawReceivePort((pair) async {
  //       final List<dynamic> errorAndStacktrace = pair;
  //       await FirebaseCrashlytics.instance.recordError(
  //         errorAndStacktrace.first,
  //         errorAndStacktrace.last,
  //       );
  //     }).sendPort);
  //     setState(() {
  //       _initialized = true;
  //     });
  //     DataConstants.firebaseMessaging.subscribeToTopic('Broadcast');
  //   } catch (e) {
  //     // Set `_error` state to true if Firebase initialization fails
  //     setState(() {
  //       _error = true;
  //     });
  //   }
  // }

  void getMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // await flutterLocalNotificationsPlugin.show(
      //   messageId++,
      //   message.notification.title,
      //   message.notification.body,
      //   platformChannelSpecifics,
      // );
      flutterLocalNotificationsPlugin.show(
          message.hashCode,
          null,
          message.data[4],
          // NotificationDetails(
          //   android: AndroidNotificationDetails(
          //     channel.id,
          //     channel.name,
          //     enableLights: true,
          //     color: Colors.transparent,
          //     icon: 'mipmap/ic_launcher',
          //   ),
          // ),

          NotificationDetails(
              android : AndroidNotificationDetails(
                  'high_importance_channel',
                  'High Importance Notifications',
                  channelDescription:  'This channel is used for important notifications.',
                  importance: Importance.max,
                  priority: Priority.high,
                  icon: '@mipmap/notiicon',
                  enableLights: true,
                  color: Color(0xffff5c34),
                  showWhen: false)
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => MaterialApp(
        builder: (BuildContext context, Widget child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: child,
          );
        },
        title: BrokerInfo.appName,
        navigatorKey: Dataconstants.navigatorKey,
        theme: ThemeData.light().copyWith(
            textTheme: GoogleFonts.beVietnamProTextTheme(
              Theme.of(context).textTheme,
            ),
            primaryColor: Utils.primaryColor,
            accentColor: Colors.white,
            indicatorColor: const Color(0xFF4A4A4A),
            scaffoldBackgroundColor: Colors.white,
            cardColor: const Color(0xFFF2F4F7),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: const Color(0xFFF2F4F7),
              selectedItemColor: Utils.primaryColor,
            ),
            // cursorColor: Utils.primaryColor,
            // textSelectionColor: Utils.primaryColor.withOpacity(0.5),
            // textSelectionHandleColor: Utils.primaryColor,
            bottomAppBarTheme: BottomAppBarTheme(
              color: const Color(0xFFF2F4F7),
              elevation: 5,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Utils.primaryColor,
              selectionColor: Utils.primaryColor.withOpacity(0.5),
              selectionHandleColor: Utils.primaryColor,
            ),
            // useTextSelectionTheme: true,
            toggleableActiveColor: Utils.primaryColor,
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Utils.primaryColor,
            ),
            appBarTheme: AppBarTheme(
              color: const Color(0xFFF2F4F7),
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
            ),
            brightness: Brightness.light,
            colorScheme: ColorScheme(
                primary: Color(0xFFd4d8dd),
                primaryVariant: Utils.primaryColor,
                secondary: Utils.primaryColor,
                secondaryVariant: Utils.primaryColor,
                surface: Utils.primaryColor,
                background: Utils.primaryColor,
                error: Utils.primaryColor,
                onPrimary: Utils.primaryColor,
                onSecondary: const Color(0xFFF2F4F7),
                onSurface: Utils.primaryColor,
                onBackground: Utils.primaryColor,
                onError: Utils.primaryColor,
                brightness: Brightness.dark)),
        darkTheme: ThemeConstants.amoledThemeMode.value
            ? ThemeData.dark().copyWith(
                textTheme: GoogleFonts.beVietnamProTextTheme(
                  Theme.of(context).textTheme,
                ),
                canvasColor: const Color(0xFF13161A),
                primaryColor: Utils.primaryColor,
                accentColor: const Color(0xFF13161A),
                indicatorColor: const Color(0xFFF1F1F1),
                scaffoldBackgroundColor: const Color(0xFF000000),
                cardColor: const Color(0xFF13161A),
                dialogBackgroundColor: const Color(0xFF13161A),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: const Color(0xFF000000),
                  selectedItemColor: Utils.primaryColor,
                ),
                // cursorColor: Utils.primaryColor,
                // textSelectionColor: Utils.primaryColor.withOpacity(0.5),
                // textSelectionHandleColor: Utils.primaryColor,
                toggleableActiveColor: Utils.primaryColor,
                bottomAppBarTheme: BottomAppBarTheme(
                  color: const Color(0xFF0C1011),
                  elevation: 5,
                ),
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Utils.primaryColor,
                  selectionColor: Utils.primaryColor.withOpacity(0.5),
                  selectionHandleColor: Utils.primaryColor,
                ),
                // useTextSelectionTheme: true,
                appBarTheme: AppBarTheme(
                  brightness: Brightness.dark,
                  color: const Color(0xFF000000),
                  iconTheme: IconThemeData(
                    color: Colors.white, //change your color here
                  ),
                ),
                snackBarTheme: SnackBarThemeData(
                  backgroundColor: Utils.primaryColor,
                ),
                brightness: Brightness.dark,
                colorScheme: ColorScheme(
                    primary: Color(0xFF2E4052),
                    primaryVariant: Utils.primaryColor,
                    secondary: Utils.primaryColor,
                    secondaryVariant: Utils.primaryColor,
                    surface: Utils.primaryColor,
                    background: Utils.primaryColor,
                    error: Utils.primaryColor,
                    onPrimary: Utils.primaryColor,
                    onSecondary: const Color(0xFF2E4052),
                    onSurface: Utils.primaryColor,
                    onBackground: Utils.primaryColor,
                    onError: Utils.primaryColor,
                    brightness: Brightness.dark),
              )
            : ThemeData.dark().copyWith(
                textTheme: GoogleFonts.beVietnamProTextTheme(
                  Theme.of(context).textTheme,
                ),
                canvasColor: const Color(0xFF1E2230),
                primaryColor: Utils.primaryColor,
                accentColor: const Color(0xFF2E4052),
                indicatorColor: const Color(0xFFF1F1F1),
                scaffoldBackgroundColor: const Color(0xFF0B0F1C),
                cardColor: const Color(0xFF1E2230),
                dialogBackgroundColor: const Color(0xFF1E2230),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: const Color(0xFF1E2230),
                  selectedItemColor: Utils.primaryColor,
                ),
                // cursorColor: Utils.primaryColor,
                // textSelectionColor: Utils.primaryColor.withOpacity(0.5),
                // textSelectionHandleColor: Utils.primaryColor,
                bottomAppBarTheme: BottomAppBarTheme(
                  color: const Color(0xFF1E2230),
                  elevation: 5,
                ),
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Utils.primaryColor,
                  selectionColor: Utils.primaryColor.withOpacity(0.5),
                  selectionHandleColor: Utils.primaryColor,
                ),
                // useTextSelectionTheme: true,
                toggleableActiveColor: Utils.primaryColor,
                appBarTheme: AppBarTheme(
                  brightness: Brightness.dark,
                  color: const Color(0xFF1E2230),
                  iconTheme: IconThemeData(
                    color: Colors.white, //change your color here
                  ),
                ),
                snackBarTheme: SnackBarThemeData(
                  backgroundColor: Utils.primaryColor,
                ),
                brightness: Brightness.dark,
                colorScheme: ColorScheme(
                    primary: Color(0xFF2E4052),
                    primaryVariant: Utils.primaryColor,
                    secondary: Utils.primaryColor,
                    secondaryVariant: Utils.primaryColor,
                    surface: Utils.primaryColor,
                    background: Utils.primaryColor,
                    error: Utils.primaryColor,
                    onPrimary: Utils.primaryColor,
                    onSecondary: const Color(0xFF2E4052),
                    onSurface: Utils.primaryColor,
                    onBackground: Utils.primaryColor,
                    onError: Utils.primaryColor,
                    brightness: Brightness.dark),
              ),
        themeMode: ThemeConstants.themeMode.value,
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
