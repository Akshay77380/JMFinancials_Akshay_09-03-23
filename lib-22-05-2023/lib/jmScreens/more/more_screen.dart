import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:markets/jmScreens/Scanners/ScannersView.dart';
import 'package:markets/jmScreens/addFunds/FundTranscation.dart';
import 'package:markets/jmScreens/news/news.dart';
import 'package:markets/jmScreens/profile/settings.dart';
import 'package:markets/jmScreens/research/research_screen.dart';
import 'package:markets/style/theme.dart';
import 'package:markets/util/BrokerInfo.dart';
import 'package:markets/util/Dataconstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../Controllers/Basket_order/getAllBasket_controller.dart';
import '../../controllers/AlgoController/fetchAlgoController.dart';
import '../../controllers/limitController.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../screens/web_view_link_screen.dart';
import '../../util/CommonFunctions.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/scripdetail_optionChain.dart';
import '../Scanners/ScannerList.dart';
import '../addFunds/AddFunds.dart';
import '../algoscreen/bigulAlgorithem.dart';
import '../backoffice/combinedledgerbackoffice.dart';
import '../backoffice/contractnote.dart';
import '../backoffice/pnlreport.dart';
import '../backoffice/sebimtfcfrreport.dart';
import '../backoffice/sebimtfledger.dart';
import '../backoffice/tradereport.dart';
import '../basketOrder/BasketWatch.dart';
import '../baskets/landing_page.dart';
import '../bulkOrder/bulk_order_landing_page.dart';
import '../calculators/marginCalculator.dart';
import '../market/market_landing_page.dart';
import '../profile/LimitScreen.dart';
import '../profile/profile.dart';
import '../redirectedWidgets/options.dart';
import '../stockSip/equity_sip_order_report_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class JMMoreScreen extends StatefulWidget {
  const JMMoreScreen({Key key}) : super(key: key);

  @override
  State<JMMoreScreen> createState() => _JMMoreScreenState();
}

class GridData {
  GridData({
    this.title,
    this.imgUrl,
    this.pageCode,
    this.subTitle,
  });

  final String title;
  final String imgUrl;
  final String pageCode;
  final String subTitle;
// bool toggleChange;
}

class SelectCard extends StatelessWidget {
  SelectCard({Key key, this.gridData, this.selectedIndex}) : super(key: key);
  final GridData gridData;
  final int selectedIndex;

  Future downloadFile(imageSrc) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    var imageDownloadPath = '${dir.path}/$formattedDate.pdf';
    await dio.download(imageSrc, imageDownloadPath, onReceiveProgress: (received, total) {
      var progress = (received / total) * 100;
      // debugprint('Rec: $received , Total: $total, $progress%');
    });
    // downloadFile function returns path where image has been downloaded
    return imageDownloadPath;
  }

  @override
  Widget build(BuildContext context) {
    var p3;

    return Card(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        //color: Colors.white,
        //elevation: 0,
        child: Center(
          child: InkWell(
            onTap: () async {
              if (gridData.title == "Analysis")
                Navigator.push(context, MaterialPageRoute(builder: (context) => Analytics()));
              else if (gridData.title == "US Stocks")
                // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen('https://www.jmfinancialservices.in/product-investments/us-investing/', "US Stocks")));
                await launchUrl((Uri.parse('https://www.jmfinancialservices.in/product-investments/us-investing/')));
              else if (gridData.title == "Open API")
                // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen('https://developer.jmfonline.in/', "Open API")));
                await launchUrl((Uri.parse('https://developer.jmfonline.in/')));
              else if (gridData.title == "IPO")
                // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen('https://myipo.jmfonline.in/', "IPO")));
                launch((('https://myipo.jmfonline.in/')));
              else if (gridData.title == "BONDS")
                // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen('https://bondskart.com/authenticate/signup?source=BT', "Bonds")));
                launch((('https://bondskart.com/authenticate/signup?source=BT')));
              else if (gridData.title == "Basket")
                Navigator.push(context, MaterialPageRoute(builder: (context) => landingPage()));
              else if (gridData.title == "Screeners")
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScannersView()));
              else if (gridData.title == "Equity SIP")
                Navigator.push(context, MaterialPageRoute(builder: (context) => EquitySipOrderReportScreen()));
              else if (gridData.title == "Bulk Order")
                Navigator.push(context, MaterialPageRoute(builder: (context) => bulkOrderLandingPage()));
              else if (gridData.title == "Market")
                Navigator.push(context, MaterialPageRoute(builder: (context) => MarketLandingPage()));
              else if (gridData.title == "Profile")
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreenJm(Dataconstants.profilePageController.stream)));
              else if (gridData.title == "Settings")
                Navigator.push(context, MaterialPageRoute(builder: (context) => Settings(true)));
              else if (gridData.title == "Calculator")
                Navigator.push(context, MaterialPageRoute(builder: (context) => MarginCalculator()));
              else if (gridData.title == "Combined Ledger")
                Navigator.push(context, MaterialPageRoute(builder: (context) => CombinedLedgerBackoffice()));
              else if (gridData.title == "Trade Report")
                Navigator.push(context, MaterialPageRoute(builder: (context) => TradeReports()));
              else if (gridData.title == "Transfer Funds")
                Navigator.push(context, MaterialPageRoute(builder: (context) => FundTransactions(index: 0)));
              else if (gridData.title == "Sebi MTF Ledger")
                Navigator.push(context, MaterialPageRoute(builder: (context) => SebiMtfLedger()));
              else if (gridData.title == "Sebi MTF CFR Report")
                Navigator.push(context, MaterialPageRoute(builder: (context) => SebiMtfCfrReport()));
              else if (gridData.title == "P&L Reports")
                Navigator.push(context, MaterialPageRoute(builder: (context) => backOffice()));
              else if (gridData.title == "Contract Note")
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContractNote()));
              else if (gridData.title == "Options Chain")
                Navigator.push(context, MaterialPageRoute(builder: (context) => OptionsPage(false)));
              else if (gridData.title == "NEWS")
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage()));
              else if (gridData.title == "ESIP")
                Navigator.push(context, MaterialPageRoute(builder: (context) => EquitySipOrderReportScreen()));
              else if (gridData.title == "WhatsApp support")
                launch(Dataconstants.whatsApp);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.whatsApp, "WhatsApp Support")));
              else if (gridData.title == "Segment Activation")
                launch(Dataconstants.segment);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.segment, "Segment Activation")));
              else if (gridData.title == "Basket Order") {
                Dataconstants.getAllBasketsController.fetchBasketList();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BasketWatch(
                              isFromScripDetail: false,
                            )));
              }
              else if (gridData.title == "EDIS") {
                // await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "api/v2/GetClientDpType", {}, Dataconstants.loginData.data.jwtToken);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen('https://tradeapiuat.jmfonline.in/eDISCDSL/Live/Live?UID=${Dataconstants.feUserID}', 'EDIS')));
                // if (Dataconstants.clientTypeData == null) {
                //   var response = await CommonFunction.getClientType();
                //   if (response != null) {
                //     var responseJson = jsonDecode(response);
                //     Dataconstants.clientTypeData = responseJson['data'];
                //     if (Dataconstants.clientTypeData != null)
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.clientTypeData['edis_url'], 'EDIS')));
                  // }
                // }
              } else if (gridData.title == "Research") {
                CommonFunction.getResearchClientStructuredCallEntries();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResearchScreen()));
              } else if (gridData.title == "API") {
                launch(Dataconstants.api);
                // Navigator.push(context, MaterialPageRoute(builder:5 (context) => WebViewLinkScreen(Dataconstants.api, 'API')));
              } else if (gridData.title == "IPO") {
                launch(Dataconstants.ipo);
                // CommonFunction.firebaseEvent(
                //   clientCode: "dummy",
                //   device_manufacturer: Dataconstants.deviceName,
                //   device_model: Dataconstants.devicemodel,
                //   eventId: "6.0.9.0.0",
                //   eventLocation: "body",
                //   eventMetaData: "dummy",
                //   eventName: "ipo",
                //   os_version: Dataconstants.osName,
                //   location: "dummy",
                //   eventType: "Click",
                //   sessionId: "dummy",
                //   platform: Platform.isAndroid ? 'Android' : 'iOS',
                //   screenName: "guest user dashboard",
                //   serverTimeStamp: DateTime.now().toString(),
                //   source_metadata: "dummy",
                //   subType: "card",
                // );
                // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.ipo, 'IPO')));
              } else if (gridData.title == "Algo") {
                //print("object");
                Dataconstants.fetchAlgoController.fetchAlgoList();
                Navigator.push(context, MaterialPageRoute(builder: (context) => bigulAlgorithem()));
              }
              else if (gridData.title == "EDIS") {
                if (Dataconstants.clientTypeData == null) {
                  var response = await CommonFunction.getClientType();
                  if (response != null) {
                    var responseJson = jsonDecode(response);
                    Dataconstants.clientTypeData = responseJson['data'];
                    if (Dataconstants.clientTypeData != null) Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.clientTypeData['edis_url'], 'EDIS')));
                    Dataconstants.clientTypeData = null;
                  }
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.clientTypeData['edis_url'], 'EDIS')));
                }
              }
            },
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              gridData.imgUrl.contains("svg")
                  ? SvgPicture.asset(
                      gridData.imgUrl,
                      height: 35,
                      width: 30,
                      color: Utils.primaryColor.withOpacity(0.9),
                    )
                  : Image.asset(
                      gridData.imgUrl,
                      height: 35,
                      width: 30,
                    ),
              SizedBox(
                height: 10,
              ),
              Text(gridData.title, textAlign: TextAlign.center, style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400)
                  // style: TextStyle(fontSize: 14)
                  ),
            ]),
          ),
        ));
  }
}

class BuildListTile extends StatelessWidget {
  BuildListTile({Key key, this.gridData, this.theme, this.isLight, this.selectedIndex}) : super(key: key);
  final GridData gridData;
  final ThemeData theme;
  final int selectedIndex;
  var isLight = ThemeConstants.themeMode.value == ThemeMode.light;

  Future downloadFile(imageSrc) async {
    Dio dio = Dio();
    var dir = await getApplicationDocumentsDirectory();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    var imageDownloadPath = '${dir.path}/$formattedDate.pdf';
    await dio.download(imageSrc, imageDownloadPath, onReceiveProgress: (received, total) {
      var progress = (received / total) * 100;
      // debugprint('Rec: $received , Total: $total, $progress%');
    });
    // downloadFile function returns path where image has been downloaded
    return imageDownloadPath;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            if (gridData.title == "Analysis")
              Navigator.push(context, MaterialPageRoute(builder: (context) => Analytics()));
            else if (gridData.title == "Basket")
              Navigator.push(context, MaterialPageRoute(builder: (context) => landingPage()));
            else if (gridData.title == "Equity SIP")
              Navigator.push(context, MaterialPageRoute(builder: (context) => EquitySipOrderReportScreen()));
            else if (gridData.title == "Bulk Order")
              Navigator.push(context, MaterialPageRoute(builder: (context) => bulkOrderLandingPage()));
            else if (gridData.title == "Market")
              Navigator.push(context, MaterialPageRoute(builder: (context) => MarketLandingPage()));
            else if (gridData.title == "Profile")
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreenJm(Dataconstants.profilePageController.stream)));
            else if (gridData.title == "Settings")
              Navigator.push(context, MaterialPageRoute(builder: (context) => Settings(true)));
            else if (gridData.title == "Calculator")
              Navigator.push(context, MaterialPageRoute(builder: (context) => MarginCalculator()));
            else if (gridData.title == "Combined Ledger")
              Navigator.push(context, MaterialPageRoute(builder: (context) => CombinedLedgerBackoffice()));
            else if (gridData.title == "Trade Report")
              Navigator.push(context, MaterialPageRoute(builder: (context) => TradeReports()));
            else if (gridData.title == "Market Update & Review") {
            } else if (gridData.title == "Sebi MTF Ledger")
              Navigator.push(context, MaterialPageRoute(builder: (context) => SebiMtfLedger()));
            else if (gridData.title == "Sebi MTF CFR Report")
              Navigator.push(context, MaterialPageRoute(builder: (context) => SebiMtfCfrReport()));
            else if (gridData.title == "P&L Reports")
              Navigator.push(context, MaterialPageRoute(builder: (context) => backOffice()));
            else if (gridData.title == "Contract Note")
              Navigator.push(context, MaterialPageRoute(builder: (context) => ContractNote()));
            else if (gridData.title == "Research") {
              CommonFunction.getResearchClientStructuredCallEntries();
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResearchScreen()));
            } else if (gridData.title == "API") {
              launch(Dataconstants.api);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.api, 'API')));
            }
            else if (gridData.title == "EDIS") {
              var links = await Dataconstants.itsClient.httpPostWithHeaderNew(BrokerInfo.mainUrl + "api/v2/GetClientDpType", {}, Dataconstants.loginData.data.jwtToken);print("qwertyuiop: }");
              // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen("https://tradeapiuat.jmfonline.in/eDISCDSL/Live/Live?UID={UserId}", 'EDIS')));
            } else if (gridData.title == "IPO") {
              launch(Dataconstants.ipo);
              // CommonFunction.firebaseEvent(
              //   clientCode: "dummy",
              //   device_manufacturer: Dataconstants.deviceName,
              //   device_model: Dataconstants.devicemodel,
              //   eventId: "6.0.9.0.0",
              //   eventLocation: "body",
              //   eventMetaData: "dummy",
              //   eventName: "ipo",
              //   os_version: Dataconstants.osName,
              //   location: "dummy",
              //   eventType: "Click",
              //   sessionId: "dummy",
              //   platform: Platform.isAndroid ? 'Android' : 'iOS',
              //   screenName: "guest user dashboard",
              //   serverTimeStamp: DateTime.now().toString(),
              //   source_metadata: "dummy",
              //   subType: "card",
              // );
              // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.ipo, 'IPO')));
            } else if (gridData.title == "BONDS")
            // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen('https://bondskart.com/authenticate/signup?source=BT', "Bonds")));
            {
              launch((('https://bondskart.com/authenticate/signup?source=BT')));
            } else if (gridData.title == "Algo") {
              //print("object");
              Dataconstants.fetchAlgoController.fetchAlgoList();
              Navigator.push(context, MaterialPageRoute(builder: (context) => bigulAlgorithem()));
            } else if (gridData.title == "EDIS") {
              if (Dataconstants.clientTypeData == null) {
                var response = await CommonFunction.getClientType();
                if (response != null) {
                  var responseJson = jsonDecode(response);
                  Dataconstants.clientTypeData = responseJson['data'];
                  if (Dataconstants.clientTypeData != null) Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.clientTypeData['edis_url'], 'EDIS')));
                }
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.clientTypeData['edis_url'], 'EDIS')));
              }
            }
          },
          child: ListTile(
            dense: true,
            //visualDensity: VisualDensity(horizontal: -2, vertical: 0),
            title: Text(gridData.title, style: Utils.fonts(size: 14.0)
                // style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
            // subtitle: Text(gridData.subTitle == null ? "Invest in stocks" : gridData.subTitle,
            //     style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w400)
            //     // style: TextStyle(
            //     //   fontSize: 13,
            //     // )
            // ),
            trailing: gridData.imgUrl.contains("svg")
                ? SvgPicture.asset(
                    gridData.imgUrl,
                    height: 35,
                    width: 30,
                  )
                : Image.asset(
                    gridData.imgUrl,
                    height: 35,
                    width: 30,
                  ),
          ),
        ),
        Container(
          height: 0.7,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isLight ? Color(0xffE7E8EA) : theme.canvasColor,
          ),
        ),
      ],
    );
  }
}

class _JMMoreScreenState extends State<JMMoreScreen> with TickerProviderStateMixin {
  int selectedIndex = 0;
  int pageCount = 6;
  bool toggleChange = false;
  var isLight;
  List<GridData> Trading = <GridData>[
    GridData(title: 'Portfolio', subTitle: 'Pay-in & Pay-out details', pageCode: 'FNOCASPRO', imgUrl: 'assets/appImages/bottom_portfolio.svg'),
    GridData(title: 'Transfer Funds', subTitle: 'Realized & Un-Realized Profit & Loss', pageCode: 'FNOPNLSTM', imgUrl: 'assets/appImages/transference.png'),
    GridData(title: 'Options Chain', subTitle: '', pageCode: '', imgUrl: 'assets/appImages/optionChain.svg'),
    GridData(title: 'Global Investing', subTitle: '', pageCode: '', imgUrl: 'assets/appImages/more/analysis.svg'),
    GridData(title: 'Basket Order', subTitle: '', pageCode: '', imgUrl: 'assets/appImages/shopping-cart.png'),
    GridData(title: 'Screeners', subTitle: '', pageCode: '', imgUrl: 'assets/appImages/more/analysis.svg'),
    GridData(title: 'ETF', subTitle: '', pageCode: '', imgUrl: 'assets/appImages/etf.png'),
    GridData(title: 'Pledge Stock', subTitle: '', pageCode: '', imgUrl: 'assets/appImages/funding.png'),
    GridData(title: 'API', subTitle: '', pageCode: '', imgUrl: 'assets/appImages/documentation.png'),
    GridData(title: 'Algo', subTitle: 'Pay-in & Pay-out details', pageCode: 'FNOCASPRO', imgUrl: 'assets/appImages/more/profile.svg'),
    GridData(title: 'Market', subTitle: 'Pay-in & Pay-out details', pageCode: 'FNOCASPRO', imgUrl: 'assets/appImages/more/profile.svg'),
    GridData(title: 'EDIS', subTitle: 'Future Plus position conversion', pageCode: 'FNOCVTPOS', imgUrl: 'assets/appImages/more/analysis.svg'),
  ];
  List<GridData> Investments = <GridData>[
    GridData(
      title: 'MF',
      subTitle: 'Pledge Shares & Create Limits',
      pageCode: 'SHRASMRG',
      imgUrl: "assets/appImages/more/bonds_basket.png",
    ),
    GridData(
      title: 'Investment Basket',
      subTitle: 'Primary Market Actions',
      pageCode: 'IPOFPOBUY',
      imgUrl: 'assets/appImages/more/us_stocks.png',
    ),
    GridData(title: 'IPO', subTitle: 'Equity baskets for wealth creation', pageCode: 'PREMPF', imgUrl: 'assets/appImages/more/ipo.png'),
    GridData(title: 'BONDS', pageCode: 'OFS', subTitle: 'Offer for Sale', imgUrl: 'assets/appImages/more/edis.png'),
    GridData(title: 'BUY BACK', pageCode: 'MYNETWRTH', subTitle: 'Portfolio value across all segments', imgUrl: 'assets/appImages/more/equity_sip_2.png'),
    GridData(title: 'OFS', subTitle: 'Pay-in & Pay-out details', pageCode: 'EQCASPROJ', imgUrl: 'assets/appImages/more/bonds_basket.png'),
    GridData(title: 'ESIP', pageCode: 'EQCVTDELV', subTitle: 'MTF Shares moved to Demat', imgUrl: "assets/appImages/more/bulk.svg"),
    GridData(title: 'ETF', pageCode: 'EQCVTDELV', subTitle: 'MTF Shares moved to Demat', imgUrl: "assets/appImages/etf.png"),
    GridData(title: 'MTF', pageCode: 'EQCVTDELV', subTitle: 'MTF Shares moved to Demat', imgUrl: "assets/appImages/more/bulk.svg"),
  ];

  List<GridData> Research = <GridData>[
    GridData(title: 'Research', subTitle: 'Realized & Un-Realized Profit & Loss', pageCode: 'FNOPNLSTM', imgUrl: 'assets/appImages/more/research.svg'),
    GridData(title: 'Investment Basket', subTitle: 'Pay-in & Pay-out details', pageCode: 'FNOCASPRO', imgUrl: 'assets/appImages/more/us_stocks.png'),
    GridData(title: 'Short Term Ideas', subTitle: 'Future Plus position conversion', pageCode: 'FNOCVTPOS', imgUrl: 'assets/appImages/more/analysis.svg'),
    GridData(title: 'NEWS', subTitle: 'Future Plus position conversion', pageCode: 'FNOCVTPOS', imgUrl: 'assets/appImages/news.png'),
    GridData(title: 'Results', subTitle: 'Future Plus position conversion', pageCode: 'FNOCVTPOS', imgUrl: 'assets/appImages/Results.png'),
    GridData(title: 'Screeners', subTitle: 'Future Plus position conversion', pageCode: 'FNOCVTPOS', imgUrl: 'assets/appImages/more/analysis.svg'),
    GridData(title: 'Corporate Actions', subTitle: 'Future Plus position conversion', pageCode: 'FNOCVTPOS', imgUrl: 'assets/appImages/Corporate.png'),
    GridData(title: 'PortFolio Optimizer', subTitle: 'Future Plus position conversion', pageCode: 'FNOCVTPOS', imgUrl: 'assets/appImages/PortFoliOptimizer.png'),
  ];

  List<GridData> Tools = <GridData>[
    GridData(title: 'Margin Requirement', subTitle: 'Available Limit & Utilized Limit', pageCode: 'COMLIMT', imgUrl: "assets/appImages/more/analysis.svg"),
    GridData(title: 'Back office reports', subTitle: 'Pay-in & Pay-out details', pageCode: 'COMCASPRO', imgUrl: "assets/appImages/report.png"),
    GridData(title: 'Margin Calculators', subTitle: 'Margin utilised details', pageCode: 'COMISCMRG', imgUrl: "assets/appImages/accounts.png"),
    GridData(title: 'Sebi MTF Ledger', subTitle: 'Realized & Un-Realized Profit & Loss', pageCode: 'COMPLSTM', imgUrl: "assets/images/more/p&l_statement.svg"),
    GridData(title: 'Sebi MTF CFR Report', subTitle: 'Realized & Un-Realized Profit & Loss', pageCode: 'COMPLSTM', imgUrl: "assets/images/more/p&l_statement.svg"),
    GridData(title: 'P&L Reports', subTitle: 'Realized & Un-Realized Profit & Loss', pageCode: 'COMPLSTM', imgUrl: "assets/images/more/p&l_statement.svg"),
    GridData(title: 'Contract Note', subTitle: 'Realized & Un-Realized Profit & Loss', pageCode: 'COMPLSTM', imgUrl: "assets/images/more/p&l_statement.svg"),
    GridData(title: 'Pledge Report', subTitle: 'Realized & Un-Realized Profit & Loss', pageCode: 'COMPLSTM', imgUrl: "assets/images/more/p&l_statement.svg"),
  ];

  List<GridData> Subscriptions = <GridData>[
    GridData(title: 'Brokerage Plans', subTitle: 'Available Limit & Utilized Limit', pageCode: 'CURLIMT', imgUrl: "assets/appImages/more/calculator.svg"),
    GridData(title: 'Research SMS', subTitle: 'Pay-in & Pay-out details', pageCode: 'CURCASPRO', imgUrl: "assets/appImages/more/profile.svg"),
    GridData(title: 'JM Basketst', subTitle: 'Future Plus Stop Loss position conversion', pageCode: 'CURCVTPOS', imgUrl: "assets/appImages/more/settings.svg"),
    GridData(title: 'MINT', subTitle: 'Future Plus Stop Loss position conversion', pageCode: 'CURCVTPOS', imgUrl: "assets/appImages/more/settings.svg"),
    GridData(title: 'Fox Trade', subTitle: 'Future Plus Stop Loss position conversion', pageCode: 'CURCVTPOS', imgUrl: "assets/appImages/more/settings.svg"),
  ];

  List<GridData> Help = <GridData>[
    GridData(title: 'View DEMO', subTitle: 'Start your Investment journey', pageCode: 'ORDSEPREQ', imgUrl: "assets/appImages/more/analysis.svg"),
    GridData(title: 'Useful Links', subTitle: 'View SIP Requests', pageCode: 'SEPRQBOOK', imgUrl: "assets/appImages/more/analysis.svg"),
    GridData(title: 'WhatsApp support', subTitle: 'List of eligible Stocks for SIP', pageCode: 'SEPSTKLST', imgUrl: "assets/appImages/WhatsApp.png"),
    GridData(title: 'Call Support', subTitle: 'List of eligible Stocks for SIP', pageCode: 'SEPSTKLST', imgUrl: "assets/appImages/callsupport.png"),
    GridData(title: 'CNT Desk', subTitle: 'List of eligible Stocks for SIP', pageCode: 'SEPSTKLST', imgUrl: "assets/appImages/more/analysis.svg"),
    GridData(title: 'Segment Activation', subTitle: 'Start your Investment journey', pageCode: 'ORDSEPREQ', imgUrl: "assets/appImages/more/analysis.svg"),
    GridData(title: 'Contact us', subTitle: 'View SIP Requests', pageCode: 'SEPRQBOOK', imgUrl: "assets/appImages/contact-us.png"),
    GridData(title: 'FAQs', subTitle: 'List of eligible Stocks for SIP', pageCode: 'SEPSTKLST', imgUrl: "assets/appImages/faq1.png"),
    GridData(title: 'Refer n Earn', subTitle: 'List of eligible Stocks for SIP', pageCode: 'SEPSTKLST', imgUrl: "assets/appImages/Referearn.jpg"),
    GridData(title: 'Rate us', subTitle: 'List of eligible Stocks for SIP', pageCode: 'SEPSTKLST', imgUrl: "assets/appImages/rate.png"),
  ];

  //
  // List<GridData> tempServices = <GridData>[
  //   GridData(title: 'Pledge Confirmation (MTF/ SAM)', subTitle: 'Pledge link for NSDL & CDSL Account', pageCode: 'PLGCONG', imgUrl: "assets/images/more/pleadge_confirmation.svg"),
  //   GridData(title: 'Open an Account', subTitle: 'Start Investment Journey', imgUrl: "assets/images/more/open_account.svg"),
  //   GridData(title: 'Refer & Earn', subTitle: 'Referral link', pageCode: 'REFEREARN', imgUrl: "assets/images/more/refer&earn.svg"),
  //   GridData(title: 'General Profile', subTitle: 'View/Edit your profile', pageCode: 'GENPROFL', imgUrl: "assets/images/more/general_profile.svg"),
  //   GridData(title: 'Relationship Code', subTitle: 'Enter RM Code', pageCode: 'RELSCODE', imgUrl: "assets/images/more/relationship_code.svg"),
  //   GridData(title: 'Brokerage Plan', subTitle: 'View/Upgrade your broking plan', pageCode: 'SELBRKPLN', imgUrl: "assets/images/more/brokerage_plan.svg"),
  //   GridData(title: 'FAQs', subTitle: 'Frequently Asked Questions', imgUrl: "assets/images/more/idirect_faq.svg"),
  //   GridData(title: 'Rate I-direct Representative', subTitle: 'Rate your Relationship Manager', imgUrl: "assets/images/more/rate_i-direct.svg"),
  //   GridData(title: 'Contact Us', subTitle: 'Get in touch with us', imgUrl: "assets/images/more/contact_us.svg"),
  //   GridData(title: 'Contact Us-Escalation', subTitle: 'Escalation Matrix', imgUrl: "assets/images/more/contact_us.svg"),
  // ];
  //
  // List<GridData> service = <GridData>[
  //   GridData(title: 'Pledge Confirmation (MTF/ SAM)', subTitle: 'Pledge link for NSDL & CDSL Account', pageCode: 'PLGCONG', imgUrl: "assets/images/more/pleadge_confirmation.svg"),
  //   GridData(title: 'Open an Account', subTitle: 'Start Investment Journey', imgUrl: "assets/images/more/open_account.svg"),
  //   GridData(title: 'Refer & Earn', subTitle: 'Referral link', pageCode: 'REFEREARN', imgUrl: "assets/images/more/refer&earn.svg"),
  //   GridData(title: 'General Profile', subTitle: 'View/Edit your profile', pageCode: 'GENPROFL', imgUrl: "assets/images/more/general_profile.svg"),
  //   GridData(title: 'Relationship Code', subTitle: 'Enter RM Code', pageCode: 'RELSCODE', imgUrl: "assets/images/more/relationship_code.svg"),
  //   GridData(title: 'Brokerage Plan', subTitle: 'View / Upgrade your broking plan', pageCode: 'SELBRKPLN', imgUrl: "assets/images/more/brokerage_plan.svg"),
  //   GridData(title: 'ICICIdirect Neo', subTitle: 'Subscribe to Rs.20 per order plan', imgUrl: "assets/images/more/icici_direct.svg"),
  //   GridData(title: 'FAQs', subTitle: 'Frequently Asked Questions', imgUrl: "assets/images/more/idirect_faq.svg"),
  //   GridData(title: 'Rate I-direct Representative', subTitle: 'Rate your Relationship Manager', imgUrl: "assets/images/more/rate_i-direct.svg"),
  //   GridData(title: 'Contact Us', subTitle: 'Get in touch with us', imgUrl: "assets/images/more/contact_us.svg"),
  //   GridData(title: 'Contact Us-Escalation', subTitle: 'Escalation Matrix', imgUrl: "assets/images/more/contact_us.svg"),
  // ];
  //
  // List<GridData> more = <GridData>[
  //   GridData(title: 'My Messages', subTitle: 'Important Notifications', pageCode: 'MYMSG', imgUrl: "assets/images/more/my_messages.svg"),
  //   GridData(title: 'Direct Alerts', subTitle: 'Set Alert for Stocks', pageCode: 'DIRCTALRT', imgUrl: "assets/images/more/direct_alerts.svg"),
  //   GridData(title: 'General Allocation Logs', subTitle: 'Fund allocation summary', pageCode: 'GENALLOC', imgUrl: "assets/images/more/general_allocation_logs.svg"),
  //   GridData(title: 'Terms & Conditions', subTitle: 'Accept/View T&C', pageCode: 'ISECTNC', imgUrl: "assets/images/more/terms&condition.svg"),
  //   GridData(title: 'Report an Issue', subTitle: 'Share your Experience', pageCode: 'FEEDBACK', imgUrl: "assets/images/more/report_an_issue.svg"),
  //   GridData(title: 'iLearn', subTitle: 'Download Investor Education App', imgUrl: "assets/images/more/ilearn.svg"),
  // ];

  List imgPath = [
    "assets/appImages/Trading.png",
    "assets/appImages/more/us_stocks.png",
    "assets/appImages/more/market.svg",
    "assets/appImages/more/backoffice.svg",
    "assets/appImages/cost.png",
    "assets/appImages/customerhelp.png",
  ];

  List name = ["Trading", "Investment", "Research", "Tool", "Subscription", "Help"];

  PageController _pageController = PageController();
  List names = [];

  @override
  void initState() {
    // GetScripFromBasketController   getScripFromBasketController = Get.put(GetScripFromBasketController());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fun1();
      await Dataconstants.summaryController.getSummaryApi();
      await Dataconstants.detailsController.getDetailResult();
      await CommonFunction.getPnlYears();
    });
    Dataconstants.bankDetailsController.getBankDetails();
    Dataconstants.limitController.getLimitsData();
    CommonFunction.getProfileData();
    names = Dataconstants.profileName.value.toString().split(" ");

    super.initState();
  }

  void fun1() async {
    var res;
    String mydata = "pqrs@@1008_pqrs##1008_11";
    String bs64 = base64.encode(mydata.codeUnits);
    //print(bs64);

    var header = {"authkey": bs64};

    res = await ITSClient.httpGetPortfolio(
        "https://mobilepms.jmfonline.in/WebLoginValidatePassword3.svc/WebLoginValidatePassword3GetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~*~~*~~*", header);

    var jsonRes = jsonDecode(res);

    Dataconstants.authKey = jsonRes["WebLoginValidatePassword3GetDataResult"][0]["AuthorisationKey"];
    // await CommonFunction.backOfficeTrPositionsCMDetail();
    // await CommonFunction.backOfficeTrPlSummary();
    // Dataconstants.summaryController.getSummaryApi();
    // Dataconstants.detailsController.getDetailResult();
    // await CommonFunction.getPnlYears();
  }

  @override
  Widget build(BuildContext context) {
    isLight = ThemeConstants.themeMode.value == ThemeMode.light;
    var theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     // Container(
        //     //   decoration: BoxDecoration(
        //     //     color: Utils.primaryColor.withOpacity(0.5),
        //     //     borderRadius: BorderRadius.circular(37),
        //     //   ),
        //     //   child: Padding(
        //     //     padding: const EdgeInsets.all(8),
        //     //     child: Text(
        //     //       names[0] == "" ? "" : names.map((e) => e.toString().characters.first).toString().replaceAll("(", "").replaceAll(")", "").replaceAll(", ", ""),
        //     //       style: Utils.fonts(size: 24.0, fontWeight: FontWeight.w600, color: Utils.whiteColor),
        //     //       textAlign: TextAlign.center,
        //     //     ),
        //     //   ),
        //     // ),
        //     // SizedBox(
        //     //   width: 15,
        //     // ),
        //     // Observer(
        //     //   builder: (context) {
        //     //     return Text(
        //     //       InAppSelection.profileData['name'].toString().split(" ")[0],
        //     //       style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
        //     //       // style: TextStyle(
        //     //       //   fontWeight: FontWeight.w700,
        //     //       //   fontSize: 18,
        //     //       //   color: theme.textTheme.bodyText1.color,
        //     //       // ),
        //     //     );
        //     //   }
        //     // )
        //     // !Dataconstants.osGuestUser
        //     //     ? Observer(builder: (context) {
        //     //         return Text(
        //     //           InAppSelection.profileData['name'] ?? "",
        //     //           style: TextStyle(
        //     //             fontWeight: FontWeight.w700,
        //     //             fontSize: 18,
        //     //             color: theme.textTheme.bodyText1.color,
        //     //           ),
        //     //         );
        //     //       })
        //     //     : Text(
        //     //         Dataconstants.strMobileNo.toString(),
        //     //         style: TextStyle(
        //     //           fontWeight: FontWeight.w700,
        //     //           fontSize: 18,
        //     //           color: theme.textTheme.bodyText1.color,
        //     //         ),
        //     //       )
        //   ],
        // ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LimitScreen()),
            );
          },
          child: Container(
            height: 82,
            width: 299,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Utils.primaryColor.withOpacity(0.1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Text(
                    'Available Balance',
                    style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w400, color: Utils.greyColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // !Dataconstants.osGuestUser
                  //     ?
                  Observer(
                    builder: (context) => FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text(
                            "\u{20B9}",
                            style: Utils.fonts(size: 30.0, color: Utils.primaryColor),
                            // style: TextStyle(
                            //   color: theme.primaryColor,
                            //   fontWeight: FontWeight.w500,
                            //   fontSize: 30,
                            // ),
                          ),
                          Obx(() {
                            return LimitController.isLoading.value
                                ? CircularProgressIndicator()
                                : LimitController.limitData == null
                                    ? Text(
                                        "0",
                                        style: Utils.fonts(size: 20.0, color: Utils.primaryColor),
                                      )
                                    : Text(
                                        // LimitController.limitData.value.availableMargin.toString(),
                                        CommonFunction.currencyFormat(LimitController.limitData.value.availableMargin),
                                        style: Utils.fonts(size: 20.0, color: Utils.primaryColor),
                                      );
                          }),
                          // DecimalText(
                          //   CommonFunction.toolsFormat(
                          //     (Dataconstants.equityLimit.value.cashLimit) +
                          //         (Dataconstants.fnoLimit.value.availableLimit) +
                          //         (Dataconstants.reportLimit.value.availableLimit) +
                          //         (Dataconstants.toolsLimit.value.limit),
                          //   ),
                          //   style: TextStyle(
                          //     color: theme.primaryColor,
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 30,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                  // : FittedBox(
                  //     fit: BoxFit.scaleDown,
                  //     child: DecimalText(
                  //       '₹ 0.00',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 30,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddFunds()),
            );
          },
          child: Container(
            width: 120,
            padding: EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 5),
            decoration: BoxDecoration(
              color: Utils.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Utils.whiteColor,
                  size: 24,
                ),
                Text(
                  'Top-Up Funds',
                  style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.whiteColor),
                )
              ],
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     SizedBox(
        //       height: 35,
        //       width: 130,
        //       child: ElevatedButton(
        //         child: Text(
        //           'Manage Funds',
        //           style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
        //         ),
        //         style: ElevatedButton.styleFrom(
        //           primary: theme.primaryColor,
        //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        //         ),
        //         onPressed: () {
        //           // Navigator.of(context).pushNamed(MarginScreen.routeName);
        //         },
        //       ),
        //     ),
        //     // if (Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].blockDepositFlag != 'B')
        //     SizedBox(
        //       height: 35,
        //       width: 122,
        //       child: ElevatedButton(
        //         child: Text(
        //           'Add Funds',
        //           style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
        //         ),
        //         style: ElevatedButton.styleFrom(
        //           primary: theme.primaryColor,
        //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        //         ),
        //         onPressed: () async {
        //           // var cstatus = await Permission.camera.status;
        //           // var sstatus = await Permission.storage.status;
        //           // if (sstatus.isDenied || cstatus.isDenied || cstatus.isPermanentlyDenied || sstatus.isPermanentlyDenied) {
        //           //   await [Permission.camera, Permission.storage, Permission.photos].request();
        //           //   cstatus = await Permission.camera.status;
        //           //   sstatus = await Permission.storage.status;
        //           //
        //           //   if (sstatus.isDenied || cstatus.isDenied || cstatus.isPermanentlyDenied || sstatus.isPermanentlyDenied) {
        //           //     await showDialog(
        //           //         context: context,
        //           //         builder: (BuildContext context) {
        //           //           return Platform.isIOS && (cstatus.isPermanentlyDenied || sstatus.isPermanentlyDenied)
        //           //               ? CupertinoAlertDialog(
        //           //                   title: Text(
        //           //                     'Permission Alert',
        //           //                     style: TextStyle(fontSize: 18),
        //           //                   ),
        //           //
        //           //                   content: Text(
        //           //                     "Please grant permission for camera to use features under this facility",
        //           //                     style: TextStyle(fontSize: 14),
        //           //                   ),
        //           //                   //content: ChangelogScreen(),
        //           //                   actions: <Widget>[
        //           //                     TextButton(
        //           //                       child: Text(
        //           //                         'OK',
        //           //                         style: TextStyle(
        //           //                           color: theme.primaryColor,
        //           //                         ),
        //           //                       ),
        //           //                       onPressed: () {
        //           //                         openAppSettings();
        //           //                       },
        //           //                     ),
        //           //                   ],
        //           //                 )
        //           //               : AlertDialog(
        //           //                   contentPadding: EdgeInsets.fromLTRB(24, 20, 10, 10),
        //           //                   title: Text(
        //           //                     'Permission Alert',
        //           //                     style: TextStyle(fontSize: 18),
        //           //                   ),
        //           //                   buttonPadding: EdgeInsets.zero,
        //           //                   content: Text(
        //           //                     "Please grant permission for camera to use features under this facility",
        //           //                     style: TextStyle(fontSize: 14),
        //           //                   ),
        //           //                   //content: ChangelogScreen(),
        //           //                   actions: <Widget>[
        //           //                     TextButton(
        //           //                       child: Text(
        //           //                         'OK',
        //           //                         style: TextStyle(
        //           //                           color: theme.primaryColor,
        //           //                         ),
        //           //                       ),
        //           //                       onPressed: () {
        //           //                         openAppSettings();
        //           //                       },
        //           //                     ),
        //           //                   ],
        //           //                 );
        //           //         });
        //           //   }
        //           // } else {
        //           //   if (Platform.isAndroid) {
        //           //     p3 = 'android';
        //           //   } else {
        //           //     p3 = 'ios';
        //           //   }
        //           //   // Navigator.push(
        //           //   //   context,
        //           //   //   MaterialPageRoute(
        //           //   //     builder: (context) => WebViewLinkScreen('ADD FUNDS', 'FUNDTRANS', 'OtherPara=$p3&p15=${Dataconstants.fileVersion}'),
        //           //   //   ),
        //           //   // );
        //           // }
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 0.9,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isLight ? Color(0xffE7E8EA) : theme.canvasColor,
          ),
        ),
        Container(
          // color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.white : Colors.transparent,
          // color: Utils.lightGreyColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      toggleChange = !toggleChange;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: isLight
                                ? toggleChange == true
                                    ? AssetImage("assets/appImages/more/light_toggle_list.png")
                                    : AssetImage("assets/appImages/more/light_toggle_grid.png")
                                : toggleChange == true
                                    ? AssetImage("assets/appImages/more/list_toggle.png")
                                    : AssetImage("assets/appImages/more/grid_toggle.png"))),
                    height: 22,
                    width: 56,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Settings(false),
                        ),
                      );
                    },
                    child: Icon(Icons.settings_rounded, size: 19)),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                    onTap: () {
                      CommonFunction.bottomSheet(context, 'Logout');
                    },
                    child: Icon(Icons.logout, size: 19))
              ],
              // )
              // ],
            ),
          ),
        ),
        Container(
          height: 0.9,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isLight ? Color(0xffE7E8EA) : theme.canvasColor,
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(
                  right: BorderSide(
                    color: isLight ? Color(0xffE7E8EA) : theme.canvasColor,
                    width: 0.7,
                  ),
                )),
                width: 90,
                child: Container(
                  // color: Colors.blue,
                  color: isLight ? Colors.white : Colors.transparent,
                  child: ListView.separated(
                      padding: EdgeInsets.only(top: 7),
                      itemCount: 6,
                      separatorBuilder: ((context, index) {
                        return SizedBox(
                          height: 2,
                        );
                      }),
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              _pageController.jumpToPage(index);
                            });
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  color: isLight ? Colors.white : Colors.transparent,
                                  child: Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), child: buildScrollList("${imgPath[index]}", "${name[index]}", index)),
                                )),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15, top: 10),
                                  child: AnimatedContainer(duration: Duration(microseconds: 500), height: (selectedIndex == index) ? 75 : 0, width: 4, color: theme.primaryColor
                                      //1E2130 242424
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
                ),
              ),
              Expanded(
                  child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  toggleChange == true
                      ? ListView.builder(
                          itemCount: Dataconstants.isPoa == "Y" ? Trading.length - 1 : Trading.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return BuildListTile(gridData: Trading[index], selectedIndex: selectedIndex, theme: theme, isLight: this.isLight);
                          },
                        )
                      : GridView.count(
                          padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          children: List.generate(Dataconstants.isPoa == "Y" ? Trading.length - 1 : Trading.length, (index) {
                            return Center(
                              child: SelectCard(
                                gridData: Trading[index],
                                selectedIndex: selectedIndex,
                              ),
                            );
                          })),
                  toggleChange == true
                      ? ListView.builder(
                          itemCount: Investments.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return BuildListTile(gridData: Investments[index], selectedIndex: selectedIndex, theme: theme, isLight: this.isLight);
                          },
                        )
                      : GridView.count(
                          padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          children: List.generate(Investments.length, (index) {
                            return Center(
                              child: SelectCard(
                                gridData: Investments[index],
                                selectedIndex: selectedIndex,
                              ),
                            );
                          })),
                  toggleChange == true
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: Research.length,
                          itemBuilder: (context, index) {
                            return BuildListTile(gridData: Research[index], theme: theme, isLight: this.isLight, selectedIndex: selectedIndex);
                          },
                        )
                      : GridView.count(
                          padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          children: List.generate(Research.length, (index) {
                            return Center(
                              child: SelectCard(gridData: Research[index], selectedIndex: selectedIndex),
                            );
                          })),
                  toggleChange == true
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: Tools.length,
                          itemBuilder: (context, index) {
                            return BuildListTile(gridData: Tools[index], theme: theme, selectedIndex: selectedIndex, isLight: this.isLight);
                          },
                        )
                      : GridView.count(
                          padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          children: List.generate(Tools.length, (index) {
                            return Center(
                              child: SelectCard(gridData: Tools[index], selectedIndex: selectedIndex),
                            );
                          })),
                  toggleChange == true
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: Subscriptions.length,
                          itemBuilder: (context, index) {
                            return BuildListTile(gridData: Subscriptions[index], theme: theme, isLight: this.isLight, selectedIndex: selectedIndex);
                          },
                        )
                      : GridView.count(
                          padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          children: List.generate(Subscriptions.length, (index) {
                            return Center(
                              child: SelectCard(gridData: Subscriptions[index], selectedIndex: selectedIndex),
                            );
                          })),
                  toggleChange == true
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: Help.length,
                          itemBuilder: (context, index) {
                            return BuildListTile(gridData: Help[index], theme: theme, isLight: this.isLight, selectedIndex: selectedIndex);
                          },
                        )
                      : GridView.count(
                          padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                          children: List.generate(Help.length, (index) {
                            return Center(
                              child: SelectCard(gridData: Help[index], selectedIndex: selectedIndex),
                            );
                          })),
                  // toggleChange == true
                  //     ? ListView.builder(
                  //         padding: EdgeInsets.zero,
                  //         itemCount:
                  //             // Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].damTransaction == 'E' && (!Dataconstants.osGuestUser)
                  //             //     ? service.length
                  //             //     :
                  //             tempServices.length,
                  //         itemBuilder: (context, index) {
                  //           return BuildListTile(
                  //               gridData:
                  //                   // Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].damTransaction == 'E' &&
                  //                   //         (!Dataconstants.osGuestUser)
                  //                   //     ? service[index]
                  //                   //     :
                  //                   tempServices[index],
                  //               theme: theme,
                  //               selectedIndex: selectedIndex,
                  //               isLight: this.isLight);
                  //         },
                  //       )
                  //     : GridView.count(
                  //         padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
                  //         // shrinkWrap: true,
                  //         // physics: NeverScrollableScrollPhysics(),
                  //         crossAxisCount: 3,
                  //         crossAxisSpacing: 2,
                  //         mainAxisSpacing: 15,
                  //         children: List.generate(
                  //             // Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].damTransaction == 'E' && (!Dataconstants.osGuestUser)
                  //             //     ? service.length
                  //             //     :
                  //             tempServices.length, (index) {
                  //           return Center(
                  //             child: SelectCard(
                  //                 gridData:
                  //                     // Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].damTransaction == 'E' &&
                  //                     //         (!Dataconstants.osGuestUser)
                  //                     //     ? service[index]
                  //                     //     :
                  //                     tempServices[index],
                  //                 selectedIndex: selectedIndex),
                  //           );
                  //         })),
                  // toggleChange == true
                  //     ? ListView.builder(
                  //         padding: EdgeInsets.zero,
                  //         itemCount: more.length,
                  //         itemBuilder: (context, index) {
                  //           return BuildListTile(gridData: more[index], theme: theme, selectedIndex: selectedIndex, isLight: this.isLight);
                  //         },
                  //       )
                  //     : GridView.count(
                  //         padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 0),
                  //         // shrinkWrap: true,
                  //         // physics: NeverScrollableScrollPhysics(),
                  //         crossAxisCount: 3,
                  //         crossAxisSpacing: 2,
                  //         mainAxisSpacing: 20,
                  //         children: List.generate(more.length, (index) {
                  //           return Center(
                  //             child: SelectCard(gridData: more[index], selectedIndex: selectedIndex),
                  //           );
                  //         })),
                ],
              ))
            ],
          ),
        ),
        Container(
          height: 0.9,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isLight ? Color(0xffE7E8EA) : theme.canvasColor,
          ),
        ),
        /* Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 8),
                      child: Text(
                        'Share as margin',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    onPressed: () {
                      CommonFunction.fireBaseEventLogging(
                          "account_details_screen",
                          "Shares as Margin_Click",
                          "Shares as Margin");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            'Shares as Margin',
                            'SHRASMRG',
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 8),
                      child: Text(
                        'iLearn',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    onPressed: () async {
                      CommonFunction.fireBaseEventLogging(
                          "account_details_screen",
                          "ICICIdirect iLearn app App_Click",
                          "ICICIdirect iLearn app App");
                      await launch(BrokerInfo.iLearnApp);
                      // CommonFunction.fireBaseEventLogging(
                      //     "account_details_screen",
                      //     "ICICIdirect iLearn app App_Click",
                      //     "ICICIdirect iLearn app App");
                      // await launchUrl(Uri.parse(BrokerInfo.iLearnApp));
                    },
                  ),
                  ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 8),
                      child: Text(
                        'Money App (MF & Others)',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    onPressed: () async {
                      CommonFunction.fireBaseEventLogging(
                          "account_details_screen",
                          "ICICI Direct Money App_Click",
                          "ICICI Direct Money App");
                      if (Platform.isAndroid) {
                        await LaunchApp.openApp(
                          androidPackageName: 'com.icici.direct',
                        );
                      } else {
                        if (await canLaunch(BrokerInfo.moneyUrlScheme))
                          launch(BrokerInfo.moneyUrlScheme);
                      }
                    },
                  ),
                ],
              ),
            ),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isLight ? Colors.white : Color(0xff2F4052),
            ),
          ),*/
        Container(
          height: 0.9,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isLight ? Color(0xffE7E8EA) : theme.canvasColor,
          ),
        ),
      ],
    );
  }

  Column buildScrollList(String imgPath, String txt, int index) {
    return Column(
      children: [
        Container(
          // height: 60,
          // width: 60,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: imgPath.contains("svg")
                ? SvgPicture.asset(
                    imgPath,
                    height: 25,
                    width: 25,
                    //fit: BoxFit.fill,
                  )
                : Image.asset(
                    imgPath,
                    height: 35,
                    width: 30,
                  ),
          ),
          decoration: BoxDecoration(
              color: isLight
                  ? Color(0xffF2F4F7)
                  : index == selectedIndex
                      ? Color(0xff242424)
                      : Color(0xff1E2130),
              borderRadius: BorderRadius.circular(12)),
          // margin: EdgeInsets.symmetric(vertical: 20),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          txt,
          textAlign: TextAlign.center,
          style: Utils.fonts(
              fontWeight: isLight
                  ? index == selectedIndex
                      ? FontWeight.bold
                      : FontWeight.w400
                  : index == selectedIndex
                      ? FontWeight.bold
                      : FontWeight.w400,
              size: 11.0,
              //color: theme.textTheme.bodyText1.color,
              color: isLight
                  ? index == selectedIndex
                      ? Color(0xff4a4a4a)
                      : Color(0xff737373)
                  : index == selectedIndex
                      ? Colors.white
                      : Colors.grey),
        ),
        // SizedBox(
        //   height: 10,
        // )
      ],
    );
  }
}
