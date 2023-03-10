import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/jmScreens/portfolio/closed_holdings.dart';
import 'package:markets/jmScreens/portfolio/list_holder.dart';
import 'package:markets/jmScreens/portfolio/dividend_portfolio.dart';
import 'package:markets/jmScreens/portfolio/empty_portfolio_screen.dart';

import '../../Connection/ISecITS/ITSClient.dart';
import '../../screens/web_view_link_screen.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'equity_portfolio.dart';
import 'f&o_portfolio.dart';
import 'view_transactions.dart';

class PortfolioScreenJm extends StatefulWidget {

  int index = 0;

  PortfolioScreenJm(this.index);

  @override
  State<PortfolioScreenJm> createState() => _PortfolioScreenJmState();
}

class _PortfolioScreenJmState extends State<PortfolioScreenJm>
    with TickerProviderStateMixin {
  var res ;
  TabController _tabController;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fun1();
      // CommonFunction.portfolioDpHoldings();
      // CommonFunction.portfolioIOPendingDeliveries();
      // CommonFunction.portfolioTrPLSummaryCMYTD();
      // CommonFunction.portfolioTrPositionsCM();
      // CommonFunction.portfolioTrRealTimeTradesDer();
      // CommonFunction.portfolioStockValuation();
      // CommonFunction.portfolioAccountSummary();
      // CommonFunction.portfolioTrPLSummaryCMYTDDetail();
      // CommonFunction.portfolioTrPositionsCMDetail();
      // CommonFunction.portfolioTrPLSummaryCMFY();
      // CommonFunction.portfolioTrPLSummaryCMFYDetail();
    });

    _tabController = TabController(vsync: this, length: 5) ..addListener(() {
      setState(() {});
    });

    _tabController.index = widget.index;
    super.initState();
  }

  void fun1()async{
    try{
      String mydata = "pqrs@@1008_pqrs##1008_11";
      String bs64 = base64.encode(mydata.codeUnits);
      //print(bs64);

      var header = {
        "authkey" : bs64
      };

      res = await ITSClient.httpGetPortfolio(
          "https://mobilepms.jmfonline.in/WebLoginValidatePassword3.svc/WebLoginValidatePassword3GetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~*~~*~~*",
          header
      );

      var jsonRes = jsonDecode(res);

      Dataconstants.authKey = jsonRes["WebLoginValidatePassword3GetDataResult"][0]["AuthorisationKey"];

    }catch(e, s){
      //print(e);
    }

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          title: InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => viewTransactions()
                  )
              );
            },
            child: Text(
              "Portfolio",
              style: Utils.fonts(
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyText1.color
              ),
            ),
          ),
          actions: [
            Dataconstants.portfolioTabIndex ==1?
            Center(
              child: SvgPicture.asset(
                "assets/appImages/search.svg",
              ),
            ):SizedBox.shrink(),
            SizedBox(
              width: 12,
            ),
            InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus.unfocus();
                  CommonFunction.marketWatchBottomSheet(context);
                },
                child: SvgPicture.asset('assets/appImages/tranding.svg')),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    context: context,
                    builder: (context) {
                      return ParameterBottomSheet();
                    });
              },
              child: Icon(
                Icons.more_vert,
                color: Utils.greyColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
                child: TabBar(
                  isScrollable: true,
                  labelStyle:
                      Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                  unselectedLabelStyle:
                      Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                  unselectedLabelColor: Colors.grey[600],
                  labelColor: Utils.primaryColor,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.symmetric(horizontal: 20),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 0,
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 40.0,
                    insets: EdgeInsets.symmetric(horizontal: 2),
                    indicatorColor: Utils.primaryColor.withOpacity(0.3),
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  controller: _tabController,
                  onTap: (_index) {
                    setState(() {
                      Dataconstants.portfolioTabIndex=_index;
                      //print("index : $_index");
                    });
                  },
                  tabs: [
                    Tab(
                      child: Text("Equity"),
                    ),
                    Tab(
                      child: Text("F&O"),
                    ),
                    Tab(
                      child: Text("MF"),
                    ),
                    Tab(
                      child: Text("Commodity"),
                    ),
                    Tab(
                      child: Text("Currency"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              physics: CustomTabBarScrollPhysics(),
              controller: _tabController,
              children: [
                EquityPorfolio(),
                Fno_portfolio(),
               Text("MF"),
                Fno_portfolio(),
                Fno_portfolio(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget DotExpand(ScrollController scrollController) {
    return Stack(children: <Widget>[
      SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 3,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Utils.lightGreyColor),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => closedHoldings()
                            )
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Utils.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                        ),
                        child: Text(
                          "View Closed Holdings",
                          style: TextStyle(
                              fontSize: 16,
                              color: Utils.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 5),
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey[350],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Filter by',
                  style: Utils.fonts(fontWeight: FontWeight.w600, size: 21.0),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'SEGMENT',
                  style: Utils.fonts(fontWeight: FontWeight.w500, size: 16.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Icon(Icons.abc),
                        ),
                        Text('All')
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Icon(Icons.abc),
                        ),
                        Text('Cash')
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Icon(Icons.abc),
                        ),
                        Text('ETF')
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Icon(Icons.abc),
                        ),
                        Text('Bees')
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  child: Text(
                    'Sort By',
                    style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                Column(
                  children: [
                    RadioListTile(
                      title: Text(
                        'A - Z',
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      value: true,
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey[350],
                    ),
                    RadioListTile(
                      title: Text('Z - A'),
                      value: true,
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey[350],
                    ),
                    RadioListTile(
                      title: Text('CHG% High - Low'),
                      value: true,
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey[350],
                    ),
                    RadioListTile(
                      title: Text('CHG% Low - High'),
                      value: true,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'STATUS',
                  style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Select Expiry',
                  style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Sort By',
                  style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 35,
                ),
              ]),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Center(
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.grey[350],
                        border: Border.all(color: Colors.black)),
                    child: Center(
                        child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                  ),
                  // Spacer(flex: 1),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Center(
                        child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

class ParameterBottomSheet extends StatefulWidget {
  const ParameterBottomSheet({Key key}) : super(key: key);

  @override
  State<ParameterBottomSheet> createState() => _ParameterBottomSheetState();
}

class _ParameterBottomSheetState extends State<ParameterBottomSheet> {

  String segment = "all";
  String sorting = "atoz";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 625,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20))),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 1.5,
            width: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Utils.lightGreyColor.withOpacity(0.75)),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => closedHoldings()
                  )
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff0063f5).withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                child: Text(
                  "View Closed Holdings",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff0063f5),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Utils.lightGreyColor.withOpacity(0.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Filter by", style: Utils.fonts(fontWeight: FontWeight.w600, size: 21.0),),
                SizedBox(
                  height: 10,
                ),
                Text("SEGMENT", style: Utils.fonts(fontWeight: FontWeight.w500, size: 16.0),),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            value: "all", groupValue: segment, onChanged: (value){
                            setState(() {
                              segment = value.toString();
                            });
                          },),
                          Expanded(
                            child: Text('All',style: Utils.fonts(fontWeight: FontWeight.w400, size: 16.0),),
                          )
                        ],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            value: "cash", groupValue: segment, onChanged: (value){
                            setState(() {
                              segment = value.toString();
                            });
                          },),
                          Expanded(child: Text('Cash',style: Utils.fonts(fontWeight: FontWeight.w400, size: 16.0),))
                        ],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            value: "etf", groupValue: segment, onChanged: (value){
                            setState(() {
                              segment = value.toString();
                            });
                          },),
                          Expanded(child: Text('ETF',style: Utils.fonts(fontWeight: FontWeight.w400, size: 16.0),))
                        ],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      value: "bees", groupValue: segment, onChanged: (value){
                      setState(() {
                        segment = value.toString();
                      });
                    },),
                    Expanded(child: Text('Bees',style: Utils.fonts(fontWeight: FontWeight.w400, size: 16.0),))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Utils.lightGreyColor.withOpacity(0.2),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Sort by", style: Utils.fonts(fontWeight: FontWeight.w600, size: 21.0),),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Radio(
                      //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      value: "atoz", groupValue: sorting, onChanged: (value){
                      setState(() {
                        sorting = value.toString();
                      });
                    },),
                    Expanded(
                      child: Text('A - Z',style: Utils.fonts(fontWeight: FontWeight.w400, size: 16.0),),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Utils.lightGreyColor.withOpacity(0.2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      value: "ztoa", groupValue: sorting, onChanged: (value){
                      setState(() {
                        sorting = value.toString();
                      });
                    },),
                    Expanded(
                      child: Text('Z - A',style: Utils.fonts(fontWeight: FontWeight.w400, size: 16.0),),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Utils.lightGreyColor.withOpacity(0.2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      value: "CHGHighLow", groupValue: sorting, onChanged: (value){
                      setState(() {
                        sorting = value.toString();
                      });
                    },),
                    Expanded(
                      child: Text('CHG% High - Low',style: Utils.fonts(fontWeight: FontWeight.w400, size: 16.0),),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Utils.lightGreyColor.withOpacity(0.2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      value: "CHGLowHigh", groupValue: sorting, onChanged: (value){
                      setState(() {
                        sorting = value.toString();
                      });
                    },),
                    Expanded(
                      child: Text('CHG% Low - High',style: Utils.fonts(fontWeight: FontWeight.w400, size: 16.0),),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          primary: Colors.transparent,
                          side: BorderSide(color: Utils.lightGreyColor, width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text(
                            "Cancel",
                            style: Utils.fonts(
                                color: Utils.lightGreyColor,
                                size: 18.0,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Utils.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text(
                            "Done",
                            style: Utils.fonts(
                                color: Utils.whiteColor,
                                size: 18.0,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}




