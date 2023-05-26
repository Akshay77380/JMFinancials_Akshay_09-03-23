import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class PredefinedSelectorWatchlist extends StatefulWidget {
  var id;

  PredefinedSelectorWatchlist(this.id);

  @override
  State<PredefinedSelectorWatchlist> createState() => _PredefinedSelectorWatchlistState();
}

class _PredefinedSelectorWatchlistState extends State<PredefinedSelectorWatchlist>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  TabController _tabController;

  var searchedWord = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back)),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchedWord = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5.0),
                          filled: true,
                          fillColor: Color(0xFFFFFFFF),
                          prefixIcon: Icon(Icons.search,
                              color: Utils.greyColor.withOpacity(0.7)),
                          suffixIcon: Icon(
                            Icons.mic_none,
                            size: 20,
                            color: Utils.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          hintText: 'Search Sector / Indices',
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(
                    //             color: Utils.greyColor.withOpacity(0.5),
                    //             width: 1.0),
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(10.0))),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         children: [
                    //           SvgPicture.asset("assets/appImages/search.svg"),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Container(
                    //             height: 20,
                    //             color: Utils.greyColor,
                    //             width: 1.0,
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Text(
                    //             "Search Sector / Indices",
                    //             style: Utils.fonts(
                    //                 fontWeight: FontWeight.w300,
                    //                 color: Utils.greyColor),
                    //           ),
                    //           Spacer(),
                    //           Icon(
                    //             Icons.mic,
                    //             color: Utils.primaryColor,
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Cancel",
                      style: Utils.fonts(color: Utils.primaryColor, size: 13.0),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TabBar(
                  isScrollable: true,
                  labelStyle:
                      Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                  unselectedLabelStyle:
                      Utils.fonts(size: 12.0, fontWeight: FontWeight.w400),
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
                      child: Row(
                        children: [
                          Text(
                            "Exchange Indices",
                            style: Utils.fonts(
                              size: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Text(
                            "JM Financial Basket",
                            style: Utils.fonts(
                              size: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 2.0,
              width: MediaQuery.of(context).size.width,
              color: Utils.greyColor.withOpacity(0.2),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Popular Indices",
                    style: Utils.fonts(
                        size: 13.0, color: Utils.greyColor.withOpacity(0.5)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  for (var i = 0;
                      i <
                          Dataconstants
                              .indicesMarketWatchListener.watchList.length;
                      i++)
                    Dataconstants.indicesMarketWatchListener.watchList[i].name
                            .toString()
                            .toUpperCase()
                            .contains(searchedWord.toUpperCase())
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Dataconstants.indicesMarketWatchListener
                                            .watchList[i].name
                                            .toString(),
                                        style: Utils.fonts(
                                            size: 16.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        Dataconstants.indicesMarketWatchListener
                                            .watchList[i].exchName
                                            .toString(),
                                        style: Utils.fonts(
                                            size: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: Utils.greyColor
                                                .withOpacity(0.5)),
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Utils.greyColor.withOpacity(0.2),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 30.0,
                                          color: Utils.greyColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: 2.0,
                                width: MediaQuery.of(context).size.width,
                                color: Utils.greyColor.withOpacity(0.2),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                            ],
                          )
                        : SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
