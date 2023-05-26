import 'dart:convert';

import '../util/Dataconstants.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import '../util/CommonFunctions.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobx/mobx.dart';
import '../style/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InAppSelection {
  static int marketWatchID = 0;
  static String deeplink;
  static int orderReportScreenTabIndex = 0;
  static int algoOrderReportScreenTabIndex = 0;
  static int portfolioReportScreenTabIndex = 1;
  static int positionsReportScreenTabIndex = 0;
  static bool isNewsSubscribed;
  static bool isFourFiveClicked = false;
  static bool callOverviewPortfolio = false;
  static bool fingerPrintEnabled = false,
      portfolioEquityTitleToggle = false,
      portfolioFnoTitleToggle = false,
      portfolioCurrencyTitleToggle = false,
      portfolioCommoTitleToggle = false;
  static List<BiometricType> bioMetricData = [];
  static bool buyOrderSL = false,
      sellOrderSL = false,
      buyFutureOrderSL = false,
      sellFutureOrderSL = false,
      buyOptionOrderSL = false,
      sellOptionOrderSL = false,
      webLinkResearchOpen = true,
      isResearchOpen = true,
      isSystematicOpen = true,
      isMoreOpen = true,
      isServiceOpen = true,
      equityReportOpen = true,
      fnoReportOpen = true,
      commReportOpen = true,
      currReportOpen = true;
  static int buyOrderMarketLimit = 0,
      sellOrderMarketLimit = 0,
      buyOrderDelIntra = 0,
      buySellBasketorder = 0,
      buyAlgoOrderDelIntra = 0,
      sellOrderDelIntra = 0,
      buyFutureOrderMarketLimit = 0,
      buyCommodityOptionOrderLimit = 0,
      sellCommodityOptionOrderLimit = 0,
      sellFutureOrderMarketLimit = 0,
      buyFutureOrderDelIntra = 0,
      sellFutureOrderDelIntra = 0,
      buyOptionOrderMarketLimit = 0,
      sellOptionOrderMarketLimit = 0,
      buyOptionOrderDelIntra = 0,
      sellOptionOrderDelIntra = 0,
      advancedOrderNseBse = 0,
      advancedOrderMarketLimit = 0;
  static String orderBookFromDate,
      orderBookToDate,
      portfolioFnoFromDate,
      portfolioFnoToDate,
      portfolioCommodityFromDate,
      portfolioCommodityToDate,
      portfolioCurrencyFromDate,
      commodityTradeDate,
      portfolioCurrencyToDate;
  static var appsFlyerId;
  static var advertisingId;
  // static AppsflyerSdk appsflyerSdk;
  static var tabsView = [];
  static int orderPlacementScreenIndex = 0,
      equityDefaultQty,
      futureDefaultQty,
      optionDefaultQty;
  static var dashboardSettings = "";
  static int mainScreenIndex = 0;
  static int searchTabIndex = 0;
  static bool isBioMetricAvailable = false;
  @observable
  static var profileData;
  static String orderType, productType;
  static String productTypeEquity, productTypeDerivative;
  static bool newUserToIndices = true;
  static bool orderLimit = true, orderSL = false;
  static int orderProduct = 1, orderValidity = 0, orderProductforFNOCurr = 1;
  static String acessText;
  static String userid;
  static bool isBiometricEnable = false;

  static void saveSelections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('marketWatchID', marketWatchID);
    prefs.setInt('orderReportScreenTabIndex', orderReportScreenTabIndex);
    prefs.setBool("isFourFiveClicked", isFourFiveClicked);
    prefs.setString("deepLink", deeplink);
    prefs.setInt(
        'portfolioReportScreenTabIndex', portfolioReportScreenTabIndex);
    prefs.setInt(
        'positionsReportScreenTabIndex', positionsReportScreenTabIndex);
    prefs.setBool('newsNotification', isNewsSubscribed);
    prefs.setBool('buyOrderSL', buyOrderSL);
    prefs.setInt('buySellOrder', buySellBasketorder);
    prefs.setInt('buyOrderMarketLimit', buyOrderMarketLimit);
    prefs.setInt('buyOrderDelIntra', buyOrderDelIntra);
    prefs.setInt('buyAlgoOrderDelIntra', buyAlgoOrderDelIntra);
    prefs.setBool('sellOrderSL', sellOrderSL);
    prefs.setInt('sellOrderMarketLimit', sellOrderMarketLimit);
    prefs.setInt('sellOrderDelIntra', sellOrderDelIntra);
    prefs.setBool('callOverviewPortfolio', callOverviewPortfolio);
  }

  static void fetchSelections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dataconstants.showPasswordPopup = prefs.getBool("showPasswordPopup");
    marketWatchID = prefs.getInt('marketWatchID') ?? 0;
    orderReportScreenTabIndex = prefs.getInt('orderReportScreenTabIndex') ?? 0;
    deeplink = prefs.getString("deepLink") ?? '';
    Dataconstants.commodityTradeRate = prefs.getString("MCOTradeDate");
    portfolioReportScreenTabIndex =
        prefs.getInt('portfolioReportScreenTabIndex') ?? 1;
    positionsReportScreenTabIndex =
        prefs.getInt('positionsReportScreenTabIndex') ?? 0;
    isNewsSubscribed = prefs.getBool('newsNotification') ?? true;
    orderBookFromDate = orderBookToDate = CommonFunction.date;
    // #region Fetch Settings
    fingerPrintEnabled = prefs.getBool('FingerprintEnabled') ?? true;
    buyOrderSL = prefs.getBool('buyOrderSL') ?? false;
    buySellBasketorder = prefs.getInt('buySellOrder') ?? 0;
    buyOrderMarketLimit = prefs.getInt('buyOrderMarketLimit') ?? 0;
    buyOrderDelIntra = prefs.getInt('buyOrderDelIntra') ?? 0;
    buyAlgoOrderDelIntra = prefs.getInt('buyAlgoOrderDelIntra') ?? 0;
    sellOrderSL = prefs.getBool('sellOrderSL') ?? false;
    sellOrderMarketLimit = prefs.getInt('sellOrderMarketLimit') ?? 0;
    sellOrderDelIntra = prefs.getInt('sellOrderDelIntra') ?? 0;
    isResearchOpen = prefs.getBool('WebLinksResearchOpen') ?? true;
    isServiceOpen = prefs.getBool('WebLinksServiceOpen') ?? true;
    equityReportOpen = prefs.getBool('WebLinksEquityOpen') ?? true;
    fnoReportOpen = prefs.getBool('WebLinksFnoOpen') ?? true;
    commReportOpen = prefs.getBool('WebLinksCommOpen') ?? true;
    currReportOpen = prefs.getBool('WebLinksCurrOpen') ?? true;
    isSystematicOpen = prefs.getBool('WebLinksSystematicOpen') ?? true;
    isMoreOpen = prefs.getBool('WebLinksmoreOpen') ?? true;
    isFourFiveClicked = prefs.getBool('isFourFiveClicked') ?? false;
    callOverviewPortfolio = prefs.getBool('callOverviewPortfolio') ?? false;
    int themeVal = prefs.getInt('themeMode') ?? 0;
    Dataconstants.themeValue = prefs.getInt('themeMode') ?? 1;
    Dataconstants.systemCustId = prefs.getString('systemCustId') ?? '';
    themeVal == 0
        ? ThemeConstants.setLightTheme()
        : themeVal == 1
            ? ThemeConstants.setDarkTheme()
            : ThemeConstants.setAmoledTheme();

    newUserToIndices = prefs.getBool('newUserToIndices') ?? true;

    fingerPrintEnabled = prefs.getBool('FingerprintEnabled') ?? true;
    orderLimit = prefs.getBool('orderLimit') ?? true;
    orderSL = prefs.getBool('orderSL') ?? false;
    newUserToIndices = prefs.getBool('newUserToIndices') ?? true;
    orderProduct = prefs.getInt('orderProduct') ?? 1;
    orderValidity = prefs.getInt('orderValidity') ?? 0;
    Dataconstants.isAcessCodeSet = prefs.getBool('isAccessCodeSet') ?? false;
    acessText = prefs.getString('AcessCodeText');
    Dataconstants.isRgisterClicked = prefs.getBool('RegisterCLicked') ?? false;
    orderType = prefs.getString('orderType') ?? 'limit';
    productTypeEquity = prefs.getString('productTypeEquity') ?? 'CNC';
    productTypeDerivative = prefs.getString('productTypeDerivative') ?? 'NRML';
    equityDefaultQty = prefs.getInt('equityDefaultQty');
    futureDefaultQty = prefs.getInt('futureDefaultQty');
    optionDefaultQty = prefs.getInt('optionDefaultQty');
    dashboardSettings = prefs.getString('dashboardSettings') ?? "";
    Dataconstants.sparkLine = prefs.getBool("sparkLine") ?? true;
    Dataconstants.isHeatMap = prefs.getBool("heatMap") ?? false;

    if (dashboardSettings == "") {
      // var datas = [
      //   ["0", "Key Indices", false],
      //   ["1", "Limits", true],
      //   ["2", "Positions", true],
      //   ["3", "Trending Stocks", false],
      //   ["4", "Other Assets", false],
      //   ["5", "Market Breadth", false],
      //   ["6", "Top Performing Industries", false],
      //   ["7", "Orders", false],
      //   ["8", "Top Gainers", true],
      //   ["9", "Events", false],
      //   ["10", "Most Active", false],
      //   ["11", "JM Baskets", false],
      //   ["12", "My Ongoing SIPs", false],
      //   ["13", "Research", false],
      //   ["14", "Top Losers", true],
      //   ["15", "News", false],
      //   ["16", "Global Indices", false],
      //   ["17", "Circuit Breakers", false],
      //   ["18", "Option Chain", false],
      //   ["19", "OI Analysis", false],
      //   ["20", "Backoffice", false],
      //   ["21", "IPO", false],
      //   ["22", "NFO", false],
      //   ["23", "NCD", false],
      //   ["24", "DP Holdings", false]
      // ];

      var datas = [
        ["0", "Key Indices", true],
        ["1", "Limits", true],
        ["2", "Positions", true],
        ["3", "Orders", true],
        ["4", "Trending Stocks", true],
        ["5", "Other Assets", false],
        ["6", "Market Breadth", false],
        ["7", "Top Performing Industries", false],
        ["8", "Top Gainers", false],
        ["9", "Events", false],
        ["10", "Most Active", false],
        // ["11", "JM Baskets", false],
        // ["12", "My Ongoing SIPs", false],
        ["11", "Research", false],
        ["12", "Top Losers", false],
        ["13", "News", false],
        ["14", "Global Indices", false],
        ["15", "Circuit Breakers", false],
        ["16", "Option Chain", false],
        ["17", "OI Analysis", false],
        ["18", "Backoffice", false],
        ["19", "IPO", false],
        // ["22", "NFO", false],
        // ["23", "NCD", false],
        ["20", "DP Holdings", false]
    ];




      var jsons = json.encode(datas);
      dashboardSettings = jsons;
      prefs.setString("dashboardSettings", dashboardSettings);
      Dataconstants.orderBookLastFilters =
          prefs.getString('orderBookFilters') ??
              [
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
      Dataconstants.positionLastFilters = prefs.getString('positionFilters') ??
          [
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
    }

    Dataconstants.displayIndices = prefs.getBool("displayIndices") ?? false;

    tabsView = json.decode(prefs.getString("tabsView")) ?? [];
    Dataconstants.heatMapArray[InAppSelection.marketWatchID]=jsonDecode( prefs.getString("graphLists"))[InAppSelection.marketWatchID]  ?? false;
    Dataconstants.sparkLineArray[InAppSelection.marketWatchID]=jsonDecode( prefs.getString("sparkLine"))[InAppSelection.marketWatchID]  ?? false;

  }
}