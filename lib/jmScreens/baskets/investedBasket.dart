import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../model/jmModel/basket.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/search_bar_screen.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'add_more.dart';
import 'create_basket_second.dart';
import 'sell_basket.dart';

class investedBasket extends StatefulWidget {
  BasketDatum BasketList;

  investedBasket(this.BasketList);

  @override
  State<investedBasket> createState() => _investedBasketState();
}

class _investedBasketState extends State<investedBasket>
    with TickerProviderStateMixin {
  TabController _tabController;

  List<ScripInfoModel> stockArray = [];
  var list;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    try {
      list = jsonDecode(widget.BasketList.basketScrips);
      //print(list);
      // stockArray = jsons;
    } catch (e) {
      //print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.,
          children: [
            Text(
              "IT Basket",
              style: Utils.fonts(color: Utils.blackColor, size: 15.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => createBasketSecond(),
                        ),
                      );
                    },
                    child:
                        SvgPicture.asset('assets/appImages/basket/edit.svg')),
              ]),
            )
          ],
        ),
        actions: [
          SvgPicture.asset("assets/appImages/basket/tranding.svg"),
          SizedBox(
            width: 20,
          )
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
                    Utils.fonts(size: 13.0, fontWeight: FontWeight.w700),
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
                  indicatorColor: Utils.primaryColor.withOpacity(0.1),
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                controller: _tabController,
                onTap: (_index) {},
                tabs: [
                  Tab(
                    child: Text("Overview"),
                  ),
                  Tab(
                    child: Text("Analysis"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Card(
        elevation: 20.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        margin: EdgeInsets.zero,
        color: Utils.whiteColor,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => sellBasket(),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 35.0),
                      child: Text(
                        "Sell",
                        style: Utils.fonts(
                            size: 14.0,
                            color: Utils.greyColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side:
                                        BorderSide(color: Utils.greyColor))))),
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => buyOrder(),
                        ),
                      );
                      Navigator.pop(context);
                      // replaceWatchList();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        "Add More",
                        style: Utils.fonts(
                            size: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Utils.primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )))),
                Spacer(),
              ],
            )

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => sellBasket(),
            //           ),
            //         );
            //       },
            //       child: Container(
            //         height: 40,
            //         width: 130,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(60),
            //           border: Border.all(color: Colors.grey),
            //           color: Colors.white,
            //         ),
            //         child: Center(
            //             child: Text("Sell",
            //                 style: Utils.fonts(
            //                     fontWeight: FontWeight.w600,
            //                     size: 13.0,
            //                     color: Colors.black))),
            //       ),
            //     ),
            //     InkWell(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => buyOrder(),
            //           ),
            //         );
            //       },
            //       child: Container(
            //         height: 40,
            //         width: 130,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(60),
            //           color: Colors.blueAccent.withOpacity(0.9),
            //         ),
            //         //
            //         child: Center(
            //             child: Text(
            //           "Add More",
            //           style: Utils.fonts(
            //               fontWeight: FontWeight.w600,
            //               size: 13.0,
            //               color: Colors.white),
            //         )),
            //       ),
            //     ),
            //   ],
            // ),
            ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Utils.primaryColor.withOpacity(0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Current Value",
                          style: Utils.fonts(
                              size: 13.0, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "4,555.50",
                          style: Utils.fonts(
                            size: 14.0,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Unrealised P/L",
                          style: Utils.fonts(
                            size: 13.0,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "1,25,645.00",
                          style: Utils.fonts(
                              size: 14.0, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Utils.containerColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: TextField(
                      onTap: () {
                        Dataconstants.isComingFromMarginCalculator = true;
                        Dataconstants.searchModel = null;
                        showSearch(
                          context: context,
                          delegate: SearchBarScreen(0),
                        ).then((value) {
                          stockArray.add(Dataconstants.searchModel);
                          setState(() {});
                        });
                      },
                      textAlign: TextAlign.start,
                      style: Utils.fonts(
                          color: Utils.blackColor,
                          fontWeight: FontWeight.w500,
                          size: 15.0),
                      decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          hintText: "Add Scrips",
                          hintStyle: Utils.fonts(
                              color: Utils.greyColor,
                              fontWeight: FontWeight.w500,
                              size: 15.0),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Utils.greyColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Symbol",
                      style: Utils.fonts(
                          size: 12.0, color: Utils.greyColor.withOpacity(0.7)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Value",
                      style: Utils.fonts(
                          size: 11.0, color: Utils.greyColor.withOpacity(0.7)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "P/L",
                        style: Utils.fonts(
                            size: 12.0,
                            color: Utils.greyColor.withOpacity(0.7)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "LTP",
                        style: Utils.fonts(
                            size: 11.0,
                            color: Utils.greyColor.withOpacity(0.7)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Qty",
                        style: Utils.fonts(
                            size: 12.0,
                            color: Utils.greyColor.withOpacity(0.7)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Avg Price",
                        style: Utils.fonts(
                            size: 11.0,
                            color: Utils.greyColor.withOpacity(0.7)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                  itemCount: stockArray.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stockArray[index].name,
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w600,
                                      size: 13.0,
                                      color: Utils.blackColor),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "27,560.20",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 12.0,
                                      color: Utils.greyColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "-18,908.90",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w600,
                                      size: 13.0,
                                      color: Utils.brightRedColor),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "150.60",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 12.0,
                                      color: Utils.greyColor),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "1500",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w600,
                                      size: 13.0,
                                      color: Utils.blackColor),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "379.00",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 12.0,
                                      color: Utils.greyColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Divider()
                      ]),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
