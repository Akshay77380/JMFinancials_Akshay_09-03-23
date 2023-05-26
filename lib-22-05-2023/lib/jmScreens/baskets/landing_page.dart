import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'created_tab.dart';
import 'invested_tab.dart';

class landingPage extends StatefulWidget {
  @override
  State<landingPage> createState() => _landingPageState();
}

class _landingPageState extends State<landingPage>
    with TickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
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
          automaticallyImplyLeading: true,
          title: Text(
            "Baskets",
            style: Utils.fonts(
                size: 18.0,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.bodyText1.color),
          ),
          elevation: 0,
          actions: [
            InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus.unfocus();
                  CommonFunction.marketWatchBottomSheet(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => landingPage()
                  //     )
                  // );
                },
                child: Center(
                    child: SvgPicture.asset('assets/appImages/tranding.svg')
                )
            ),
            SizedBox(
              width: 10,
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
                    indicatorColor: Utils.primaryColor.withOpacity(0.1),
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  controller: _tabController,
                  onTap: (_index) {},
                  tabs: [
                    Tab(
                      child: Text("Invested"),
                    ),
                    Tab(
                      child: Text("Created"),
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
                investedTab(),
                CreatedTab(),
              ],
            ),
          )
        ],
      ),
    );
  }
}