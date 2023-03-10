import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/EventsBoardMeetController.dart';
import '../../controllers/EventsBonusController.dart';
import '../../controllers/EventsDividendController.dart';
import '../../controllers/EventsRightsController.dart';
import '../../controllers/EventsSplitsController.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'board_meet.dart';
import 'bonus.dart';
import 'events_dividend.dart';
import 'news.dart';
import 'rights.dart';
import 'splits.dart';

class MarketEvents extends StatefulWidget {
  var _currentIndex = 0;
  @override
  State<MarketEvents> createState() => _MarketEventsState();
}

class _MarketEventsState extends State<MarketEvents> {
  
  var eventsTab = 1, eventsExpanded = false;

  @override
  void initState() {

    Dataconstants.eventsDividendController.getEventsDividend();

    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState((){ eventsExpanded ? eventsExpanded = false : eventsExpanded = true;});
                      },
                      child: Text(
                        "Events",
                        style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset("assets/appImages/arrow_right_circle.svg"),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          // HomeWidgets.scrollTop();
                        },
                        child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
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
                Obx(() {
                  return eventsTab == 1 ?
                  EventsDividendController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : EventsDividendController.getEventsDividendListItems.isEmpty
                      ? Center(child: Text("No Data available"))
                      : Column(children: [
                    SizedBox(height: 10),
                    Divider(thickness: 1),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: eventsExpanded ? EventsDividendController.getEventsDividendListItems.length
                          :EventsDividendController.getEventsDividendListItems.length < 4 ? EventsDividendController.getEventsDividendListItems.length : 4,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(EventsDividendController.getEventsDividendListItems[index].coName,
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),
                                Text("${EventsDividendController.getEventsDividendListItems[index].divamt.toStringAsFixed(2)} / share",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding (
                            padding: const  EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ex Date",
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.grey)),
                                    Text(EventsDividendController.getEventsDividendListItems[index].divDate.toString().split(" ")[0],
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.black
                                        )
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Record Date",
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.grey)),
                                    Text(EventsDividendController.getEventsDividendListItems[index].tradeDate.toString().split(" ")[0],
                                        style: Utils.fonts  (
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.black
                                        )
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Div yield",
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.grey)),
                                    Text("-",
                                        style: Utils.fonts  (
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.black
                                        )
                                    ),
                                  ],
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
                  ],)
                      : eventsTab == 2 ?
                  EventsBonusController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : EventsBonusController.getEventsBonusListItems.isEmpty
                      ? Center(child: Text("No Data available"))
                      :  Column(children: [

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: eventsExpanded ? EventsBonusController.getEventsBonusListItems.length
                          : EventsBonusController.getEventsBonusListItems.length < 4 ? EventsBonusController.getEventsBonusListItems.length : 4,
                      itemBuilder: (BuildContext context, int index) {
                        return  Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(EventsBonusController.getEventsBonusListItems[index].symbol,
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),
                                Text(EventsBonusController.getEventsBonusListItems[index].bonusRatio,
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding (
                            padding: const  EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Agenda",
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.grey)),
                                    Text(" ",
                                        style: Utils.fonts  (
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.black
                                        )
                                    ),
                                  ],
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
                  ],)
                      : eventsTab == 3 ?
                  EventsRightsController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : EventsBonusController.getEventsBonusListItems.isEmpty
                      ? Center(child: Text("No Data available"))
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: eventsExpanded ? EventsRightsController.getEventsRightsListItems.length
                        : EventsRightsController.getEventsRightsListItems.length < 4 ? EventsRightsController.getEventsRightsListItems.length : 4,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(EventsBonusController.getEventsBonusListItems[index].symbol,
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Colors.black)),
                              Text(EventsBonusController.getEventsBonusListItems[index].bonusRatio,
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding (
                          padding: const  EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Ex-Right",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Colors.grey)),
                                  Text(EventsRightsController.getEventsRightsListItems[index].rightDate.toString().split(" ")[0],
                                      style: Utils.fonts  (
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Colors.black
                                      )
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Premium",
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Colors.grey)),
                                  Text(EventsRightsController.getEventsRightsListItems[index].premium.toString(),
                                      style: Utils.fonts  (
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                          color: Colors.black
                                      )
                                  ),
                                ],
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
                      : eventsTab == 4 ?
                  EventsSplitsController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : EventsSplitsController.getEventsSplitsListItems.isEmpty
                      ? Center(child: Text("No Data available"))
                      : Column(children: [
                    Row(
                      children: [
                        Text(
                          "Symbol",
                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          "Ex-Date",
                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          "Dividend",
                          style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: 1),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: eventsExpanded ? EventsSplitsController.getEventsSplitsListItems.length
                          : EventsSplitsController.getEventsSplitsListItems.length < 4 ? EventsSplitsController.getEventsSplitsListItems.length : 4,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(EventsSplitsController.getEventsSplitsListItems[index].coName,
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),
                                Text("${EventsSplitsController.getEventsSplitsListItems[index].fvFrom.toString().split(".")[0]} : ${EventsSplitsController.getEventsSplitsListItems[index].fvTo.toString().split(".")[0]}",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding (
                            padding: const  EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ex-Split",
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.grey)),
                                    Text(EventsSplitsController.getEventsSplitsListItems[index].tradeDate.toString().split(" ")[0],
                                        style: Utils.fonts  (
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.black
                                        )
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Old FV",
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.grey)),
                                    Text(EventsSplitsController.getEventsSplitsListItems[index].fvTo.toString(),
                                        style: Utils.fonts  (
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.black
                                        )
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("New FV",
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.grey)),
                                    Text(EventsSplitsController.getEventsSplitsListItems[index].fvTo.toString(),
                                        style: Utils.fonts  (
                                            fontWeight: FontWeight.w500,
                                            size: 14.0,
                                            color: Colors.black
                                        )
                                    ),
                                  ],
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

                  ],) :
                  Center(child: Text("No Data Available"));
                } )
              ],
            ),
          ),
          Container(
            height: 4.0,
            width: MediaQuery.of(context).size.width,
            color: Utils.greyColor.withOpacity(0.2),
          ),
        ],
      );
  }
}
