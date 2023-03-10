import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markets/jmScreens/addFunds/AddMoney.dart';
import 'package:markets/jmScreens/profile/settings.dart';
import '../../controllers/limitController.dart';
import '../../screens/web_view_link_screen.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../Scanners/ScannerList.dart';
import '../addFunds/AddFunds.dart';
import '../backoffice/backofficereport.dart';
import '../baskets/landing_page.dart';
import '../bulkOrder/bulk_order_landing_page.dart';
import '../calculators/marginCalculator.dart';
import '../equitySIP/EquitySipScreen.dart';
import '../market/market_landing_page.dart';
import '../profile/LimitScreen.dart';
import '../profile/profile.dart';

class JMMoreScreenOld extends StatefulWidget {
  final Stream<bool> stream;

  JMMoreScreenOld(this.stream);

  @override
  State<JMMoreScreenOld> createState() => _JMMoreScreenOldState();
}

class _JMMoreScreenOldState extends State<JMMoreScreenOld> {
  bool _isFreeProductsOpen = false, _isSubsProductsOpen = false;
  ScrollController _scrollController = ScrollController();
  final List _freeProducts = [
    products('Bonds', 'assets/appImages/more/bonds_basket.png',
        Color(0xffe5f9ff)),
    products('US Stocks', 'assets/appImages/more/us_stocks.png',
        Color(0xfffdf2f2)),
    products('IPO', 'assets/appImages/more/ipo.png', Color(0xfffff8e5)),
    products(
        'EDIS', 'assets/appImages/more/edis.png', Color(0xfffff8e5)),
    products('Equity SIP', 'assets/appImages/more/equity_sip_2.png',
        Color(0xffe5f9ff)),
    products('Basket', 'assets/appImages/more/bonds_basket.png',
        Color(0xfffdf2f2)),
  ],
      _marketAnalysis = [
        products('Market', 'assets/appImages/more/market.svg',
            Colors.transparent),
        products('Research', 'assets/appImages/more/research.svg',
            Colors.transparent),
        products('Analysis', 'assets/appImages/more/analysis.svg',
            Colors.transparent),
        products('Basket', 'assets/appImages/more/basket.svg',
            Colors.transparent),
        products('Bulk Order', 'assets/appImages/more/bulk.svg',
            Colors.transparent),
        products('Equity SIP', 'assets/appImages/more/equity_sip.svg',
            Colors.transparent),
      ];

  @override
  void initState() {
    widget.stream.listen((seconds) {
      _updateSeconds();
    });
    Dataconstants.limitController.getLimitsData();
    super.initState();
  }

  void _updateSeconds() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Dataconstants.moreSelectedText == 'profile'
        ? WillPopScope(
            onWillPop: () => handleWillPop(context),
            child: ProfileScreenJm(Dataconstants.profilePageController.stream))
        : Scaffold(
            appBar: AppBar(
              systemOverlayStyle: Dataconstants.overlayStyle,
              bottomOpacity: 2,
              title: Text(
                "More",
                style: Utils.fonts(
                    size: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Utils.blackColor),
              ),
              elevation: 1,
              // leading: InkWell(
              //   onTap: () {
              //     // setState(()
              //     //   DataConstants.moreSelectedText = 'more';
              //     // });
              //   },
              //   child: Icon(
              //     Icons.arrow_back,
              //     color: Utils.greyColor,
              //   ),
              // ),
              actions: [
                GestureDetector(
                    onTap: () {
                      // InAppSelection.mainScreenIndex = 1;
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (_) => MainScreen(
                      //       toChangeTab: false,
                      //     )));
                    },
                    child: SvgPicture.asset('assets/appImages/tranding.svg')),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      // InAppSelection.mainScreenIndex = 1;
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (_) => MainScreen(
                      //       toChangeTab: false,
                      //     )));
                    },
                    child:
                        SvgPicture.asset('assets/appImages/more/ringer.svg')),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () {
                      // InAppSelection.mainScreenIndex = 1;
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (_) => MainScreen(
                      //       toChangeTab: false,
                      //     )));
                    },
                    child: CircleAvatar(
                      radius: 12,
                      // child: SvgPicture.asset('assets/appImages/more/profile.svg'),
                    )),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
            body: SafeArea(
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xffbeb5f0),
                      Color(0xffd8d2f5),
                    ])),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 30, left: 15),
                                  child: Text(
                                    'Products beyond ',
                                    style: Utils.fonts(
                                      size: 22.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'the ordinary.',
                                    style: Utils.fonts(
                                      size: 22.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // SvgPicture.asset('assets/appImages/more/banner.svg'),
                            SizedBox(
                                height: size.height * 0.22,
                                width: size.width * 0.45,
                                child: Image.asset(
                                  'assets/appImages/more/banner.png',
                                  fit: BoxFit.scaleDown,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Container(
                          // height: size.height,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: theme.canvasColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                decoration: BoxDecoration(
                                  color: Color(0xfff4f5fc),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LimitScreen()),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Obx(() {
                                              return Text(
                                                // LimitController.limitData.value.availableMargin.toString(),
                                                CommonFunction.currencyFormat(LimitController.limitData.value.availableMargin),
                                                style: Utils.fonts(
                                                  size: 16.0,
                                                ),
                                              );
                                            }
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            'Available Balance',
                                            style: Utils.fonts(
                                                size: 11.0,
                                                fontWeight: FontWeight.w400,
                                                color: Utils.greyColor),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AddFunds()),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              right: 8, top: 8, bottom: 8, left: 5),
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
                                                style: Utils.fonts(
                                                    size: 11.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Utils.whiteColor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Current Subscription',
                                style: Utils.fonts(
                                  size: 16.0,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    // physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _isSubsProductsOpen ? 3 : 2,
                                    itemBuilder: (context, index) => Column(
                                          children: [
                                            Image.asset(
                                                'assets/appImages/start_sip.png'),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                          ],
                                        )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Free Products',
                                style: Utils.fonts(
                                  size: 16.0,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              GridView.builder(
                                  controller: _scrollController,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    crossAxisCount: 3,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: _freeProducts.length,
                                  // itemCount: isFreeProductsOpen ? freeProducts.length : 3,
                                  itemBuilder: (ctx, index) =>
                                      productsCard(_freeProducts[index], size)),
                              Visibility(
                                visible: _freeProducts.length > 6,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isFreeProductsOpen =
                                              !_isFreeProductsOpen;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'View More',
                                            style: Utils.fonts(
                                                size: 13.0,
                                                fontWeight: FontWeight.w500,
                                                color: Utils.primaryColor,
                                                textDecoration:
                                                    TextDecoration.underline),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          if (!_isFreeProductsOpen)
                                            SvgPicture.asset(
                                              'assets/appImages/arrow.svg',
                                              color: Utils.primaryColor,
                                            )
                                          else
                                            RotatedBox(
                                                quarterTurns: 2,
                                                child: SvgPicture.asset(
                                                  'assets/appImages/arrow.svg',
                                                  color: Utils.primaryColor,
                                                )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Subscription Products',
                                style: Utils.fonts(
                                  size: 16.0,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _isSubsProductsOpen ? 3 : 2,
                                  itemBuilder: (context, index) => Column(
                                        children: [
                                          Image.asset(
                                              'assets/appImages/start_sip.png'),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      )),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSubsProductsOpen = !_isSubsProductsOpen;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View More',
                                      style: Utils.fonts(
                                          size: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: Utils.primaryColor,
                                          textDecoration:
                                              TextDecoration.underline),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    if (!_isSubsProductsOpen)
                                      SvgPicture.asset(
                                        'assets/appImages/arrow.svg',
                                        color: Utils.primaryColor,
                                      )
                                    else
                                      RotatedBox(
                                          quarterTurns: 2,
                                          child: SvgPicture.asset(
                                            'assets/appImages/arrow.svg',
                                            color: Utils.primaryColor,
                                          )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Market Analysis',
                                style: Utils.fonts(
                                  size: 16.0,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              GridView.builder(
                                  controller: _scrollController,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    crossAxisCount: 3,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: _marketAnalysis.length,
                                  // itemCount: isFreeProductsOpen ? freeProducts.length : 3,
                                  itemBuilder: (ctx, index) => productsCard(
                                      _marketAnalysis[index], size)),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Tools',
                                style: Utils.fonts(
                                  size: 16.0,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              GridView(
                                controller: _scrollController,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 25,
                                        mainAxisSpacing: 25,
                                        crossAxisCount: 2,
                                        childAspectRatio: 2.5),
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BackOfficeReport()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Utils.greyColor
                                                .withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                              'assets/appImages/more/backoffice.svg'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Backoffice',
                                            style: Utils.fonts(
                                                size: 14.0,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MarginCalculator()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Utils.greyColor
                                                  .withOpacity(0.5)),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                              'assets/appImages/more/calculator.svg'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Calculator',
                                            style: Utils.fonts(
                                                size: 14.0,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      setState(() {
                                        Dataconstants.moreSelectedText =
                                            'profile';
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Utils.greyColor
                                                  .withOpacity(0.5)),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                              'assets/appImages/more/profile.svg'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Profile',
                                            style: Utils.fonts(
                                                size: 14.0,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Settings(true)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Utils.greyColor
                                                  .withOpacity(0.5)),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                              'assets/appImages/more/settings.svg'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Settings',
                                            style: Utils.fonts(
                                                size: 14.0,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
  }

  Widget productsCard(products item, Size size) {
    return InkWell(
      onTap: () async {
        if (item.name == "Analysis")
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Analytics()));
        else if (item.name == "Basket")
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => landingPage()));
        else if (item.name == "Equity SIP")
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EquitySipScreen()));
        else if (item.name == "Bulk Order")
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => bulkOrderLandingPage()));
        else if (item.name == "Market")
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MarketLandingPage()));
        else if(item.name == "IPO") {
          CommonFunction.firebaseEvent(
            clientCode: "dummy",
            device_manufacturer: Dataconstants.deviceName,
            device_model: Dataconstants.devicemodel,
            eventId: "6.0.9.0.0",
            eventLocation: "body",
            eventMetaData: "dummy",
            eventName: "ipo",
            os_version: Dataconstants.osName,
            location: "dummy",
            eventType: "Click",
            sessionId: "dummy",
            platform: Platform.isAndroid ? 'Android' : 'iOS',
            screenName: "guest user dashboard",
            serverTimeStamp: DateTime.now().toString(),
            source_metadata: "dummy",
            subType: "card",
          );
        }
        else if(item.name == "EDIS") {
          if(Dataconstants.clientTypeData == null) {
            var response = await CommonFunction.getClientType();
            if (response != null) {
              var responseJson = jsonDecode(response);
              Dataconstants.clientTypeData = responseJson['data'];
              if(Dataconstants.clientTypeData != null)
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.clientTypeData['edis_url'], 'EDIS')));
            }
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WebViewLinkScreen(Dataconstants.clientTypeData['edis_url'], 'EDIS')));
          }
        }
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: item.color, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            item.imageUrl.contains('png')
                ? SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(
                  item.imageUrl,
                ))
                : SvgPicture.asset(item.imageUrl),
            const SizedBox(
              height: 10,
            ),
            Text(
              item.name,
              style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget marketAnalysisCard() {}

  Future<bool> handleWillPop(BuildContext context) async {
    if (Dataconstants.moreSelectedText == 'profile') {
      if (Dataconstants.profileSelectedIndex != 1) {
        Dataconstants.profileSelectedIndex == 1;
        Dataconstants.pageController.add(true);
      }
    }
  }
}

class products {
  products(
      this.name,
      this.imageUrl,
      this.color,
      );

  String name;
  String imageUrl;
  Color color;
}
