import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/AlgoController/fetchAlgoController.dart';
import '../../controllers/AlgoController/finishedController.dart';
import '../../model/AlgoModels/reportFinishedAlgo_model.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/algoWidget/search_text_widget.dart';
import 'advanceOrder_screen.dart';
import 'algo_getDetail.dart';
import 'algorithm_screen.dart';

class Finished extends StatefulWidget {
  // const Await({Key? key}) : super(key: key);

  @override
  _FinishedState createState() => _FinishedState();
}

class _FinishedState extends State<Finished> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ReportFinishedAlgo> finishedList2;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    finishedList2 = FinishedController.reportFinishedAlgoLists;

    super.initState();
    InAppSelection.algoOrderReportScreenTabIndex = 2;
    Refresh();
    Dataconstants.finishedController.fetchReportFinishedAlgo();
    // CommonFunction.firebaselogEvent(true,"algo_finished_screen","_Click","algo_finished_screen");
    // Dataconstants.itsClient.reportFinishedAlgo();
    // Dataconstants.reportFinishdModel.reportFinishAlgoLists;
    // //print(Dataconstants.reportFinishdModel.reportFinishAlgoLists.name);
  }

  Refresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Dataconstants.itsClient2.reportFinishedAlgo();
    });
  }

  @override
  void dispose() {
    // Dataconstants.reportFinishdModel.reportFinishAlgoLists.clear();
    // Dataconstants.reportFinishdModel.reportFinishAlgoLists.clear();
    super.dispose();
  }

  sortFinishedAlgo(e) {
    setState(() {
      finishedList2 = FinishedController.reportFinishedAlgoLists.where((item) => item.desc.toLowerCase().contains(e.toLowerCase())).toList();
      // FinishedController.reportFinishedAlgoLists = null;
      // for(var i = 0 ; i < finishedList2.length; i++){
      //   if(finishedList2[i].desc.contains(e)){
      //     print(true);
      //   }
      // }
      // print(finishedList2.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 24,
              // color: Colors.grey,
              color: theme.appBarTheme.color,
            ),
            Card(
              color: theme.accentColor,
              elevation: 5,
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 4,
              ),
              child: Container(
                height: 45,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: (value) {
                                      sortFinishedAlgo(value);
                                      setState(() {});
                                      // Dataconstants.orderReport
                                      //     .updatePendingFilteredOrdersBySearch(value);
                                    },
                                    onSubmitted: (value) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: "Search Name",
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // if (InAppSelection.algoOrderReportScreenTabIndex != 2)
                    //   InkWell(
                    //     onTap: () {
                    //       showDialog<String>(
                    //         context: context,
                    //         builder: (BuildContext context) => AlertDialog(
                    //           title: const Text('Stop All'),
                    //           content: const Text('It will close all Awaited and Running Algoes'),
                    //           actions: <Widget>[
                    //             TextButton(
                    //               onPressed: () {
                    //                 Navigator.pop(context, 'No');
                    //               },
                    //               child: const Text(
                    //                 'No',
                    //                 style: TextStyle(
                    //                     color: Colors.deepOrange, fontSize: 17),
                    //               ),
                    //             ),
                    //             TextButton(
                    //               onPressed: () {
                    //                 if (Dataconstants.reportAlgoModel
                    //                         .reportAlgoLists.isEmpty &&
                    //                     Dataconstants.reportRunningsModel
                    //                         .reportRunningAlgoLists.isEmpty) {
                    //                   Navigator.pop(context, 'Yes');
                    //                   {
                    //                     CommonFunction.showSnackBarKey(
                    //                       key: _scaffoldKey,
                    //                       color: Colors.red,
                    //                       context: context,
                    //                       text:
                    //                           'There is no remaining algo in the list',
                    //                     );
                    //                     return;
                    //                   }
                    //                 } else {
                    //                   Dataconstants.itsClient.stopAllAlgo();
                    //                 }
                    //                 Navigator.pop(context, 'Yes');
                    //               },
                    //               child: const Text(
                    //                 'Yes',
                    //                 style: TextStyle(
                    //                     color: Colors.deepOrange, fontSize: 17),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   )
                    // child: Icon(
                    //   Icons.stop_circle_outlined,
                    //   color: Colors.red,
                    //   size: 30,
                    // )),
                    // IconButton(
                    //   icon: Icon(Icons.sort_rounded),
                    //   // onPressed: () {
                    //   //   FocusManager.instance.primaryFocus.unfocus();
                    //   //   showModalBottomSheet<void>(
                    //   //     context: context,
                    //   //     isScrollControlled: true,
                    //   //     builder: (BuildContext context) {
                    //   //       return AwaitAlgoReportFilter(Dataconstants.reportAlgoModel.getAwaitingAlgoFilterMap());
                    //   //     },
                    //   //   );
                    //   // },
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 2,
        ),
        // Observer(builder: (context) {
        //   if (Dataconstants.orderReport.currentPendingFilters.length > 0)
        //     return Container(
        //       padding: EdgeInsets.symmetric(horizontal: 10),
        //       alignment: Alignment.centerLeft,
        //       child: Wrap(
        //         spacing: 10,
        //         children: Dataconstants.orderReport.currentPendingFilters
        //             .map(
        //               (e) => FilterChip(
        //                 label: Row(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     Text(e),
        //                     SizedBox(width: 3),
        //                     Icon(
        //                       Icons.close,
        //                       size: 18,
        //                     ),
        //                   ],
        //                 ),
        //                 onSelected: (value) {
        //                   Dataconstants.orderReport.updatePendingFilter(e);
        //                 },
        //               ),
        //             )
        //             .toList(),
        //       ),
        //     );
        //   else
        //     return SizedBox.shrink();
        // }),
        Expanded(child: Obx(() {
          return FinishedController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : FinishedController.reportFinishedAlgoLists.isEmpty
                  ? RefreshIndicator(
                      color: theme.primaryColor,
                      onRefresh: () => Dataconstants.finishedController.fetchReportFinishedAlgo(),
                      child: SingleChildScrollView(
                        // physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Pull down to refresh',
                                  // style: TextStyle(
                                  //     color: theme.textTheme.bodyText1.color),
                                  style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: theme.textTheme.bodyText1.color),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.refresh,
                                  size: 18,
                                  color: theme.textTheme.bodyText1.color,
                                ),
                              ],
                            ),
                            // SizedBox(height: 130),
                            Padding(
                              padding: const EdgeInsets.only(top: 250, bottom: 300),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Nothing to see here yet.\nAdd an algorithm to get started",
                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Colors.grey.shade500),
                                    // style: TextStyle(
                                    //     color: Colors.grey[500], fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    key: Dataconstants.coachMarkerKey,
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(theme.primaryColor),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: theme.primaryColor)))),
                                    // color: theme.primaryColor,
                                    onPressed: () async {
                                      setState(() {
                                        Dataconstants.isFromScripDetailToAdvanceScreen = false;
                                        Dataconstants.isFinishedAlgoModify = false;
                                        Dataconstants.isAwaitingAlgoModify = false;
                                        // //print(
                                        //     'isAwaitingAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
                                        //  Dataconstants.itsClient.fetch();
                                      });
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlgorithmScreen())); // AlgorithmScreen()))    AdvanceOrder
                                      // CommonFunction.firebaselogEvent(true,"add_algo","_Click","add_algo");
                                    },
                                    child: Container(
                                        height: 40,
                                        width: 90,
                                        child: Center(
                                          child: Text(
                                            "Add Algo",
                                            style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
                                            // style: TextStyle(
                                            //     color: Colors.white,
                                            //     //Colors.grey,
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.w600)
                                          ),
                                        )),
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(40),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                  // Center(
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Text(
                  //                   "No Finished Algo",
                  //                   style: TextStyle(
                  //                       color: Colors.grey[600], fontSize: 15),
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //
                  //                 SizedBox(height: 10),
                  //                 ElevatedButton(
                  //                   key:  Dataconstants.coachMarkerKey,
                  //                   color: theme.primaryColor,
                  //                   onPressed: () async {
                  //                     setState(() {
                  //                       Dataconstants.isFromScripDetailToAdvanceScreen =
                  //                       false;
                  //                       Dataconstants.isFinishedAlgoModify = false;
                  //                       Dataconstants.isAwaitingAlgoModify = false;
                  //                       // //print(
                  //                       //     'isAwaitingAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
                  //                       //  Dataconstants.itsClient.fetch();
                  //                     });
                  //                     Navigator.of(context).push(MaterialPageRoute(
                  //                         builder: (context) =>
                  //                             AlgorithmScreen())); // AlgorithmScreen()))    AdvanceOrder
                  //                   },
                  //                   child: Container(
                  //
                  //                       height: 40,
                  //                       width: 90,
                  //                       child:
                  //                       Center(
                  //                         child: Text("Add Algo",
                  //                             style: TextStyle(
                  //                                 color: Colors.white,
                  //                                 //Colors.grey,
                  //                                 fontSize: 16,
                  //                                 fontWeight: FontWeight.w600)),
                  //                       )
                  //                   ),
                  //                   shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(40),
                  //                   ),
                  //                 ),
                  //                 // SizedBox(
                  //                 //   height: 10,
                  //                 // ),
                  //                 // OutlineButton(
                  //                 //     shape: RoundedRectangleBorder(
                  //                 //       borderRadius: BorderRadius.circular(40),
                  //                 //     ),
                  //                 //     borderSide: (BorderSide(
                  //                 //       color: theme.primaryColor,
                  //                 //     )),
                  //                 //     child: Text(
                  //                 //       'Refresh',
                  //                 //       style: TextStyle(color: theme.primaryColor),
                  //                 //     ),
                  //                 //     onPressed: () => Dataconstants.finishedController
                  //                 //         .fetchReportFinishedAlgo())
                  //               ],
                  //             ),
                  //           )
                  : RefreshIndicator(
                      color: theme.primaryColor,
                      onRefresh: () {
                        Dataconstants.finishedController.fetchReportFinishedAlgo();
                        finishedList2 = FinishedController.reportFinishedAlgoLists;
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pull down to refresh',
                                style: TextStyle(color: theme.textTheme.bodyText1.color),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                Icons.refresh,
                                size: 18,
                                color: theme.textTheme.bodyText1.color,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                              child: ListView.builder(
                                  itemCount:   finishedList2.length,
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return DraggableScrollableSheet(
                                                  expand: false,
                                                  minChildSize: 0.3,
                                                  initialChildSize: 0.5,
                                                  maxChildSize: 0.75,
                                                  builder: (context, scrollController) {
                                                    return AlgoDetail(controller: scrollController, model: FinishedController.reportFinishedAlgoLists[index]);
                                                  });
                                            });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12, left: 5, right: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  FinishedController.reportFinishedAlgoLists[index].algoName,
                                                  style: TextStyle(fontSize: 17),
                                                  // 'MACD$index'
                                                ),
                                                Spacer(),
                                                Text(
                                                    FinishedController.reportFinishedAlgoLists[index].instStatus == "S"
                                                        ? "Stopped"
                                                        : FinishedController.reportFinishedAlgoLists[index].instStatus == "C"
                                                            ? "Completed"
                                                            : "Time Out",
                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: Colors.grey[600]))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        finishedList2[index].exch == "N" ? "NSE" : "BSE",
                                                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        finishedList2[index].exchType == "C" ? "EQ " : "DR ",
                                                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                                      ),
                                                      Text(
                                                        finishedList2[index].exchType == "D" ? "" : ': ${finishedList2[index].model.name}',
                                                        style: TextStyle(fontSize: 13),
                                                      ),
                                                      Text(
                                                        finishedList2[index].exchType == "C" ? "" : ": ${finishedList2[index].desc}",
                                                        style: TextStyle(fontSize: 13),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 3,
                                                    horizontal: 7,
                                                  ),
                                                  color: finishedList2[index].algoId == 4
                                                      ? Colors.grey.withOpacity(0.2)
                                                      : finishedList2[index].buySell == "B"
                                                          ? ThemeConstants.buyColor.withOpacity(0.2)
                                                          : ThemeConstants.sellColor.withOpacity(0.2),
                                                  child: Text(
                                                    finishedList2[index].algoId == 4
                                                        ? "AUTO"
                                                        : finishedList2[index].buySell == "B"
                                                            ? 'BUY'
                                                            : 'SELL',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: finishedList2[index].algoId == 4
                                                          ? Colors.white
                                                          : finishedList2[index].buySell == "B"
                                                              ? ThemeConstants.buyColor
                                                              : ThemeConstants.sellColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 3, bottom: 5),
                                                  child: Row(children: [
                                                    Text(
                                                      'Start :',
                                                      style: TextStyle(color: Colors.grey),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      DateUtil.getDateWithFormatForAlgoDate(finishedList2[index].startTime, "dd-MM-yyyy HH:mm"),
                                                    )
                                                  ]),
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 3, bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      // Text('P&L'),
                                                      Text(
                                                        'End :',
                                                        style: TextStyle(color: Colors.grey),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        DateUtil.getDateWithFormatForAlgoDate(finishedList2[index].endTime, "dd-MM-yyyy HH:mm").toString(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 7,
                                                      ),
                                                      color: Colors.cyan.withOpacity(0.2),
                                                      child: Text(
                                                        finishedList2[index].orderType == "I"
                                                            ? "INTRADAY"
                                                            : finishedList2[index].exchType == "D"
                                                                ? "NORMAL".toUpperCase()
                                                                : "DELIVERY",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.cyan,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 7,
                                                      ),
                                                      color: theme.primaryColor.withOpacity(0.2),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            finishedList2[index].algoId == 4 ? "Open Qty" : "Placed Qty",
                                                            style: TextStyle(color: theme.primaryColor),
                                                            // '(50,20,09)'
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            finishedList2[index].placedQty.toString() == "null"
                                                                ? "0"
                                                                : finishedList2[index].placedQty.toString(),
                                                            style: TextStyle(color: theme.primaryColor),
                                                            // '(50,20,09)'
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 3,
                                                    horizontal: 7,
                                                  ),
                                                  color: Colors.amber[700].withOpacity(0.2),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        finishedList2[index].algoId == 4 ? "Max Open Qty" : "Total Qty",
                                                        style: TextStyle(color: Colors.amber[700]),
                                                        // 'Return'
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        finishedList2[index].totalQty.toString(),
                                                        style: TextStyle(color: Colors.amber[700]),
                                                        // '1%'
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 17),
                                            Divider(
                                              height: 2,
                                              thickness: 1.2,
                                              color: theme.dividerColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    );
        })

            // Observer(
            //     builder: (_) =>
            //     // Dataconstants
            //     //             .reportFinishdModel.fetchingOrders ==
            //     //         false
            //     //     ? Center(
            //     //         child: CircularProgressIndicator(
            //     //           valueColor: AlwaysStoppedAnimation(theme.primaryColor),
            //     //         ),
            //     //       )
            //     //     :
            //     Dataconstants.reportFinishdModel.reportFinishAlgoLists.isEmpty
            //             ? Center(
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     Text(
            //                       "No Finished Algo",
            //                       style: TextStyle(
            //                           color: Colors.grey[600], fontSize: 15),
            //                       textAlign: TextAlign.center,
            //                     ),
            //                     SizedBox(
            //                       height: 10,
            //                     ),
            //                     OutlineButton(
            //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
            //                         borderSide: (BorderSide(
            //                           color: theme.primaryColor,
            //                         )),
            //                         child: Text(
            //                           'Refresh',
            //                           style: TextStyle(color: theme.primaryColor),
            //                         ),
            //                         onPressed: () => Dataconstants.itsClient
            //                             .reportFinishedAlgo())
            //                   ],
            //                 ),
            //               )
            //             : RefreshIndicator(
            //                 color: theme.primaryColor,
            //                 onRefresh: () =>
            //                     Dataconstants.itsClient.reportFinishedAlgo(),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Text(
            //                           'Pull down to refresh',
            //                           style: TextStyle(color: theme.textTheme.bodyText1.color),
            //                         ),
            //                         SizedBox(
            //                           width: 3,
            //                         ),
            //                         Icon(
            //                           Icons.refresh,
            //                           size: 18,
            //                           color:theme.textTheme.bodyText1.color,
            //                         ),
            //                       ],
            //                     ),
            //                     Expanded(
            //                       child: Padding(
            //                         padding: const EdgeInsets.only(
            //                             left: 8, right: 8, bottom: 8),
            //                         child: ListView.builder(
            //                             itemCount: Dataconstants
            //                                 .reportFinishdModel
            //                                 .reportFinishAlgoLists
            //                                 .length,
            //                             shrinkWrap: true,
            //                             physics: AlwaysScrollableScrollPhysics(),
            //                             itemBuilder: (context, index) {
            //                               return InkWell(
            //                                 onTap: () {
            //                                   showModalBottomSheet(
            //                                       isScrollControlled: true,
            //                                       context: context,
            //                                       builder: (context) {
            //                                         return DraggableScrollableSheet(
            //                                             expand: false,
            //                                             minChildSize: 0.3,
            //                                             initialChildSize: 0.5,
            //                                             maxChildSize: 0.75,
            //                                             builder: (context,
            //                                                 scrollController) {
            //                                               return AlgoDetail(
            //                                                   controller:
            //                                                       scrollController,
            //                                                   model: Dataconstants
            //                                                       .reportFinishdModel
            //                                                       .reportFinishAlgoLists[index]);
            //                                             });
            //                                       });
            //                                 },
            //                                 child: Padding(
            //                                   padding: const EdgeInsets.only(
            //                                       top: 12, left: 5, right: 5),
            //                                   child: Column(
            //                                     children: [
            //                                       Row(
            //                                         children: [
            //                                           Text(
            //                                             Dataconstants
            //                                                 .reportFinishdModel
            //                                                 .reportFinishAlgoLists[
            //                                                     index]
            //                                                 .algoName,
            //                                             style: TextStyle(
            //                                                 fontSize: 17),
            //                                             // 'MACD$index'
            //                                           ),
            //                                           Spacer(),
            //                                           Text(
            //                                               Dataconstants
            //                                                           .reportFinishdModel
            //                                                           .reportFinishAlgoLists[
            //                                                               index]
            //                                                           .instStatus ==
            //                                                       "S"
            //                                                   ? "Stopped"
            //                                                   : Dataconstants
            //                                                               .reportFinishdModel
            //                                                               .reportFinishAlgoLists[
            //                                                                   index]
            //                                                               .instStatus ==
            //                                                           "C"
            //                                                       ? "Completed"
            //                                                       : "Time Out",
            //                                               style: TextStyle(
            //                                                   fontWeight:
            //                                                       FontWeight.w400,
            //                                                   fontSize: 13,
            //                                                   color: Colors
            //                                                       .grey[600]))
            //                                         ],
            //                                       ),
            //                                       Row(
            //                                         children: [
            //                                           Padding(
            //                                             padding:
            //                                                 const EdgeInsets.only(
            //                                                     top: 5,
            //                                                     bottom: 5),
            //                                             child: Row(
            //                                               children: [
            //                                                 Text(
            //                                                   Dataconstants
            //                                                               .reportFinishdModel
            //                                                               .reportFinishAlgoLists[
            //                                                                   index]
            //                                                               .exch ==
            //                                                           "N"
            //                                                       ? "NSE"
            //                                                       : "BSE",
            //                                                   style: TextStyle(
            //                                                       fontSize: 13,
            //                                                       color: Colors
            //                                                           .grey[600]),
            //                                                 ),
            //                                                 SizedBox(width: 3),
            //                                                 Text(
            //                                                   Dataconstants
            //                                                               .reportFinishdModel
            //                                                               .reportFinishAlgoLists[
            //                                                                   index]
            //                                                               .exchType ==
            //                                                           "C"
            //                                                       ? "EQ "
            //                                                       : "DR ",
            //                                                   style: TextStyle(
            //                                                       fontSize: 13,
            //                                                       color: Colors
            //                                                           .grey[600]),
            //                                                 ),
            //                                                 Text(
            //                                                   Dataconstants
            //                                                               .reportFinishdModel
            //                                                               .reportFinishAlgoLists[
            //                                                                   index]
            //                                                               .exchType ==
            //                                                           "D"
            //                                                       ? ""
            //                                                       : ': ${Dataconstants.reportFinishdModel.reportFinishAlgoLists[index].model.name}',
            //                                                   style: TextStyle(
            //                                                       fontSize: 13),
            //                                                 ),
            //                                                 Text(
            //                                                   Dataconstants
            //                                                               .reportFinishdModel
            //                                                               .reportFinishAlgoLists[
            //                                                                   index]
            //                                                               .exchType ==
            //                                                           "C"
            //                                                       ? ""
            //                                                       : ": ${Dataconstants.reportFinishdModel.reportFinishAlgoLists[index].desc}",
            //                                                   style: TextStyle(
            //                                                       fontSize: 13),
            //                                                 )
            //                                               ],
            //                                             ),
            //                                           ),
            //                                           Spacer(),
            //                                           Container(
            //                                             padding:
            //                                                 EdgeInsets.symmetric(
            //                                               vertical: 3,
            //                                               horizontal: 7,
            //                                             ),
            //                                             color: Dataconstants
            //                                                         .reportFinishdModel
            //                                                         .reportFinishAlgoLists[
            //                                                             index]
            //                                                         .algoId ==
            //                                                     4
            //                                                 ? Colors.grey
            //                                                     .withOpacity(0.2)
            //                                                 : Dataconstants
            //                                                             .reportFinishdModel
            //                                                             .reportFinishAlgoLists[
            //                                                                 index]
            //                                                             .buySell ==
            //                                                         "B"
            //                                                     ? ThemeConstants
            //                                                         .buyColor
            //                                                         .withOpacity(
            //                                                             0.2)
            //                                                     : ThemeConstants
            //                                                         .sellColor
            //                                                         .withOpacity(
            //                                                             0.2),
            //                                             child: Text(
            //                                               Dataconstants
            //                                                           .reportFinishdModel
            //                                                           .reportFinishAlgoLists[
            //                                                               index]
            //                                                           .algoId ==
            //                                                       4
            //                                                   ? "AUTO"
            //                                                   : Dataconstants
            //                                                               .reportFinishdModel
            //                                                               .reportFinishAlgoLists[
            //                                                                   index]
            //                                                               .buySell ==
            //                                                           "B"
            //                                                       ? 'BUY'
            //                                                       : 'SELL',
            //                                               style: TextStyle(
            //                                                 fontWeight:
            //                                                     FontWeight.w500,
            //                                                 color: Dataconstants
            //                                                             .reportFinishdModel
            //                                                             .reportFinishAlgoLists[
            //                                                                 index]
            //                                                             .algoId ==
            //                                                         4
            //                                                     ? Colors.white
            //                                                     : Dataconstants
            //                                                                 .reportFinishdModel
            //                                                                 .reportFinishAlgoLists[
            //                                                                     index]
            //                                                                 .buySell ==
            //                                                             "B"
            //                                                         ? ThemeConstants
            //                                                             .buyColor
            //                                                         : ThemeConstants
            //                                                             .sellColor,
            //                                               ),
            //                                             ),
            //                                           ),
            //                                         ],
            //                                       ),
            //                                       Row(
            //                                         children: [
            //                                           Padding(
            //                                             padding:
            //                                                 const EdgeInsets.only(
            //                                                     top: 3,
            //                                                     bottom: 5),
            //                                             child: Row(children: [
            //                                               Text(
            //                                                 'Start :',
            //                                                 style: TextStyle(
            //                                                     color:
            //                                                         Colors.grey),
            //                                               ),
            //                                               SizedBox(
            //                                                 width: 8,
            //                                               ),
            //                                               Text(
            //                                                 DateUtil.getDateWithFormatForAlgoDate(
            //                                                     Dataconstants
            //                                                         .reportFinishdModel
            //                                                         .reportFinishAlgoLists[
            //                                                             index]
            //                                                         .startTime,
            //                                                     "dd-MM-yyyy HH:mm"),
            //                                               )
            //                                             ]),
            //                                           ),
            //                                           Spacer(),
            //                                           Padding(
            //                                             padding:
            //                                                 const EdgeInsets.only(
            //                                                     top: 3,
            //                                                     bottom: 5),
            //                                             child: Row(
            //                                               children: [
            //                                                 // Text('P&L'),
            //                                                 Text(
            //                                                   'End :',
            //                                                   style: TextStyle(
            //                                                       color: Colors
            //                                                           .grey),
            //                                                 ),
            //                                                 SizedBox(
            //                                                   width: 8,
            //                                                 ),
            //                                                 Text(
            //                                                   DateUtil.getDateWithFormatForAlgoDate(
            //                                                           Dataconstants
            //                                                               .reportFinishdModel
            //                                                               .reportFinishAlgoLists[
            //                                                                   index]
            //                                                               .endTime,
            //                                                           "dd-MM-yyyy HH:mm")
            //                                                       .toString(),
            //                                                 )
            //                                               ],
            //                                             ),
            //                                           ),
            //                                         ],
            //                                       ),
            //                                       Row(
            //                                         children: [
            //                                           Row(
            //                                             children: [
            //                                               Container(
            //                                                 padding: EdgeInsets
            //                                                     .symmetric(
            //                                                   vertical: 3,
            //                                                   horizontal: 7,
            //                                                 ),
            //                                                 color: Colors.cyan
            //                                                     .withOpacity(0.2),
            //                                                 child: Text(
            //                                                   Dataconstants
            //                                                               .reportFinishdModel
            //                                                               .reportFinishAlgoLists[
            //                                                                   index]
            //                                                               .orderType ==
            //                                                           "I"
            //                                                       ? "INTRADAY"
            //                                                       : Dataconstants
            //                                                                   .reportFinishdModel
            //                                                                   .reportFinishAlgoLists[
            //                                                                       index]
            //                                                                   .exchType ==
            //                                                               "D"
            //                                                           ? "NORMAL"
            //                                                               .toUpperCase()
            //                                                           : "DELIVERY",
            //                                                   style: TextStyle(
            //                                                     fontWeight:
            //                                                         FontWeight
            //                                                             .w500,
            //                                                     color:
            //                                                         Colors.cyan,
            //                                                   ),
            //                                                 ),
            //                                               ),
            //                                               SizedBox(width: 5),
            //                                               Container(
            //                                                 padding: EdgeInsets
            //                                                     .symmetric(
            //                                                   vertical: 3,
            //                                                   horizontal: 7,
            //                                                 ),
            //                                                 color: theme
            //                                                     .primaryColor
            //                                                     .withOpacity(0.2),
            //                                                 child: Row(
            //                                                   children: [
            //                                                     Text(
            //                                                       Dataconstants
            //                                                                   .reportFinishdModel
            //                                                                   .reportFinishAlgoLists[index]
            //                                                                   .algoId ==
            //                                                               4
            //                                                           ? "Open Qty"
            //                                                           : "Placed Qty",
            //                                                       style: TextStyle(
            //                                                           color: theme
            //                                                               .primaryColor),
            //                                                       // '(50,20,09)'
            //                                                     ),
            //                                                     SizedBox(
            //                                                       width: 8,
            //                                                     ),
            //                                                     Text(
            //                                                       Dataconstants.reportFinishdModel.reportFinishAlgoLists[index].placedQty.toString()=="null"
            //                                                       ?"0"
            //                                                           :Dataconstants.reportFinishdModel.reportFinishAlgoLists[index].placedQty.toString(),
            //                                                       style: TextStyle(
            //                                                           color: theme
            //                                                               .primaryColor),
            //                                                       // '(50,20,09)'
            //                                                     ),
            //                                                   ],
            //                                                 ),
            //                                               )
            //                                             ],
            //                                           ),
            //                                           Spacer(),
            //                                           Container(
            //                                             padding:
            //                                                 EdgeInsets.symmetric(
            //                                               vertical: 3,
            //                                               horizontal: 7,
            //                                             ),
            //                                             color: Colors.amber[700]
            //                                                 .withOpacity(0.2),
            //                                             child: Row(
            //                                               children: [
            //                                                 Text(
            //                                                   Dataconstants
            //                                                               .reportFinishdModel
            //                                                               .reportFinishAlgoLists[
            //                                                                   index]
            //                                                               .algoId ==
            //                                                           4
            //                                                       ? "Max Open Qty"
            //                                                       : "Total Qty",
            //                                                   style: TextStyle(
            //                                                       color: Colors
            //                                                               .amber[
            //                                                           700]),
            //                                                   // 'Return'
            //                                                 ),
            //                                                 SizedBox(
            //                                                   width: 10,
            //                                                 ),
            //                                                 Text(
            //                                                   Dataconstants
            //                                                       .reportFinishdModel
            //                                                       .reportFinishAlgoLists[
            //                                                           index]
            //                                                       .totalQty
            //                                                       .toString(),
            //                                                   style: TextStyle(
            //                                                       color: Colors
            //                                                               .amber[
            //                                                           700]),
            //                                                   // '1%'
            //                                                 )
            //                                               ],
            //                                             ),
            //                                           ),
            //                                         ],
            //                                       ),
            //                                       SizedBox(height: 17),
            //                                       Divider(
            //                                         height: 2,
            //                                         thickness: 1.2,
            //                                         color: theme.dividerColor,
            //                                       ),
            //                                     ],
            //                                ),
            //                              ),
            //                            );
            //                         }),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               )),
            ),
      ],
    );
  }
}

class AlgoDetail extends StatefulWidget {
  final ReportFinishedAlgo model;
  ScrollController controller;

  AlgoDetail({this.model, this.controller});

//  const ({Key? key}) : super(key: key);

  @override
  _AlgoDetailState createState() => _AlgoDetailState(model, controller);
}

class _AlgoDetailState extends State<AlgoDetail> {
  _AlgoDetailState(
    ReportFinishedAlgo model,
    ScrollController controller,
  );

  int instructionDateConverted;
  String name;
  int algoId;
  String algoPhrase;
  String algoType;
  String algoSegment;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    var instructionDate = DateUtil.getAnyFormattedDate(DateTime.now(), "dd-MMM-yyyy hh:mm:ss");
    // widget.model.model.name;

    // //print('insTructionTime pass sdfdsf = $instructionDate');
    instructionDateConverted = DateUtil.getIntFromDate1(instructionDate);
    // //print(
    //     'insTructionTime pass Converted to integer = $instructionDateConverted');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      controller: widget.controller,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          // height: 410,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: FractionallySizedBox(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 5,
                    decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(5)),
                  ),
                  widthFactor: 0.25,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(theme.primaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: theme.primaryColor)))),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(40),
                    // ),
                    // color: theme.primaryColor,
                    onPressed: () {
                      // Navigator.pop(context);

                      setState(
                        () {
                          // CommonFunction.firebaselogEvent(true,"algo_clone","_Click","algo_clone");
                          var model2;

                          // name =  widget.model.algoName; // Dataconstants.fetchAlgoModel.fetchAlgoLists[widget.model.algoId - 1].listItem[].algoName;    //listItem[widget.model.algoId - 1].algoName;
                          // algoId = widget.model.algoId;//Dataconstants.fetchAlgoModel.fetchAlgoLists[widget.model.algoId - 1].listItem[widget.model.algoId - 1].algoId;
                          // algoPhrase =  //widget.model.
                          // Dataconstants.fetchAlgoModel.fetchAlgoLists[widget.model.algoId - 1].listItem[widget.model.algoId - 1].algoPhrase;
                          // algoType = Dataconstants.fetchAlgoModel.fetchAlgoLists[widget.model.algoId - 1].listItem[widget.model.algoId - 1].algoType;
                          // algoSegment = Dataconstants.fetchAlgoModel.fetchAlgoLists[widget.model.algoId - 1].listItem[widget.model.algoId - 1].algoSegment;

                          name = widget.model.algoName;
                          algoId = widget.model.algoId;
                          algoPhrase = FetchAlgoController.fetchAlgoLists[widget.model.algoId - 1].algoPhrase;
                          algoType = FetchAlgoController.fetchAlgoLists[widget.model.algoId - 1].algoType;
                          algoSegment = FetchAlgoController.fetchAlgoLists[widget.model.algoId - 1].algoSegment;
                          var paramModel = FetchAlgoController.fetchAlgoLists[widget.model.algoId - 1].algoParam;
                          var tempModel = CommonFunction.getScripDataModel(exch: widget.model.exch, exchCode: widget.model.scripCode, getNseBseMap: true);

                          // //print('srgsg ${widget.model.scripCode}');
                          // var paramModel = Dataconstants.fetchAlgoModel.fetchAlgoLists[widget.model.algoId - 1].listItem[widget.model.algoId - 1]
                          //     .algoParam;

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AdvanceOrder(name: name, id: algoId, phrase: algoPhrase, type: algoType, segment: algoSegment, modifyModel: tempModel, paramModel: paramModel)));

                          setState(() {
                            Dataconstants.isFinishedAlgoModify = true;
                            Dataconstants.finishedAlgoToAdvanceScreen = widget.model;
                          });
                        },
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        // height: 40,
                        // width: 80,
                        child: Align(alignment: Alignment.center, child: Text("Clone", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)))),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      // Navigator.pop(context);
                      var ltppModel = CommonFunction.getScripDataModel(exch: widget.model.exch, exchCode: widget.model.scripCode, getNseBseMap: true);
                      // Dataconstants.algoLogModel.algoLogLists.clear();
                      // await Dataconstants.itsClient2.algoLog(
                      //   instructionId: widget.model.instId,
                      // );
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AlgoGetDetail(modifyModel: ltppModel, instructionId: widget.model.instId, buySel: widget.model.buySell)));
                      // CommonFunction.firebaselogEvent(true,"algo_log","_Click","algo_log");
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Colors.white, style: BorderStyle.solid),
                    ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(40),
                    // ),
                    // borderSide: BorderSide(
                    //   width: 1.0,
                    //   color: Colors.blue,
                    //   style: BorderStyle.solid,
                    // ),
                    child: Text(
                      "Algo Log",
                      style: TextStyle(
                          color: Colors.blue,
                          // color: theme.textTheme.bodyText1.color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              // Spacer(),
              // RaisedButton(onPressed: (){},
              //   color: theme.primaryColor,
              //   child: Container(
              //     height: 40,
              //     width: 80,
              //     child: Align(
              //         alignment: Alignment.center,
              //         child: Text("Get More",
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w500)))),
              //
              //
              // )
              // RaisedButton(
              //   color: theme.primaryColor,
              //   onPressed: () {
              //     Dataconstants.itsClient.restartAlgo(
              //         algoId: widget.model.algoId,
              //         totalQty: widget.model.totalQty,
              //         slicingQty: widget.model.slicingQty,
              //         buySell: widget.model.buySell == "B" ? "BUY" : "SELL",
              //         orderType:
              //             widget.model.orderType == "D" ? "Delevery" : "Intraday",
              //         timeInterval: widget.model.timeInterval,
              //         startTime: widget.model.startTime,
              //         endTime: widget.model.endTime,
              //         limitPrice: widget.model.limitPrice,
              //         priceRangeLow: widget.model.priceRangeLow,
              //         priceRangeHigh: widget.model.priceRangeHigh,
              //         instructionTime:  instructionDateConverted,//"${DateTime.now().hour}:${DateTime.now().minute}",
              //         instructionId: widget.model.instId,
              //         avgDirection: widget.model.avgDirection,
              //         avgLimitPrice: widget.model.avgLimitPrice,
              //         avgEntryDiff: widget.model.avgEntryDiff,
              //         avgExitDiff: widget.model.avgExitDiff);
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     height: 40,
              //     width: 90,
              //     child: Row(
              //       children: [
              //         Icon(
              //           Icons.not_started_outlined,
              //           size: 30,
              //           color: Colors.white,
              //         ),
              //         SizedBox(width: 8),
              //         Text("Clone",
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 17,
              //                 fontWeight: FontWeight.w500))
              //       ],
              //     ),
              //   ),
              // ),

              SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                decoration: BoxDecoration(color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.grey.shade200 : Colors.blueGrey[900]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.model.algoName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: theme.textTheme.bodyText1.color,
                              )),
                          Row(
                            children: [
                              Text("ID : ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textTheme.bodyText1.color,
                                  )),
                              Text(widget.model.instId.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textTheme.bodyText1.color,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(widget.model.exch == "N" ? "NSE : " : "BSE : ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textTheme.bodyText1.color,
                                  )),
                              Text(widget.model.exchType == "C" ? "EQ " : "DR ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textTheme.bodyText1.color,
                                  )),
                            ],
                          ),
                          Text(widget.model.desc,
                              style: TextStyle(
                                fontSize: widget.model.exchType == "C" ? 16 : 14,
                                fontWeight: FontWeight.w400,
                                color: theme.textTheme.bodyText1.color,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Text("Buy/Sell :  ", style: TextStyle(
                              //   fontSize: 16,
                              //   fontWeight: FontWeight.w400,
                              //   color: theme.textTheme.bodyText1.color,
                              // )),
                              Text(widget.model.buySell == "B" ? "Buy" : "Sell",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textTheme.bodyText1.color,
                                  )),
                            ],
                          ),
                          Text(
                              widget.model.orderType == "I"
                                  ? "INTRADAY"
                                  : widget.model.exchType == "D"
                                      ? "NORMAL".toUpperCase()
                                      : "DELIVERY",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: theme.textTheme.bodyText1.color,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateUtil.getDateWithFormatForAlgoDate(widget.model.startTime, "dd-MM-yyyy HH:mm").toString(),
                              // widget.model.startTime??"00:00",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: theme.textTheme.bodyText1.color,
                              )),
                          Text(DateUtil.getDateWithFormatForAlgoDate(widget.model.endTime, "dd-MM-yyyy HH:mm").toString(),
                              // widget.model.endTime??"00:00",
                              //widget.model.endTime.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: theme.textTheme.bodyText1.color,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.model.algoId == 4 ? "Max Open Qty" : "Total Qty", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                  Text(widget.model.totalQty.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyText1.color,
                      )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.model.algoId == 3 || widget.model.algoId == 4 ? "Averaging Qty" : "Slice Qty", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                  Text(widget.model.slicingQty.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyText1.color,
                      )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sent Qty", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                  Text(widget.model.sentQty.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyText1.color,
                      )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text((widget.model.algoId != 4) ? "Placed Qty" : "Open Qty", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                  Text(widget.model.placedQty.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyText1.color,
                      )),
                ],
              ),
              if (widget.model.algoId != 4)
                Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rejected Qty", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                        Text(widget.model.rejectedQty.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodyText1.color,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              if (widget.model.algoId != 4 && widget.model.algoId != 5)
                Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pending Qty",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                        ),
                        Text(widget.model.pendingQty.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodyText1.color,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              if (widget.model.algoId != 4)
                SizedBox(
                  height: 3,
                ),
              Divider(
                thickness: 1.0,
                color: theme.dividerColor,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "Exchange :",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: theme.textTheme.bodyText1.color),
              ),

              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Traded Qty', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                  Text(widget.model.exchTradedQty.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyText1.color,
                      )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rejected Qty', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                  Text(widget.model.exchRejectedQty.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyText1.color,
                      )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pending Qty', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                  Text(widget.model.exchPendingQty.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyText1.color,
                      )),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Divider(
                thickness: 1.0,
                color: theme.dividerColor,
              ),
              SizedBox(
                height: 5,
              ),
              if (widget.model.algoId == 3 || widget.model.algoId == 4 || widget.model.algoId == 2)
                Column(
                  children: [
                    Text(
                      "Price :",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: theme.textTheme.bodyText1.color),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),

              if (widget.model.algoId == 2)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price Range High", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                        Text(widget.model.priceRangeHigh.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodyText1.color,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price Range Low", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                        Text(widget.model.priceRangeLow.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodyText1.color,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),

              if (widget.model.algoId == 3 || widget.model.algoId == 4)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Avg Start Price", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                        Text(widget.model.atMarket == "M" ? "Mkt" : widget.model.avgLimitPrice.toString() ?? " ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodyText1.color,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Avg Entry Diff", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                        Text(widget.model.avgEntryDiff.toStringAsFixed(2) ?? " ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodyText1.color,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (widget.model.algoId == 4)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Avg Exit Diff", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                              Text(widget.model.avgExitDiff.toStringAsFixed(2) ?? " ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: theme.textTheme.bodyText1.color,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Avg Direction", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                        Text(widget.model.avgDirection == "D" ? "Down" : "Up" ?? " ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodyText1.color,
                            )),
                      ],
                    ),
                  ],
                ),
              if (widget.model.algoId != 4 && widget.model.algoId != 3)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Time Interval", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                        Text(DateUtil.getDateWithFormatForAlgoDate(widget.model.timeInterval, "dd-MM-yyyy HH:mm:ss").toString().split(' ')[1].split(".")[0],
                            // (widget.model.timeInterval/60).toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodyText1.color,
                            )),
                      ],
                    ),
                  ],
                )

              //         SizedBox(

              //               if (widget.model.algoId == 4)
              //                 Column(
              //                   children: [
              //                     SizedBox(
              //                       height: 5,
              //                     ),

              //                   ],
              //                 )
              //               else
              //                 SizedBox.shrink(),
              //             ],
              //           ),
              //         if (widget.model.algoId == 5)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(widget.model.histSize.toString() ?? " ",
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //             ],
              //           )
              //         else
              //           SizedBox.shrink()
              //       ],
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
