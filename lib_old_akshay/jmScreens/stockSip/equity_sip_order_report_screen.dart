import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/stock_sip/get_sip_listController.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'EquitySipScreen.dart';
import 'active_sip_order_report.dart';
import 'equity_sip_order_screen.dart';
import 'expired_Sip_order.dart';
import 'pause_sip_order_report.dart';

class EquitySipOrderReportScreen extends StatefulWidget {
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
    Dataconstants.getSipListController.fetchGetSipListData();
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
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
        backgroundColor:  theme.appBarTheme.backgroundColor,
        title: Text(
          "My Equity SIP's",
          style: TextStyle(color: theme.textTheme.bodyText1.color, fontSize: 18,fontWeight: FontWeight.w600),
        ),
        elevation: 1,
        // leadingWidth: 25.0,
        leading: InkWell(
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return EquitySipScreen();
            //     },
            //   ),
            // );
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Utils.greyColor,
            // size: 1,
          ),
        ),
        // actions: [
        //   SvgPicture.asset('assets/appImages/tranding.svg'),
        //   SizedBox(
        //     width: 10,
        //   ),
        //   Icon(
        //     Icons.more_vert,
        //     color: Utils.greyColor,
        //   ),
        //   SizedBox(
        //     width: 10,
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 65,
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  isScrollable: true,
                  labelStyle:
                  TextStyle( fontSize: 14,fontWeight: FontWeight.w600),
                  unselectedLabelStyle:
                  TextStyle( fontSize: 12,fontWeight: FontWeight.w300),
                  unselectedLabelColor: Colors.grey[600],
                  labelColor:ThemeConstants.themeMode.value == ThemeMode.dark?Color(0xFF7989FE): theme.primaryColor,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 0,
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 45.0,
                    indicatorColor: theme.primaryColor.withOpacity(0.3),
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
                            Obx(() {
                              return GetSipListController.isLoading.value
                                  ? SizedBox.shrink()
                                  : Visibility(
                                visible: GetSipListController.isLoading.value == true ? false : true,
                                child: CircleAvatar(
                                  backgroundColor:_currentIndex == 0
                                      ? theme.primaryColor
                                      : Colors.grey,// _tabController.index == 1 ? theme.primaryColor : Colors.grey,
                                  foregroundColor: Colors.white,
                                  maxRadius: 11,
                                  child: Text('${GetSipListController.ActiveSipListData.length}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              );
                            })
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

                            Obx(() {
                              return GetSipListController.isLoading.value
                                  ? SizedBox.shrink()
                                  : Visibility(
                                visible: GetSipListController.isLoading.value == true ? false : true,
                                child: CircleAvatar(
                                  backgroundColor:_currentIndex == 1
                                      ? theme.primaryColor
                                      : Colors.grey,// _tabController.index == 1 ? theme.primaryColor : Colors.grey,
                                  foregroundColor: Colors.white,
                                  maxRadius: 11,
                                  child: Text('${GetSipListController.PauseSipListData.length}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              );
                            })

                            // CircleAvatar(
                            //     backgroundColor: _currentIndex == 1
                            //         ? theme.primaryColor
                            //         : Colors.grey,
                            //     foregroundColor: Utils.whiteColor,
                            //     maxRadius: 11,
                            //     child: Text('2'))
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

                            Obx(() {
                              return GetSipListController.isLoading.value
                                  ? SizedBox.shrink()
                                  : Visibility(
                                visible: GetSipListController.isLoading.value == true ? false : true,
                                child: CircleAvatar(
                                  backgroundColor:_currentIndex == 2
                                      ? theme.primaryColor
                                      : Colors.grey,// _tabController.index == 1 ? theme.primaryColor : Colors.grey,
                                  foregroundColor: Colors.white,
                                  maxRadius: 11,
                                  child: Text('${GetSipListController.ExpiredSipListData.length}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              );
                            })

                            // CircleAvatar(
                            //     backgroundColor: _currentIndex == 0
                            //         ? theme.primaryColor
                            //         : Colors.grey,
                            //     foregroundColor: Utils.whiteColor,
                            //     maxRadius: 11,
                            //     child: Text(items.length.toString())
                            // )

                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 120,
                    //   child: Tab(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         const Text(
                    //           'Mandate',
                    //         ),
                    //         const SizedBox(width: 10),
                    //         CircleAvatar(
                    //             backgroundColor: _currentIndex == 1
                    //                 ? theme.primaryColor
                    //                 : Colors.grey,
                    //             foregroundColor: Utils.whiteColor,
                    //             maxRadius: 11,
                    //             child: Text('2'))
                    //         // Obx(() {
                    //         //   return tabBar
                    //         //       ? SizedBox.shrink()
                    //         //       : Visibility(
                    //         //     visible:
                    //         //     tabBar == true
                    //         //         ? false
                    //         //         : true,
                    //         //     child: CircleAvatar(
                    //         //       backgroundColor: _tabController.index == 0
                    //         //           ? theme.primaryColor
                    //         //           : Colors.grey,
                    //         //       foregroundColor: Colors.white,
                    //         //       maxRadius: 11,
                    //         //       child: Text('2',
                    //         //         style: const TextStyle(fontSize: 12),
                    //         //       ),
                    //         //     ),
                    //         //   );
                    //         // })
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EquitySipOrderScreen(isModify:false,
                    isClone:false,),
            ),
          );
        },
      ),
      body: TabBarView(
        physics: CustomTabBarScrollPhysics(),
        controller: _tabController,
        children: [
          ActiveSipOrderReport(),
          PauseSipOrderReport(),
          ExpiredSiporderScreen(),
          // SingleChildScrollView(
          //     child: Tiles(4)
          // ),
        ],
      ),
    );
  }

  Widget Tiles(int count) {
    var theme = Theme.of(context);
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
                                style:TextStyle( fontSize: 15,fontWeight: FontWeight.w700))
                          ],
                        ),
                        SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                            text: 'ID:12121545',
                            style:TextStyle(color: Colors.grey, fontSize: 14,),
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
                            style: TextStyle( fontSize: 15,fontWeight: FontWeight.w700)),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Approved",
                                style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500),),
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
                                style: TextStyle( fontSize: 15,fontWeight: FontWeight.w700))
                          ],
                        ),
                        SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                            text: 'ID:12121545',
                            style: TextStyle(color: Colors.grey, fontSize: 14,),
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
                            style: TextStyle( fontSize: 15,fontWeight: FontWeight.w700)),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Utils.greyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("In Process",
                                style: TextStyle(color: Colors.grey.withOpacity(0.2), fontWeight: FontWeight.w500),),
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
                                style: TextStyle( fontSize: 15,fontWeight: FontWeight.w700),)
                          ],
                        ),
                        SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                            text: 'ID:12121545',
                            style:TextStyle(color: Colors.grey, fontSize: 15,fontWeight: FontWeight.w700),
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
                            style:TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Rejected",
                                style: TextStyle(
                                    color: Colors.redAccent.withOpacity(0.9),
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
                                style:TextStyle(fontSize: 15,fontWeight: FontWeight.w700))
                          ],
                        ),
                        SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                            text: 'ID:12121545',
                            style: TextStyle(
                                fontSize: 14.0, color: Utils.greyColor),
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
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Success",
                                style: TextStyle(
                                    color: theme.primaryColor.withOpacity(0.9),
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
                style: TextStyle(color: Utils.greyColor),
              ),
            )
          ],
        ),
      ],
    );
  }
}
