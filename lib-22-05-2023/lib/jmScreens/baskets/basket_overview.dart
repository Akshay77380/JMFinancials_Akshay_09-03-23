import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import '../../widget/slider_button.dart';
import 'add_more.dart';
import 'create_basket_second.dart';
import 'sell_basket.dart';

class basketOverview extends StatefulWidget {
  var globalArray;
  bool buttons = false;

  basketOverview(this.globalArray, this.buttons);

  @override
  State<basketOverview> createState() => _basketOverviewState();
}

class _basketOverviewState extends State<basketOverview>
    with TickerProviderStateMixin {
  TabController _tabController;

  var stockList = [];

  @override
  void initState() {
    var jsons = jsonDecode(widget.globalArray.basketScrips);
    for (var i = 0; i < jsons.length; i++) {
      var model = CommonFunction.getScripDataModel(
        exch: jsons[i]["exch"],
        exchCode: int.parse(jsons[i]["exchCode"]),
        sendReq: true,
      );
      stockList.add([jsons[i]["name"], jsons[i]["weight"], model]);
    }
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Text(
              widget.globalArray.basketName,
              style: Utils.fonts(
                  size: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Utils.blackColor),
            ),
            SizedBox(
              width: 10,
            ),
            SvgPicture.asset("assets/appImages/edit.svg"),
            SizedBox(
              width: 10,
            ),
            SvgPicture.asset("assets/appImages/delete.svg"),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => createBasketSecond(),
                    ),
                  );
                },
                child: SvgPicture.asset('assets/appImages/basket/edit.svg')),
            InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      builder: (builder) {
                        return new Container(
                          height: 500.0,
                          color: Colors.transparent,
                          //could change this to Color(0xFF737373),
                          //so you don't have to change MaterialApp canvasColor
                          child: new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      topRight: const Radius.circular(10.0))),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 30,
                                          height: 2,
                                          color: Utils.greyColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: SvgPicture.asset(
                                          "assets/appImages/basket/deleteWatchlist.svg",
                                          width: 200,
                                          height: 200,
                                        ),
                                      ),
                                      Text(
                                        "Delete IT Basket",
                                        style: Utils.fonts(
                                            size: 20.0,
                                            color: Utils.blackColor),
                                      ),
                                      // Text(
                                      //   // "Delete ${DataConstants.marketWatchListeners[index].watchListName.toString()}",
                                      //   style: Utils.fonts(size: 18.0),
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Are you sure want to delete this Basket?",
                                        style: Utils.fonts(
                                            size: 12.0,
                                            color: Utils.greyColor
                                                .withOpacity(0.5)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             AddMoney("0", "Limits", "withdraw")));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15.0,
                                                        horizontal: 20.0),
                                                child: Text(
                                                  "Cancel",
                                                  style: Utils.fonts(
                                                      size: 14.0,
                                                      color: Utils.greyColor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  50.0),
                                                          side: BorderSide(
                                                              color: Utils
                                                                  .greyColor))))),
                                          ElevatedButton(
                                              onPressed: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             AddMoney("0", "Limits", "add")));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15.0,
                                                        horizontal: 20.0),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        "assets/appImages/basket/deleteWhite.svg"),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Delete",
                                                      style: Utils.fonts(
                                                          size: 14.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Utils.lightRedColor),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                  )))),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        );
                      });
                },
                child: SvgPicture.asset('assets/appImages/basket/delete.svg'))
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Utils.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Current Value",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w700, size: 13.0),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "15,43,657",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w700, size: 15.0),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Unrealised P/L",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w700, size: 13.0),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "15,43,657",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w700,
                                size: 15.0,
                                color: Utils.brightGreenColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: InkWell(
                onTap: (){

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Utils.containerColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextField(
                                enabled: false,
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
                            Expanded(
                              child: Text(
                                "${stockList.length}/20",
                                style: Utils.fonts(
                                    size: 15.0,
                                    color: Utils.greyColor.withOpacity(0.7)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 2,
              color: Utils.greyColor.withOpacity(0.2),
            ),
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Scrips",
            //         style: Utils.fonts(
            //             fontWeight: FontWeight.w500,
            //             size: 13.0,
            //             color: Utils.greyColor),
            //       ),
            //       Text(
            //         "Weightage",
            //         style: Utils.fonts(
            //             fontWeight: FontWeight.w500,
            //             size: 13.0,
            //             color: Utils.greyColor),
            //       ),
            //       Text(
            //         "LTP",
            //         style: Utils.fonts(
            //             fontWeight: FontWeight.w500,
            //             size: 13.0,
            //             color: Utils.greyColor),
            //       )
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Divider(
            //     thickness: 1,
            //     color: Utils.greyColor.withOpacity(0.2),
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: MediaQuery.of(context).size.height - 360,
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text(
                        "Scrips",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 13.0,
                            color: Utils.greyColor),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "Weightage",
                          textAlign: TextAlign.center,
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 13.0,
                              color: Utils.greyColor),
                        ),
                      ),
                    ),
                    DataColumn(
                        label: Expanded(
                      child: Text(
                        "LTP",
                        textAlign: TextAlign.end,
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 13.0,
                            color: Utils.greyColor),
                      ),
                    )),
                  ],
                  rows: <DataRow>[
                    for (var i = 0; i < stockList.length; i++)
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              stockList[i][0].toString(),
                              style: Utils.fonts(
                                  size: 13.0,
                                  fontWeight: FontWeight.w700,
                                  color: Utils.blackColor),
                            ),
                          ),
                          DataCell(
                            Expanded(
                              child: Center(
                                child: Text(
                                  "${stockList[i][1].toString()}%",
                                  textAlign: TextAlign.center,
                                  style: Utils.fonts(
                                      size: 13.0,
                                      fontWeight: FontWeight.w700,
                                      color: Utils.blackColor),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Observer(builder: (context) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    stockList[i][2].close.toStringAsFixed(2),
                                    textAlign: TextAlign.end,
                                    style: Utils.fonts(
                                        size: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: Utils.blackColor
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                  ],
                ),

                // ListView.builder(
                //     itemCount: stockList.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return Column(
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.symmetric(vertical: 8),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Container(
                //                   child: Text(
                //                     stockList[index][0].toString(),
                //                     style: Utils.fonts(
                //                         size: 13.0,
                //                         fontWeight: FontWeight.w700,
                //                         color: Utils.blackColor),
                //                   ),
                //                 ),
                //                 Container(
                //                   child: Text(
                //                     "${stockList[index][1].toString()}%",
                //                     style: Utils.fonts(
                //                         size: 13.0,
                //                         fontWeight: FontWeight.w700,
                //                         color: Utils.blackColor),
                //                   ), //widget.globalarray[index]["basket_name"]
                //                 ),
                //                 Container(
                //                   child: Text(
                //                     stockList[index][2].close.toStringAsFixed(2),
                //                     style: Utils.fonts(
                //                         size: 13.0,
                //                         fontWeight: FontWeight.w600,
                //                         color: Utils.blackColor),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Divider(
                //             thickness: 1,
                //             color: Utils.greyColor.withOpacity(0.2),
                //           )
                //         ],
                //       );
                //     }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.buttons
          ? displayButtons(context)
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SliderButton(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.80,
                text: 'SWIPE TO BUY',
                textStyle: Utils.fonts(size: 18.0, color: Utils.whiteColor),
                backgroundColor: Utils.brightGreenColor,
                foregroundColor: Utils.whiteColor,
                iconColor: Utils.brightGreenColor,
                icon: Icons.double_arrow,
                shimmer: false,
                onConfirmation: () async {
                  setState(() {
                    widget.buttons = !widget.buttons;
                  });
                },
              ),
            ),
    );
  }
}

Widget displayButtons(BuildContext context) {
  return Card(
    color: Utils.whiteColor,
    elevation: 10,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15.0),
      topRight: Radius.circular(15.0),
    )),
    // color: Colors.yellow,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => sellBasket(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Utils.darkRedColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 12.0),
                child: Text("EXIT",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w600,
                        size: 13.0,
                        color: Colors.white)),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => buyOrder(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Utils.darkGreenColor,
              ),
              //
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Text(
                  "ADD MORE",
                  style: Utils.fonts(
                      fontWeight: FontWeight.w600,
                      size: 13.0,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
