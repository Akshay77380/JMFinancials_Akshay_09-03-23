import 'dart:async';
import 'package:flutter/material.dart';
import 'package:markets/style/theme.dart';
import 'package:markets/util/Dataconstants.dart';
import 'package:markets/widget/custom_tab_bar.dart';
import 'all_research_screen.dart';
import 'commodity_research_screen.dart';
import 'currency_research_screen.dart';
import 'future_option_research_screen.dart';
import 'investment_research_screen.dart';
import 'trading_research_screen.dart';

class ResearchScreen extends StatefulWidget {
  const ResearchScreen({Key key, int index}) : super(key: key);

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Dataconstants.researchTabController = TabController(vsync: this, length: 6);
    // if (Dataconstants.isEquity == 1) {
    //   Dataconstants.researchTabController.animateTo(4);
    //   setState(() {
    //     Dataconstants.isEquity = 0;
    //   });
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: theme.appBarTheme.color,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            setState(() {
              Dataconstants.isFromToolsToResearch = false;
            });
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Research",
          style: TextStyle(color: theme.textTheme.bodyText1.color),
        ),
      ),
      body: Column(
        children: [

          Container(
            decoration: BoxDecoration(
                color: theme.appBarTheme.color, border: Border(bottom: BorderSide(width: 1, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xffe0e0e0) : Color(0xff292B38)))),
            width: width,
            child: TabBar(
              physics: CustomTabBarScrollPhysics(),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              unselectedLabelColor: Colors.grey[600],
              labelColor: theme.textTheme.bodyText1.color,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: theme.primaryColor,
              controller: Dataconstants.researchTabController,
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text(
                    'All',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Trading',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Investment',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Future & Option',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Currency',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Commodity',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: CustomTabBarScrollPhysics(),
              controller: Dataconstants.researchTabController,
              children: [
                AllResearchScreen(
                  tabController: Dataconstants.researchTabController,
                ),
                TradingResearchScreen(),
                InvestmentResearchScreen(),
                FutureOptionResearchScreen(),
                CurrencyResearchScreen(),
                CommodityResearchScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
