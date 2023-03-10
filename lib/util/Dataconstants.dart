// import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:async';
import 'dart:io';
import 'package:alice/alice.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:googleapis/shared.dart';
import 'package:intl/intl.dart';
import 'package:markets/Connection/ISecITS/ITSclient2.dart';
import 'package:markets/controllers/AlgoController/awaitingController.dart';
import 'package:markets/controllers/AlgoController/fetchAlgoController.dart';
import 'package:markets/controllers/AlgoController/finishedController.dart';
import 'package:markets/controllers/AlgoController/runningController.dart';
import 'package:markets/controllers/FIICashController.dart';
import 'package:markets/controllers/NseIndicesController.dart';
import 'package:markets/controllers/equitySipController.dart';
import 'package:markets/controllers/limitController.dart';
import 'package:markets/model/AlgoModels/algo_create_model.dart';
import 'package:markets/model/AlgoModels/reportAlgo_Model.dart';
import 'package:markets/model/AlgoModels/reportFinishedAlgo_model.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';
import '../controllers/AdvanceDeclineController.dart';
import '../controllers/AlgoController/AlgoLogController.dart';
import '../controllers/BankDetailsController.dart';
import '../controllers/BrokerageController.dart';
import '../controllers/BseAdvanceController.dart';
import '../controllers/BseDeclineController.dart';
import '../controllers/BseIndicesController.dart';
import '../controllers/DetailController.dart';
import '../controllers/EventsBoardMeetController.dart';
import '../controllers/EventsBonusController.dart';
import '../controllers/EventsDateController.dart';
import '../controllers/EventsDividendController.dart';
import '../controllers/EventsRightsController.dart';
import '../controllers/EventsSplitsController.dart';
import '../controllers/FiftyTwoWeekHighController.dart';
import '../controllers/FiftyTwoWeekLowController.dart';
import '../controllers/FiiDiiController.dart';
import '../controllers/FiiFnoController.dart';
import '../controllers/IpoRecentListingController.dart';
import '../controllers/MostActiveFuturesController.dart';
import '../controllers/MostActivePutController.dart';
import '../controllers/MostActiveTurnoverController.dart';
import '../controllers/MostActiveVolumeController.dart';
import '../controllers/BseIndicesController.dart';
import '../controllers/NseAdvanceController.dart';
import '../controllers/NseDeclineController.dart';
import '../controllers/OiGainersController.dart';
import '../controllers/OiLosersController.dart';
import '../controllers/OpenIpoController.dart';
import '../controllers/PortfolioControllers/DpHoldingController.dart';
import '../controllers/PortfolioControllers/PortfolioEquityController.dart';
import '../controllers/PortfolioControllers/PortfolioHoldings.dart';
import '../controllers/SummaryController.dart';
import '../controllers/WorldIndicesController.dart';
import '../controllers/balanceSheetController.dart';
import '../controllers/blockDealsController.dart';
import '../controllers/bulkController.dart';
import '../controllers/cashFlowController.dart';
import '../controllers/cmotController.dart';
import '../controllers/holdingController.dart';
import '../controllers/mostActiveCallController.dart';
import '../controllers/mostActiveController.dart';
import '../controllers/netPositionController.dart';
import '../controllers/orderBookController.dart';
import '../controllers/orderHistoryController.dart';
import '../controllers/positionFilterController.dart';
import '../controllers/profitAndLossController.dart';
import '../controllers/researchcallsController.dart';
import '../controllers/scannerController.dart';
import '../controllers/shareHoldingController.dart';
import '../controllers/todaysPostionController.dart';
import '../controllers/topGainersController.dart';
import '../controllers/topLosersController.dart';
import '../controllers/topPerformingIndustries.dart';
import '../controllers/tradeBookController.dart';
import '../controllers/upcomingIpoController.dart';
import '../controllers/watchListController.dart';
import '../jmScreens/Scanners/EquityAndDerivativeIndicatorData.dart';
import '../jmScreens/Scanners/EquityControllerClass.dart';
import '../model/AlgoModels/AlgoLogModel.dart';
import '../model/jmModel/advanceDecline.dart';
import '../model/jmModel/login.dart';
import '../model/predefined_watch_listener.dart';
import '../util/AccountInfo.dart';
import 'package:markets/Connection/ISecITS/ITSClient.dart';
import 'package:markets/Connection/News/NewsClient.dart';
import '../model/exchData.dart';
import '../model/marketwatch_listener.dart';
import '../model/news_listener.dart';
import '../model/scrip_info_model.dart';
import 'package:markets/Connection/IQS/IQSClient.dart';
import 'package:markets/Connection/EOD/EODClient.dart';
import '../model/indices_listener.dart';
import '../screens/intellectChart/Charting/entity/k_line_entity.dart';
import 'package:mobx/mobx.dart' as mobx;
import '../widget/predefined_marketwatch.dart';
import 'CommonFunctions.dart';
import 'DateUtil.dart';

enum OrderType {
  none,
  modify,
  cancel,
  squareOff,
  convertPosition,
  rollover,
  deliveryBuySell,
}
enum ProductType { DummyFirst, FreeUser, Pro, Premium, Elite, DummyLast }

class Dataconstants {
  // static Alice alice;
  static FToast fToast = FToast();
  static var overlayStyle,deviceName,osName,devicemodel;
  static var fundstoken;
  static var items = [];
  static var pnlItems = [];
  static var ordernumber;
  static var jwtTokenThroughoutApp;
  static bool firsttimelogin = false, isMaterDownload = false;
  static var isWatchListChanged = false;
  static var tabView = <Widget>[];
  static LoginJson loginData;
  static List<MarketwatchListener> marketWatchListeners;
  static List<predefined_watch_listener> preDefinedWatchListeners;
  static PositionFilterController positionFilterController = Get.put(PositionFilterController());
  static ScannerController scannerData = Get.put(ScannerController());
  static String selectedFilterName = 'NSE - All Scrips';
  static ScannerConditions selectedScannerConditionForBearish = ScannerConditions.RedBody;
  static ScannerConditions selectedScannerConditionForBullish = ScannerConditions.GreenBody;
  static ScannerConditions selectedScannerConditionForOthers = ScannerConditions.VolumeRaiseAbove50;
  static int scannerTabControllerIndex = 0;
  static String globalFilePath;
  static List<EquityAndDerivativeIndicatorClass> equityAndDerivativeIndicatorList = [];
  static List<GroupMemberClass> groupList = [];
  static ProductType productType = ProductType.Premium;
  static var tradeScreenIndex = 0;
  static int ordersScreenIndex = 0;
  static bool isComingFromMarginCalculator = false;
  static bool isComingFromOptionCalculator = false;
  static bool isComingFromHome = false;
  static ScripInfoModel searchModel;
  // static FToast fToast;
  static bool isHeatMap = false;
  static bool sparkLine = true;
  static bool displayIndices = false, isUpdateOrderSettings = false;
  static bool isSip = false, showCancelAll = false, showSquareOffAll = false, showOrderFormKeyboard = false, isMainOnLogin = false, showPasswordPopup;
  static OrderBookController orderBookData = Get.put(OrderBookController());
  static TradeBookController tradeBookData = Get.put(TradeBookController());
  static NetPositionController netPositionController = Get.put(NetPositionController());
  static var dropDownInitialValue;
  static var bankCode;
  // static TodaysPositionController todaysPositionController = Get.put(TodaysPositionController());
  static FiftyTwoWeekHighController fiftyTwoWeekHighController = Get.put(FiftyTwoWeekHighController());
  static OiGainersController oiGainersController = Get.put(OiGainersController());
  static OiLosersController oiLosersController = Get.put(OiLosersController());
  static FiftyTwoWeekLowController fiftyTwoWeekLowController = Get.put(FiftyTwoWeekLowController());
  static MostActiveVolumeController mostActiveVolumeController = Get.put(MostActiveVolumeController());
  static MostActivePutController mostActivePutController = Get.put(MostActivePutController());
  static MostActiveTurnOverController mostActiveTurnOverController = Get.put(MostActiveTurnOverController());
  static BankDetailsController bankDetailsController = Get.put(BankDetailsController());
  static LimitController limitController = Get.put(LimitController());
  static WorldIndicesController worldIndicesController = Get.put(WorldIndicesController());

  static HoldingController holdingController = Get.put(HoldingController());
  static PortfolioHoldingController portfolioHoldingController = Get.put(PortfolioHoldingController());

  static MostActiveFuturesController mostActiveFuturesController = Get.put(MostActiveFuturesController());
  static DpHoldingController dpHoldingController = Get.put(DpHoldingController());
  static PortfolioEquityController portfolioEquityController = Get.put(PortfolioEquityController());
  static WatchListController watchListController;
  static var defaultWatchList = 0;
  static var defaultCashQuantity = 0;
  static var defaultFutureQuantity = 0;
  static var defaultOptionQuantity = 0;
  static String scripInfoProduct = '', scripInfoQty = '', scripInfoPrice = '';
  static String feUserID = "",
      feUserPassword1,
      feUserPassword2,
      feIP,
      // feMAC = '000000000000',
      feMAC = 'M',
      fileVersion = '',
      feDob;


  static DetailsControlller detailsController = Get.put(DetailsControlller());
  static EquitySipController equitySipController = Get.put(EquitySipController());
  static SummaryController summaryController = Get.put(SummaryController());
  static String moreSelectedText = 'more';
  static int profileSelectedIndex = 0;
  static int portfolioTabIndex = 0;
  static var authKey;

  static var mostActiveTab = 1;

  static StreamController<bool> pageController = BehaviorSubject<bool>();
  static StreamController<bool> profilePageController = BehaviorSubject<bool>();

  // static var limitResponse;
  @observable
  static List<ScripInfoModel> marketWatchList = ObservableList<ScripInfoModel>();
  @observable
  static List<ScripInfoModel> otherAssets = ObservableList<ScripInfoModel>();
  static final loadOtherAssets = mobx.Observable(false);
  static final setLoadOtherAssets = mobx.Action((bool value) {
    loadOtherAssets.value = value;
  });
  static var watchListNames = [];
  static int oneTimeFiltersLoadWatchlist = 0,
      oneTimeFiltersLoadIndices = 0,
      oneTimeFiltersLoadPredfined = 0,
      oneTimeFiltersLoadSummary = 0,
      oneTimeFiltersLoadPending = 0,
      oneTimeFiltersLoadExecuted = 0,
      oneTimeFiltersLoadHolding = 0,
      oneTimeFiltersLoadToday = 0,
      oneTimeFiltersLoadExpiry = 0;
  static bool isTabChanged = false;
  static var scriptCount = 0;
  static int positionIndex = 0, holdingIndex = 0;
  static int orderBookIndex = 0;
  static bool lifeCycleConstant = false, ispaused = false, isRgisterClicked = false, newUser = true, isAcessCodeSet = false, passwordChangeRequired = false, accountLocked = false;
  static var clientTypeData;

  static String pnlDropodownYear;
  static List<Map<String, bool>> orderBookLastFilters = [
    {
      'All': true,
      'Equity': false,
      'Future': false,
      'Option': false,
      'Currency': false,
      'Commodity': false,
    },
    {
      'All': true,
      'CNC': false,
      'MIS': false,
      'NRML': false,
    },
    {
      'All': true,
      'Executed': false,
      'Rejected': false,
      'Cancelled': false,
    }
  ];
  static List<Map<String, bool>> positionLastFilters = [
    {
      'All': true,
      'Equity': false,
      'Future': false,
      'Option': false,
      'Currency': false,
      'Commodity': false,
    },
    {
      'All': true,
      'CNC': false,
      'MIS': false,
      'NRML': false,
    },
    {
      'All': true,
      'Long': false,
      'Short': false,
    },
    {
      'All': true,
      'Daily': false,
      'Expiry': false,
    },
  ];

  // static var fundstoken;
  static OrderHistoryController orderHistoryController = Get.put(OrderHistoryController());

  // static const String appKey = '8g791^N029R47I831B8153=^O2f#7u8g'; //uat
  // static const String secretKey = "8p7410+74S6H3n=73q3v3965)`49c156"; //uat
  static const String appKey = '9d06O52030x965127LB11842u771038#'; // live
  static const String secretKey = '0=1279A81i951F*924^70G49gQ8tD863'; //Live
  static bool isAlgo = false;
  static String appInstanceId = '';
  static bool isFromToolsToAlgo = false;
  static bool isFromToolsToResearch = false;
  static bool isFromToolsToEasyOptions = false;
  static bool isFromToolsToBasketOrder = false;
  static String apiSession = '', portfolioName = '';
  static String uuid = '';
  static DateTime callPortfolioTiming;
  static GlobalKey coachMarkerKey = GlobalKey();
  static int atTimes = 0;
  static int atLogonTimes = 0;
  static var downTime = false;
  static var downTimeError = "";

  // static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static bool isBuy = false;
  static var allNews;
  static var dateTime = DateFormat("dd-MMM-yyyy").format(DateTime.parse(DateTime.now().toString()));
  static String todayDate = dateTime;
  static String chartFromDate = DateUtil.getIntFromDate1(DateFormat('dd-MMM-yyyy').format(DateTime.now().subtract(Duration(days: 1))) + ' 09:15:00').toString();
  static String chartToDate = DateUtil.getIntFromDate1(DateFormat('dd-MMM-yyyy').format(DateTime.now()) + ' 15:30:00').toString();
  static String eodIP = "13.233.10.105",
      iqsIP = "13.233.10.105",
      // static String eodIP = "180.149.242.215",
      // iqsIP = "180.149.242.215",
      newsIP = "180.149.242.215";
  static int eodPORT = 19303, iqsPORT = 19304, newsPORT = 18006;
  static String internetStatus;
  static int loginpressed = 0;
  static const List<String> array_option_type = const ['XX', 'CA', 'PA', 'CE', 'PE'];

  static var isStreamBuild = false;
  static int strMobileNo = 0, requestCounter = 0;
  static bool isFromOpenPosition = false, isOpenWebview = false, isOverviewEmpty = false, isrekyc = false;
  static TabController tabController;
  static List<String> tradeNotifications = [];
  static GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  static int serverLoginTime, serverDate, loginMode = 0; //0-2fa,1-access,2-fingerprint,3-registerAccess

  static String passwordChangeMessage = '', accountLockedMessage = '', userName = '';
  static ITSClient itsClient = ITSClient();
  //TODO: ALGODATACONStance
  static ITSClient2 itsClient2 = ITSClient2();
  static IQSClient iqsClient;
  static NewsClient newsClient;
  static const int nseCashIndexCodeStart = 26000;
  static int instructionIdAlgo;

  static var pauseAlgoStatus;
  static var resumeAlgoStatus;
  static const int nseCashIndexCodeEnd = 26099;
  static const int nseDerivIndexCodeStart = 999999999;
  static const int nseDerivIndexCodeEnd = 999999999;
  static const int bseCashIndexCodeStart = 999901;
  static const int bseCashIndexCodeEnd = 999999;
  static const int nCDEXCommodityDerivIndexCodeStart = 27500;
  static const int nCDEXCommodityDerivIndexCodeEnd = 29000;
  static const int mCXDerivIndexCodeStart = 323;
  static const int mCXDerivIndexCodeEnd = 331;
  static const int bseDerivIndexCodeStart = 999999999;
  static const int bseDerivIndexCodeEnd = 999999999;
  static const int maxWatchlistCount = 50;
  static int maxOrderQty = 100000;
  static int maxCashOrderValue = 30000000;
  static int maxDerivOrderValue = 30000000;
  static int traderRequestID = 0;
  static List<String> logs = [];
  static List<GroupData> groupData = [];
  static List<MemberData> memberData = [];
  static String fcmToken;
  static int themeValue;
  static String lastClicked = "My Watchlist";
  static String lastBottomTab = 'Watchlist';
  static String series = '';
  static bool masterExists = false;
  static bool isComingFromBasketSearch = false;
  static String rmName = '', rmMobileNo = '', rmOfficeTelNo = '', secondRmName = '', secondRmMobileNo = '', secondOfficeNo = '';
  static ScripInfoModel algoScriptModel;
  static ScripInfoModel basketSearchModel;

  static bool isFromAlgo = false;
  static bool isFromBasketOrder = false;
  static String basketName = '';

  static bool isAwaitingAlgoModify = false;
  static bool isFinishedAlgoModify = false;
  static bool isFromScripDetailToAdvanceScreen = false;
  static List<ScripInfoModel> recentViewedScrips = [];
  static List<String> recentSearchQueries = [];
  static List<AccountInfo> accountInfo = [];
  static int currentSelectedAccount = 0;
  static EODClient eodClient;
  static bool pageModify = false, isComingFromPortfolio = false;
  static bool osGuestUser = false;
  static bool algoSubmitted = false;

  // final FirebaseAnalytics analytics = FirebaseAnalytics();
  static IndicesListener indicesListener = IndicesListener();
  static final MarketwatchListener predefinedMarketWatchListener = MarketwatchListener(-1);
  static final MarketwatchListener indicesMarketWatchListener = MarketwatchListener(-2);
  static final MarketwatchListener summaryMarketWatchListener = MarketwatchListener(-3);

  static final NewsListener todayNews = NewsListener();
  static Map<int, ExchData> exchData = {
    0: ExchData(exch: 'N', exchTypeShort: 'C'), //Nse Cash
    1: ExchData(exch: 'N', exchTypeShort: 'D'), //Nse Deriv
    2: ExchData(exch: 'B', exchTypeShort: 'C'), //Bse Cash
    3: ExchData(exch: 'C', exchTypeShort: 'D'), //Nse Currency
    4: ExchData(exch: 'E', exchTypeShort: 'D'), //Bse Curreny
    5: ExchData(exch: 'M', exchTypeShort: 'D'), //Mcx
    //6: ExchData(exch: 'N', exchTypeShort: 'D'),
  };

  //0-Nse Equity,1-Nse Deriv,2-Bse Equity,3-Nse Curr,5-MCX
  static bool itsFreshConnection = true, iqsFreshConnection = true, eodFreshConnection = true, newsFreshConnection = true;
  static int feUserType = 0;
  static int feBranchID = 0;
  static int feChannelIdNC = 0;
  static int feChannelIdND = 0;
  static int feChannelIdBC = 0;
  static int feChannelIdCD = 0;
  static int feChannelIdMCX = 0;
  static int accountType = 2, gtcValidDays = 0;
  static var context;
  static String internalFeUserID = '', systemCustId = '', feUserName = '', feFirstName = '', commTncFlag = '', feLastLoginTime;

  static String getLastTimeLogin = '', getLastDateLogin = '', accessCodeText;

  static String utmSource, utmMedium, utmCampaign, utmContent, utmTerm, utmAdid, utmAdgroup;

  static DateTime exchStartDate = new DateTime(1980, 1, 1, 0, 0, 0);
  static DateTime exchStartDateMCX = new DateTime(1970, 1, 1, 0, 0, 0);
  static bool mf_holding_mode_popup = false;
  static String nseTradeDate,
      bseTradeDate,
      fnoTradeDate,
      currecnyTradeDate,
      deviceID,
      commodityTradeRate,
      tncFlag = '',
      eqTncFlag = '',
      foTncFlag = '',
      currTncFlag = '',
      eqTncText = '',
      foTncText = '',
      currTncText = '',
      commTncText = '';
  static DateTime minDate;
  static DateTime maxDate;
  static List<String> overviewPortfolioItems = ['Equity', 'Mutual Funds', 'Exchange-traded fund', 'NCD-Bonds', 'Sovereign Gold Bonds', 'Fixed Deposit', 'National Pension System', 'Reit', 'Invit'];
  static List<String> overviewPortfolioIcons = ['equity.svg', 'mutual fund.svg', 'exchange traded.svg', 'bond.svg', 'gold.svg', 'fixed deposit.svg', 'NPS.svg', 'reit.svg', 'invit.svg'];
  static List overviewPortfolioData = [];
  static List<String> filteredOverviewPortfolioData = ["0", "0", "0", "0", "0", "0", "0", "0", "0"];

  static final profileName = mobx.Observable('');
  static final setProfileName = mobx.Action((String value) {
    profileName.value = value;
  });

  // #region Chart
  static var nullCheckFlashTradeLineDraw = null; //chart tick by tick
  static bool isFromChart = false; //chart tick by tick
  static bool buySellPointColor = false; //chart tick by tick
  static bool chartTickByTick = false; //chart tick by tick
  static bool buySellButtonTickByTick = false; //chart tick by tick
  static bool buySellButtonTickByTick2 = false; //chart tick by tick
  static double closePriceTickByTick; //chart tick by tick
  static var ifsc = BankDetailsController.getBankDetailsListItems[0].ifsc;
  static var bankName = BankDetailsController.getBankDetailsListItems[0].name;
  static var accountNo = BankDetailsController.getBankDetailsListItems[0].accountNo;
  static var clientName = BankDetailsController.getBankDetailsListItems[0].clientName;
  static double lastX; //chart tick by tick
  static double currentX; //chart tick by tick
  static double lastPrice; //chart tick by tick
  static double curPrice; //chart tick by tick
  static double ltpTickByTick; //chart tick by tick
  static int index; //chart tick by tick
  static int indexTickByTic; //chart tick by tick
  static bool datasFull = false; //chart tick by tick
  static bool defaultBuySellChartSetting = false; //chart tick by tick
  static String indicatorChart; //chart tick by tick
  static ThemeData theme; //chart tick by tick
  static List<KLineEntity> datas = []; //chart tick by tick
  static List<double> y1 = []; //chart tick by tick
  static List<String> bQty = [];
  static List<bool> isBuyColor = []; //chart tick by tick
  static List<bool> isBuyColorFlashTrade = []; //chart tick by tick
  static List<bool> placedOrderLineTickByTick = []; //chart tick by tick
  static List<bool> createdFromFlashTrade = []; //chart tick by tick
  static List<int> timerChart = []; //chart tick by tick
  static List<int> timerFlashTradeStartTime = []; //chart tick by tick
  static List<int> timerFlashTradeEndTime = []; //chart tick by tick
  static List<int> timerChartPointHide = []; //chart tick by tick
  static ScripInfoModel modelForChart; //chart tick by tick
  static var responseForChart; //chart tick by tick
  static double chartHeight; //chart tick by tick
  static double chartWidth; //chart tick by tick
  static StreamController<bool> chartPageController = BehaviorSubject<bool>(); //chart ticl by tick
  static StreamController<bool> chartPageControllerFlashTrade = BehaviorSubject<bool>(); //chart ticl by tick
  static StreamController<bool> chartFilterController = BehaviorSubject<bool>(); //chart ticl by tick
  static StreamController<bool> drawLineOnBuySell = BehaviorSubject<bool>(); //chart ticl by
  static bool isComingFromHoldings = false;
  static bool isComingFormHoldings = false;

  // #end region

  // #region Scanners
  static Directory directory, mastersDataDirectory;
  static NumberFormat myFormat = NumberFormat.decimalPattern('hi_IN');
  static String localhost = '185.100.212.19:8080';
  static String fileDownloadUrl = 'http://$localhost/api/GetFile';
  static String dbFileName = 'http://$localhost/api/GetFileName';

  static void setNumberFormatValues() {
    myFormat.minimumFractionDigits = 2;
    myFormat.maximumFractionDigits = 2;
  }

  static bool masterLoaded = false;
  static TabController builduptabController = TabController(
    length: 9,
  );

  // #region end

  // #region cmots
  static ShareHoldingController shareHoldingController = Get.put(ShareHoldingController());
  static TopGainersController topGainersController = Get.put(TopGainersController());
  static TopLosersController topLosersController = Get.put(TopLosersController());
  static OpenIpoController openIpoController = Get.put(OpenIpoController());
  static RecentListingController recentListingController = Get.put(RecentListingController());
  static BulkDealsController bulkDealsController = Get.put(BulkDealsController());
  static UpcomingIpoController upcomingIpoController = Get.put(UpcomingIpoController());
  static BlockDealsController blockDealsController = Get.put(BlockDealsController());
  static MostActiveController mostActiveController = Get.put(MostActiveController());
  static MostActiveCallController mostActiveCallController = Get.put(MostActiveCallController());
  static CmotController cmotController = Get.put(CmotController());
  static ProfitAndLossController pnlController = Get.put(ProfitAndLossController());
  static BalanceSheetController balanceSheetController = Get.put(BalanceSheetController());
  static CashFlowController cashFlowController = Get.put(CashFlowController());
  static TopPerformingIndustriesController topPerformingIndustriesController = Get.put(TopPerformingIndustriesController());
  static EventsBonusController eventsBonusController = Get.put(EventsBonusController());
  static EventsDateController eventsDateController = Get.put(EventsDateController());
  static EventsSplitsController eventsSplitsController = Get.put(EventsSplitsController());
  // static EventsMonthController eventsMonthController = Get.put(EventsMonthController());
  static EventsDividendController eventsDividendController = Get.put(EventsDividendController());
  static BoardMeetController boardMeetController = Get.put(BoardMeetController());
  static EventsRightsController eventsRightsController = Get.put(EventsRightsController());
  static BseIndicesController bseIndicesController = Get.put(BseIndicesController());
  static FIICashController fiiCashController = Get.put(FIICashController());
  static FiiFnoController fiiFnoController = Get.put(FiiFnoController());
  static FiiDiiController fiiDiiController = Get.put(FiiDiiController());
  static AdvanceDeclineController advanceDeclineController = Get.put(AdvanceDeclineController());
  static NseIndicesController nseIndicesController = Get.put(NseIndicesController());
  static BseDeclineController bseDeclineController = Get.put(BseDeclineController());
  static BseAdvanceController bseAdvanceController = Get.put(BseAdvanceController());
  static NseAdvanceController nseAdvanceController = Get.put(NseAdvanceController());
  static NseDeclineController nseDeclineController = Get.put(NseDeclineController());

  static BrokerageController brokerageController = Get.put(BrokerageController());


  // #region end

  static List<bool> heatMapArray = [false, false, false, false];
  static List<bool> sparkLineArray = [false, false, false, false];

  static List multipleMapIDs = [];
  static String selectedID = "";
  static bool isBiometricOtpVerified = false, resetMPin = false, changeMPin = false, forgotPass = false, isVerifyLoginOtp = false, isMpinEnabled = false,mpinFlag = false;
  static String feUserDeviceID = "";
  static String currentMPin = "";
  static String confirmMPin = "";
  static String biometriccode = "";
  static String login2FAOtp = "";
  static List accountDetails = [];
  //Bhavesh
  static var nameListWatchList = [];
  static String cardViewflag;
  //Bhavesh

  /* Research */
  static ResearchCallsModel researchCallsModel = ResearchCallsModel();
  static TabController researchTabController;
  static List<ScripInfoModel> indexNifty50 = [];
  static List<ScripInfoModel> indexBankNifty = [];
  static String lastTradingFilter = 'All';
  static String lastFnoFilter = 'All';
  static String lastCurrencyFilter = 'All';
  static String lastCommodityFilter = 'All';
  static String lastInvestFilter = 'All';
  static bool searchResearch = false;

//########################->Bigul Algos <-##########################################
  static  FinishedController finishedController = Get.put(FinishedController());
  static AwaitingController awaitingController = Get.put(AwaitingController());
  static RunningController runningController = Get.put(RunningController());
  static FetchAlgoController fetchAlgoController = Get.put(FetchAlgoController());
  static AlgoCreateModel algoCreateModel = AlgoCreateModel();
  static ReportAlgo awaitinggAlgoToAdvanceScreen = ReportAlgo();
  static ReportFinishedAlgo finishedAlgoToAdvanceScreen = ReportFinishedAlgo();
  static AlgoLogController algoLogController = AlgoLogController();
  static AlgoLogModel algoLogModel = AlgoLogModel();
// static FetchAlgoModel fetchAlgoModel = FetchAlgoModel();
// static ReportRunningsModel reportRunningsModel = ReportRunningsModel();
// static ReportAlgoModel reportAlgoModel = ReportAlgoModel();
// static AlgoLogModel algoLogModel = AlgoLogModel();

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

}
