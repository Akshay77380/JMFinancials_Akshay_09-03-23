import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/EventsBonusController.dart';
import '../../controllers/EventsDividendController.dart';
import '../../controllers/EventsRightsController.dart';
import '../../controllers/EventsSplitsController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  var eventsTab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events", style: Utils.fonts(
          color: Utils.blackColor,
          size: 20.0
        ),)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            eventsTab = 1;
                            setState(() {
                              Dataconstants.eventsDividendController.getEventsDividend();
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Dividend",
                                  style: Utils.fonts(size: 12.0, color: eventsTab == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            eventsTab = 2;
                            setState(() {
                              Dataconstants.eventsBonusController.getEventsBonus();
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Bonus",
                                  style: Utils.fonts(size: 12.0, color: eventsTab == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            eventsTab = 3;
                            setState(() {
                              Dataconstants.eventsRightsController.getEventsRights();
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Rights",
                                  style: Utils.fonts(size: 12.0, color: eventsTab == 3 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            eventsTab = 4;
                            Dataconstants.eventsSplitsController.getEventsSplits();
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Splits",
                                  style: Utils.fonts(size: 12.0, color: eventsTab == 4 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            eventsTab = 5;
                            setState(() {
                              Dataconstants.boardMeetController.getEventsBoardMeet();
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Board Meet",
                                  style: Utils.fonts(size: 12.0, color: eventsTab == 5 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            eventsTab = 6;
                            setState(() {});
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                      color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    top: BorderSide(
                                      color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    ),
                                    right: BorderSide(
                                      color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor,
                                      width: 1,
                                    )),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Earnings",
                                  style: Utils.fonts(size: 12.0, color: eventsTab == 6 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(children: [
                  //   Container(
                  //     width: MediaQuery.of(context).size.width * 0.3,
                  //     child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                  //   ),
                  //   mostActiveTab == 2
                  //       ? Container(width: MediaQuery.of(context).size.width * 0.3, child: Text("Value Traded(Cr)", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                  //       : mostActiveTab == 1
                  //           ? Container(
                  //               width: MediaQuery.of(context).size.width * 0.3,
                  //               child: Text("Ex-Date", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                  //           : mostActiveTab == 3 || mostActiveTab == 4 || mostActiveTab == 5
                  //               ? Container(
                  //                   width: MediaQuery.of(context).size.width * 0.3,
                  //                   child: Text("Traded Qty", textAlign: TextAlign.center, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                  //               : Container(
                  //                   width: MediaQuery.of(context).size.width * 0.3,
                  //                   child: Text("Volume", textAlign: TextAlign.center, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))),
                  //   mostActiveTab == 3 || mostActiveTab == 4 || mostActiveTab == 5
                  //       ? Container(width: MediaQuery.of(context).size.width * 0.3, child: Text("Turnover", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                  //       : Column(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             mostActiveTab == 1
                  //                 ? Container(
                  //                     width: MediaQuery.of(context).size.width * 0.3,
                  //                     child: Text("Dividend", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                  //                 : mostActiveTab == 2
                  //                     ? Container(
                  //                         width: MediaQuery.of(context).size.width * 0.3,
                  //                         child: Text("Bonus Ratio", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)))
                  //                     : Container(
                  //                         decoration: BoxDecoration(border: Border.all()),
                  //                         width: MediaQuery.of(context).size.width * 0.3,
                  //                         child: Text("LTP", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))),
                  //             mostActiveTab == 1
                  //                 ? SizedBox.shrink()
                  //                 : Container(
                  //                     width: MediaQuery.of(context).size.width * 0.3,
                  //                     child: Text("%Chg", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500))),
                  //           ],
                  //         ),
                  // ]),
                  // SizedBox(height: 10),
                  Obx(() {
                    return eventsTab == 1
                        ? EventsDividendController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : EventsDividendController.getEventsDividendListItems.isEmpty
                        ? Center(child: Text("No Data available"))
                        : Column(
                      children: [
                        Row(children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Ex-Date", textAlign: TextAlign.center, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Dividend", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                        ]),
                        Divider(thickness: 1),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                            EventsDividendController.getEventsDividendListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(
                                //     builder: (context) => ScriptInfo(
                                //         CommonFunction.getScripDataModel(
                                //             exch: EventsDividendController.getEventsDividendListItems[index]. == "BSE" ? "B" : "N",
                                //             exchCode: int.parse(TopGainersController.getTopGainersListItems[index].scCode.toString()
                                //             )))));
                              },
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: Text(EventsDividendController.getEventsDividendListItems[index].coName,
                                            style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: Text(EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0],
                                            textAlign: TextAlign.end, style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("${EventsDividendController.getEventsDividendListItems[index].divamt.toStringAsFixed(2)}",
                                                style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                            Text("/ share", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           Text("Ex Date", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                //
                                //         ],
                                //       ),
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.center,
                                //         children: [
                                //           Text("Record Date", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                //           Text(EventsDividendController.getEventsDividendListItems[index].tradeDate.toString().split(" ")[0],
                                //               style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                //         ],
                                //       ),
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.end,
                                //         children: [
                                //           Text("Div yield", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                                //           Text("-", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.grey[350],
                                ),
                              ]),
                            );
                          },
                        )
                      ],
                    )
                        : eventsTab == 2
                        ? EventsBonusController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : EventsBonusController.getEventsBonusListItems.isEmpty
                        ? Center(child: Text("No Data available"))
                        : Column(
                      children: [
                        Row(children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Ex-Date", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Bonus", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                        ]),
                        Divider(thickness: 1),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: EventsBonusController.getEventsBonusListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Container(
                              //           width: MediaQuery.of(context).size.width * 0.3,
                              //           child: Text(EventsBonusController.getEventsBonusListItems[index].symbol,
                              //               style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black))),
                              //       Container(
                              //         width: MediaQuery.of(context).size.width * 0.3,
                              //         child: Text(EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0],
                              //             style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                              //       ),
                              //       Container(
                              //         width: MediaQuery.of(context).size.width * 0.3,
                              //         child: Text(EventsBonusController.getEventsBonusListItems[index].bonusRatio,
                              //             style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text(EventsBonusController.getEventsBonusListItems[index].coName,
                                          style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text(EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0],
                                          textAlign: TextAlign.end, style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("${EventsBonusController.getEventsBonusListItems[index].bonusRatio}",
                                              style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           Text("Announcement Date", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                              //           Text(EventsBonusController.getEventsBonusListItems[index].announcementDate.toString().split(" ")[0],
                              //               style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                              //         ],
                              //       ),
                              //       Column(
                              //         crossAxisAlignment: CrossAxisAlignment.end,
                              //         children: [
                              //           Text("Ex Bonus", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.grey)),
                              //           Text(EventsBonusController.getEventsBonusListItems[index].bonusDate.toString().split(" ")[0],
                              //               style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Divider(
                                thickness: 2,
                                color: Colors.grey[350],
                              ),
                            ]);
                          },
                        )
                      ],
                    )
                        : eventsTab == 3
                        ? EventsRightsController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : EventsBonusController.getEventsBonusListItems.isEmpty
                        ? Center(child: Text("No Data available"))
                        : Column(
                      children: [
                        Row(children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Ex-Date", textAlign: TextAlign.center, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Rights", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                        ]),
                        Divider(thickness: 1),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: EventsRightsController.getEventsRightsListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text(EventsRightsController.getEventsRightsListItems[index].symbol,
                                          style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text(EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0],
                                          textAlign: TextAlign.end, style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("${EventsRightsController.getEventsRightsListItems[index].rightsRatio}",
                                              style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.grey[350],
                              ),
                            ]);
                          },
                        ),
                      ],
                    )
                        : eventsTab == 4
                        ? EventsSplitsController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : EventsSplitsController.getEventsSplitsListItems.isEmpty
                        ? Center(child: Text("No Data available"))
                        : Column(
                      children: [
                        Row(children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Symbol", style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Ex-Date", textAlign: TextAlign.center, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text("Splits", textAlign: TextAlign.end, style: Utils.fonts(size: 15.0, color: Utils.greyColor, fontWeight: FontWeight.w500)),
                          ),
                        ]),
                        Divider(thickness: 1),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: EventsSplitsController.getEventsSplitsListItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text(EventsSplitsController.getEventsSplitsListItems[index].coName,
                                          style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Text(EventsSplitsController.getEventsSplitsListItems[index].splitDate.toString().split(" ")[0],
                                          textAlign: TextAlign.end, style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(" ", style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0, color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.grey[350],
                              ),
                            ]);
                          },
                        )
                      ],
                    )
                        : Center(child: Text("No Data Available"));
                  })
                ],
              ),
            ),
            Container(
              height: 4.0,
              width: MediaQuery.of(context).size.width,
              color: Utils.greyColor.withOpacity(0.2),
            ),
          ],
        ),
      )
    );
  }
}
