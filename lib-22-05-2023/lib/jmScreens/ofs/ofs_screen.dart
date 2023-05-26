import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'ofs_open_issues.dart';
import 'ofs_order_book.dart';

class OFSScreen extends StatefulWidget {

  @override
  State<OFSScreen> createState() => _OFSScreenState();
}

class _OFSScreenState extends State<OFSScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });
    super.initState();
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
      appBar: AppBar(
        backgroundColor: Utils.whiteColor,
        leadingWidth: 30,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Utils.greyColor,
            ),
          ),
        ),
        title: Text(
          "OFS",
          style: Utils.fonts(
              size: 18.0,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyText1.color),
        ),
        elevation: 0,
        actions: [
          Icon(
            Icons.more_vert,
            color: Utils.greyColor,
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
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 0,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 30.0,
                  insets: EdgeInsets.symmetric(horizontal: 2),
                  indicatorColor: Utils.primaryColor.withOpacity(0.3),
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                controller: _tabController,
                tabs: [
                  Tab(
                    child: const Text(
                      'Open Issues',
                    ),
                  ),
                  Tab(
                    child: const Text(
                      'Order Book',
                    ),
                  ),
                ],
                onTap: (value) {
                  setState(() {
                    _currentIndex = value;
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        physics: CustomTabBarScrollPhysics(),
        controller: _tabController,
        children: [
          OFSOpenIssues(),
          OFSOrderBook(),
        ],
      ),
    );
  }
}
