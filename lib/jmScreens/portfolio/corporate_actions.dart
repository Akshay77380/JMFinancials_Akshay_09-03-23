import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'dividend_portfolio.dart';
class corporateActions extends StatefulWidget  {


  @override
  State<corporateActions> createState() => _corporateActionsState();



}

class _corporateActionsState extends State<corporateActions>with TickerProviderStateMixin  {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events",
        ),
        actions: <Widget>[
          SvgPicture.asset('assets/appImages/tranding.svg'),
          SizedBox(width: 10,)
        ],
        elevation: 0,
        bottom: TabBar(
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
          onTap: (_index) {},
          tabs: [
            Tab(
              child: Text("Dividend"),
            ),
            Tab(
              child: Text("Bonus"),
            ),
            Tab(
              child: Text("Rights"),
            ),
            Tab(
              child: Text("Splits"),
            ),
            Tab(
              child: Text("Board Meets"),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: TabBarView(
            physics: CustomTabBarScrollPhysics(),
            controller: _tabController,
            children: [
              dividendPortfolio(),
              dividendPortfolio(),
              dividendPortfolio(),
              dividendPortfolio(),
              dividendPortfolio(),
            ],
          ))
        ],
      ),
    );
  }
}
