import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markets/jmScreens/equitySIP/expiry_sip_order_report.dart';
import 'package:markets/model/scrip_info_model.dart';
import 'package:markets/util/DataConstants.dart';
import '../../style/theme.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'active_sip_order_report.dart';
import 'pause_sip_order_report.dart';

class EquitySipOrderReportScreen extends StatefulWidget
{
  final ScripInfoModel model;
  const EquitySipOrderReportScreen({Key key, this.model}) : super(key: key);

  @override
  State<EquitySipOrderReportScreen> createState() => _EquitySipScreenState();
}

class _EquitySipScreenState extends State<EquitySipOrderReportScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool tabBar = false;
  int _currentIndex = 0;

  var items = [1,2,3,4];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.whiteColor,
        title: Text(
          "My Equity SIPs",
          style: Utils.fonts(
              size: 18.0,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyText1.color),
        ),
        elevation: 1,
        // leadingWidth: 25.0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Utils.greyColor,
            // size: 1,
          ),
        ),
        actions: [
          SvgPicture.asset('assets/appImages/tranding.svg'),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.more_vert,
            color: Utils.greyColor,
          ),
          SizedBox(
            width: 10,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(170.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 170,
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  isScrollable: true,
                  labelStyle:
                      Utils.fonts(size: 14.0, fontWeight: FontWeight.w600),
                  unselectedLabelStyle:
                      Utils.fonts(size: 12.0, fontWeight: FontWeight.w300),
                  unselectedLabelColor: Colors.grey[600],
                  labelColor: Utils.primaryColor,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 0,
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 45.0,
                    indicatorColor: Utils.primaryColor.withOpacity(0.3),
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  controller: _tabController,
                  tabs: [
                    SizedBox(
                      width: 120,
                      child: Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Active',
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                                backgroundColor: _currentIndex == 0
                                    ? Utils.primaryColor
                                    : Utils.greyColor,
                                foregroundColor: Utils.whiteColor,
                                maxRadius: 11,
                                child: Text('2'))
                            // Obx(() {
                            //   return tabBar
                            //       ? SizedBox.shrink()
                            //       : Visibility(
                            //     visible:
                            //     tabBar == true
                            //         ? false
                            //         : true,
                            //     child: CircleAvatar(
                            //       backgroundColor: _tabController.index == 0
                            //           ? theme.primaryColor
                            //           : Colors.grey,
                            //       foregroundColor: Colors.white,
                            //       maxRadius: 11,
                            //       child: Text('2',
                            //         style: const TextStyle(fontSize: 12),
                            //       ),
                            //     ),
                            //   );
                            // })
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Pause',
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                                backgroundColor: _currentIndex == 1
                                    ? Utils.primaryColor
                                    : Utils.greyColor,
                                foregroundColor: Utils.whiteColor,
                                maxRadius: 11,
                                child: Text('2'))
                            // Obx(() {
                            //   return tabBar
                            //       ? SizedBox.shrink()
                            //       : Visibility(
                            //     visible:
                            //     tabBar == true
                            //         ? false
                            //         : true,
                            //     child: CircleAvatar(
                            //       backgroundColor: _tabController.index == 0
                            //           ? theme.primaryColor
                            //           : Colors.grey,
                            //       foregroundColor: Colors.white,
                            //       maxRadius: 11,
                            //       child: Text('2',
                            //         style: const TextStyle(fontSize: 12),
                            //       ),
                            //     ),
                            //   );
                            // })
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Expired',
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                                backgroundColor: _currentIndex == 0
                                    ? Utils.primaryColor
                                    : Utils.greyColor,
                                foregroundColor: Utils.whiteColor,
                                maxRadius: 11,
                                child: Text(items.length.toString())
                            )
                            // Obx(() {
                            //   return tabBar
                            //       ? SizedBox.shrink()
                            //       : Visibility(
                            //     visible:
                            //     tabBar == true
                            //         ? false
                            //         : true,
                            //     child: CircleAvatar(
                            //       backgroundColor: _tabController.index == 0
                            //           ? theme.primaryColor
                            //           : Colors.grey,
                            //       foregroundColor: Colors.white,
                            //       maxRadius: 11,
                            //       child: Text('2',
                            //         style: const TextStyle(fontSize: 12),
                            //       ),
                            //     ),
                            //   );
                            // })
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Mandate',
                            ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                                backgroundColor: _currentIndex == 1
                                    ? Utils.primaryColor
                                    : Utils.greyColor,
                                foregroundColor: Utils.whiteColor,
                                maxRadius: 11,
                                child: Text('2'))
                            // Obx(() {
                            //   return tabBar
                            //       ? SizedBox.shrink()
                            //       : Visibility(
                            //     visible:
                            //     tabBar == true
                            //         ? false
                            //         : true,
                            //     child: CircleAvatar(
                            //       backgroundColor: _tabController.index == 0
                            //           ? theme.primaryColor
                            //           : Colors.grey,
                            //       foregroundColor: Colors.white,
                            //       maxRadius: 11,
                            //       child: Text('2',
                            //         style: const TextStyle(fontSize: 12),
                            //       ),
                            //     ),
                            //   );
                            // })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Utils.greyColor.withOpacity(0.1),
                  ),
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Search Scrip',
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: SvgPicture.asset(
                                'assets/appImages/searchSmall.svg',
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ),
                            ),
                            suffixIcon: SvgPicture.asset(
                              'assets/appImages/voiceSearchGrey.svg',
                            ),
                            labelStyle: Utils.fonts(
                                size: 14.0, fontWeight: FontWeight.w600),
                            hintStyle: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w600,
                                color: Utils.greyColor),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.sort_rounded),
                      //   onPressed: () {
                      //     FocusManager.instance.primaryFocus.unfocus();
                      //     showModalBottomSheet<void>(
                      //       isScrollControlled: true,
                      //       context: context,
                      //       builder: (BuildContext context) =>
                      //           PendingOrdersFilter(DataConstants.orderReportModel
                      //               .getPendingFilterMap()),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT',
                          style: Utils.fonts(
                              size: 12.0, fontWeight: FontWeight.w500),
                        ),
                        Text('6,50,325.5',
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w600
                            )
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('OVERALL P/L',
                            style: Utils.fonts(
                                size: 12.0, fontWeight: FontWeight.w500)),
                        Text('50,325.5',
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w600,
                                color: ThemeConstants.buyColor))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        physics: CustomTabBarScrollPhysics(),
        controller: _tabController,
        children: [
          ActiveSipOrderReport(),
          PauseSipOrderReport(),
          ExpirySipOrderReport(),
          SingleChildScrollView(
              child: Tiles(4)
          ),
        ],
      ),
    );
  }

  Widget Tiles(int count) {
    return Column(
      children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                height:  MediaQuery.of(context).size.width * 0.060,
                                width: MediaQuery.of(context).size.width * 0.060,
                                child: Image.asset("assets/appImages/icici.png",),
                              ),
                            ),
                            Text("ICICI Bank",
                                style: Utils.fonts(
                                    size: 15.0,
                                    fontWeight: FontWeight.w700
                                ))
                          ],
                        ),
                        SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                            text: 'ID:12121545',
                            style: Utils.fonts(
                                size: 14.0, color: Utils.greyColor),
                            children: const <TextSpan>[
                              TextSpan(text: ' 12 Aug 2022')
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("5000",
                            style: Utils.fonts(
                                size: 15.0, fontWeight: FontWeight.w700)),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Utils.brightGreenColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Approved",
                                style: Utils.fonts(
                                    color: Utils.lightGreenColor,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Divider(thickness: 2,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                height:  MediaQuery.of(context).size.width * 0.060,
                                width: MediaQuery.of(context).size.width * 0.060,
                                child: Image.asset("assets/appImages/hdfc.png",),
                              ),
                            ),
                            Text("HDFC Bank",
                                style: Utils.fonts(
                                    size: 15.0,
                                    fontWeight: FontWeight.w700
                                ))
                          ],
                        ),
                        SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                            text: 'ID:12121545',
                            style: Utils.fonts(
                                size: 14.0, color: Utils.greyColor),
                            children: const <TextSpan>[
                              TextSpan(text: ' 12 Aug 2022')
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("1,50,000",
                            style: Utils.fonts(
                                size: 15.0, fontWeight: FontWeight.w700)),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Utils.greyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("In Process",
                                style: Utils.fonts(
                                    color: Utils.greyColor.withOpacity(0.9),
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(thickness: 2,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                height:  MediaQuery.of(context).size.width * 0.060,
                                width: MediaQuery.of(context).size.width * 0.060,
                                child: Image.asset("assets/appImages/kotak.png",),
                              ),
                            ),
                            Text("Kotak Bank",
                                style: Utils.fonts(
                                    size: 15.0,
                                    fontWeight: FontWeight.w700
                                ))
                          ],
                        ),
                        SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                            text: 'ID:12121545',
                            style: Utils.fonts(
                                size: 14.0, color: Utils.greyColor),
                            children: const <TextSpan>[
                              TextSpan(text: ' 12 Aug 2022')
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("1,50,000",
                            style: Utils.fonts(
                                size: 15.0, fontWeight: FontWeight.w700)),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Utils.brightRedColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Rejected",
                                style: Utils.fonts(
                                    color: Utils.brightRedColor.withOpacity(0.9),
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(thickness: 2,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                height:  MediaQuery.of(context).size.width * 0.060,
                                width: MediaQuery.of(context).size.width * 0.060,
                                child: Image.asset("assets/appImages/icici.png",),
                              ),
                            ),
                            Text("HDFC Bank",
                                style: Utils.fonts(
                                    size: 15.0,
                                    fontWeight: FontWeight.w700
                                ))
                          ],
                        ),
                        SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                            text: 'ID:12121545',
                            style: Utils.fonts(
                                size: 14.0, color: Utils.greyColor),
                            children: const <TextSpan>[
                              TextSpan(text: ' 12 Aug 2022')
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("1,50,000",
                            style: Utils.fonts(
                                size: 15.0, fontWeight: FontWeight.w700)),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Utils.primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Success",
                                style: Utils.fonts(
                                    color: Utils.primaryColor.withOpacity(0.9),
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height:  MediaQuery.of(context).size.width * 0.060,
                width: MediaQuery.of(context).size.width * 0.060,
                child: Image.asset("assets/appImages/bellSmall.png",),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "This is all we have for you today",
                style: Utils.fonts(color: Utils.greyColor),
              ),
            )
          ],
        ),
      ],
    );
  }
}
