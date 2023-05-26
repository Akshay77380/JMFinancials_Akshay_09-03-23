import 'dart:io';
import 'package:flutter/material.dart';

String username = 'c3BpZGVyc29mdHdhcmVtb2JpbGVhcGk=';
String password = 'cyNwIWkoZCNlfnI=';

// URL Developement Server
//const String localhost = '192.168.10.31:2206';

// URL Live Server
const String localhost = '185.100.212.19:8080';
const String internalVersionNumber = "2022.07.29.1";
const String appversion = '1.0.0.55';
const double defaultPadding = 16.0;

//Enabling Logs
const bool isDevelopmentMode = false;
const bool stopLiveDataInDebugMode = false;

const String imageUrl = 'http://$localhost/Images/Events/';
const String speakerimageUrl = 'http://$localhost/Images/Speaker/';
Uri eventRegistrationDetails2 =
    new Uri.http('$localhost', '/api/EventsRegistration');

const String fileDownloadUrl = 'http://$localhost/api/GetFile';
const String dbFileName = 'http://$localhost/api/GetFileName';
Uri fiftyTwoWeekHLUrl = new Uri.http('$localhost', 'api/52WeekAllTimeHighLow');
Uri fiveYearPerformanceUrl =
    new Uri.http('$localhost', '/api/FiveYearPerformanceData');
Uri indicatorUrl =
    new Uri.http('$localhost', 'api/Indicators/GetIndicatorsHttp');
Uri apiURL = new Uri.http('$localhost', 'api/WatchList');
Uri url = new Uri.http('$localhost', 'api/Derivative');
Uri topGainersUrl = new Uri.http('$localhost', 'api/Top_Gainers');
Uri topLosersUrl = new Uri.http('$localhost', 'api/Top_Losers');
Uri topTradedUrl = new Uri.http('$localhost', 'api/Top_Traded');
Uri nseMasterUrl = new Uri.http('$localhost', 'api/Masters/GetNseMastersHttp');
Uri loginUrl = new Uri.http('$localhost', '/api/NewLogin');
Uri registrationUrl = new Uri.http('$localhost', '/api/NewRegisterUser');
Uri upwardBreakoutUrl = new Uri.http('$localhost', '/api/UpwardBreakout');
Uri downwardBreakoutUrl = new Uri.http('$localhost', '/api/DownwardBreakout');
Uri gapUpUrl = new Uri.http('$localhost', 'api/GapUp');
Uri gapDownUrl = new Uri.http('$localhost', 'api/GapDown');
Uri rsiInOBUrl = new Uri.http('$localhost', 'api/RSI_In_OverBought_Zone');
Uri rsiInOSUrl = new Uri.http('$localhost', 'api/RSI_In_OverSold_Zone');
Uri priceAndVolumeShockersUrl =
    new Uri.http('$localhost', 'api/PriceAndVolumeShockers');
Uri closingAbvPHighUrl =
    new Uri.http('$localhost', 'api/Previous_Day_UpwardBreakout');
Uri closingBlwPLowUrl =
    new Uri.http('$localhost', 'api/Previous_Day_DownwardBreakout');
Uri lastWkUpwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Last_Week _Upward_Breakout');
Uri lastWkDownwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Last_Week _Downward_Breakout');
Uri threeDaysUpwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Three_Days_Upward_Breakout');
Uri threeDaysDownwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Three_Days_Downward_Breakout');
Uri lastMonthUpwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Last_Month_Upward_Breakout');
Uri lastMonthDownwardBreakoutUrl =
    new Uri.http('$localhost', '/api/Last_Month_Downward_Breakout');
Uri twoYearUpwardBreakoutUrl =
    new Uri.http('$localhost', '/api/Two_Year_Upward_Breakout');
Uri twoYearDownwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Two_Year_Downward_Breakout');
Uri fiveYearUpwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Five_Year_Upward_Breakout');
Uri fiveYearDownwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Five_Year_Downward_Breakout');
Uri fifteenDaysUpwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Fifteen_Days_Upward_Breakout');
Uri fifteenDaysDownwardBreakoutUrl =
    new Uri.http('$localhost', 'api/Fifteen_Days_Downward_Breakout');
Uri getEvents = new Uri.http('$localhost', '/api/GetEventsData');

Uri changePasswordUrl = new Uri.http('$localhost', '/api/ChangePassword');
Uri eventRegistrationDetails =
    new Uri.http('$localhost', '/api/AddRegisteredEventsDetails');

String fiveDaysCloseDataUrl = '/api/Data7DaysClose';

Uri newsUrl = new Uri.https(
    'newsapi.org/v2/top-headlines?country=in&category=business&apiKey=93fc374757434222b232c394f965456f',
    '');
Uri getFirstNameLastName =
    new Uri.http('$localhost', '/api/GetFirstNameLastName');
Uri paymentOrderUrl = new Uri.http('$localhost', '/api/GenerateOrder');

bool forcedClose = false;
double loginFont = 20;
double loginListFont = 15;
double homePageIconTextFontSize = 15;
enum ChartPeriodicity { TenDay, OneWeek, OneYear, FiveYear }
String folderName = 'MASTER', screenShotFolderName = 'Images';
Directory directory, mastersDataDirectory;
String appName = 'Insight';

// AlertDialog Properties Const Values/////

Color activeColor = Colors.blue[900],
    dialogBackgroundColor = Colors.white70.withAlpha(230);
TextStyle dialogTextStyle = TextStyle(
  color: Colors.grey[900],
);
TextStyle dialogActionTextStyle = TextStyle(
  color: Colors.blue[900],
);
ShapeBorder dialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20),
);

Color blueColor = Color(0xff0070b8);
