import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/AlgoController/awaitingController.dart';
import '../../controllers/AlgoController/runningController.dart';
import '../../model/AlgoModels/reportRunningAlgo_Model.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/algoWidget/search_text_widget.dart';
import '../../widget/decimal_text.dart';
import 'algo_getDetail.dart';
import 'algorithm_screen.dart';

class Running extends StatefulWidget {
  // const Await({Key? key}) : super(key: key);

  @override
  _RunningState createState() => _RunningState();
}

class _RunningState extends State<Running> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKeyRunning =
  GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    InAppSelection.algoOrderReportScreenTabIndex = 1;
    Dataconstants.runningController.fetchReportRunningAlgo();
    // Dataconstants.fetchAlgoController.fetchAlgoList();
    // InAppSelection.algoOrderReportScreenTabIndex = 1;
    // Dataconstants.itsClient.reportRunningAlgo();
    Dataconstants.isFinishedAlgoModify = false;
    Dataconstants.isAwaitingAlgoModify = false;
    Dataconstants.isFromScripDetailToAdvanceScreen = false;
    // CommonFunction.firebaselogEvent(true,"algo_running_screen","_Click","algo_running_screen");

    // //print(
    //     'isFinishedAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
  }

  @override
  void dispose() {
    // Dataconstants.reportRunningsModel.reportRunningAlgoLists.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKeyRunning,
      body: Column(
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
                              child: SearchTextWidget(
                                // function: Dataconstants.reportRunningsModel
                                //     .updateFinishedAlgoFilteredOrdersBySearch,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // if (InAppSelection.algoOrderReportScreenTabIndex != 2)
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                            onTap: () {
                              // Dataconstants.itsClient2.reportAlgo();
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Stop All'),
                                  content: const Text(
                                      'This will stop all Awaiting and Running Algos. Do you want to Proceed ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'No');
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            color: theme.primaryColor,
                                            fontSize: 17),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if(RunningController.reportRunningAlgoLists.isEmpty&&
                                            AwaitingController.reportAwaitingAlgoLists.isNotEmpty
                                        ){
                                          Dataconstants.itsClient2.stopAllAlgo();
                                          Navigator.pop(context, 'Yes');
                                        }
                                        else if(AwaitingController.reportAwaitingAlgoLists.isEmpty &&
                                            RunningController.reportRunningAlgoLists.isNotEmpty){
                                          Dataconstants.itsClient2.stopAllAlgo();
                                          Navigator.pop(context, 'Yes');
                                        }
                                        else
                                        if
                                        (AwaitingController.reportAwaitingAlgoLists.isEmpty &&
                                            RunningController.reportRunningAlgoLists.isEmpty)
                                        {
                                          Navigator.pop(context, 'Yes');
                                          {
                                            CommonFunction.showSnackBarKey(
                                              key:  _scaffoldKeyRunning,
                                              color: Colors.red,
                                              context: context,
                                              text: 'There is no remaining algo in the list',
                                            );
                                            return;
                                          }
                                        }
                                        else {
                                          Dataconstants.itsClient2.stopAllAlgo();
                                        }
                                        // Dataconstants.itsClient2.reportRunningAlgo();
                                        Dataconstants.runningController.fetchReportRunningAlgo();
                                        Dataconstants.awaitingController.fetchReportAwaitingAlgo();
                                        // Dataconstants.itsClient2.reportAlgo();
                                        Navigator.pop(context, 'Yes');
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: theme.primaryColor,
                                            fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              // CommonFunction.firebaselogEvent(true,"stop_all","_Click","stop_all");
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Stop All",
                                  // style: TextStyle(fontSize: 16),
                                  style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400,color: theme.textTheme.bodyText1.color),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.cancel,
                                )
                                // Image(
                                //   // width: MediaQuery.of(context).size.width * 0.45,
                                //   fit: BoxFit.fill,height: 25,width: 25,
                                //   image: new AssetImage(
                                //     'assets/images/iconBigul/Asset 18@4x.png',
                                //
                                //     // BrokerInfo.primaryLogo
                                //   ),
                                // ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Expanded(child:

          Obx(() {
            return RunningController.isLoading.value
                ? Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            )
                : RunningController.reportRunningAlgoLists.isEmpty ?
            RefreshIndicator(
              color: theme.primaryColor,
              onRefresh: () => Dataconstants.runningController
                  .fetchReportRunningAlgo(),
              child: SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pull down to refresh',
                          // style: TextStyle(
                          //     color: theme.textTheme.bodyText1.color),
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400,color: theme.textTheme.bodyText1.color),
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
                      padding: const EdgeInsets.only(
                          top: 250, bottom: 300),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Nothing to see here yet.\nAdd an algorithm to get started",
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400,color: Colors.grey.shade500),
                            // style: TextStyle(
                            //     color: Colors.grey[500],
                            //     fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    theme.primaryColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            40.0),
                                        side: BorderSide(
                                            color:
                                            Color(0xFF5367FC))))),
                            // key:  Dataconstants.coachMarkerKey,
                            // color: theme.primaryColor,
                            onPressed: () async {
                              setState(() {
                                Dataconstants
                                    .isFromScripDetailToAdvanceScreen =
                                false;
                                Dataconstants.isFinishedAlgoModify =
                                false;
                                Dataconstants.isAwaitingAlgoModify =
                                false;
                                // //print(
                                //     'isAwaitingAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
                                //  Dataconstants.itsClient.fetch();
                              });
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AlgorithmScreen())); // AlgorithmScreen()))    AdvanceOrder
                              // CommonFunction.firebaselogEvent(true,"add_algo","_Click","add_algo");
                            },
                            child: Container(
                                height: 40,
                                width: 90,
                                child: Center(
                                  child: Text("Add Algo",
                                    style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w600,color: Colors.white),
                                    // style: TextStyle(
                                    //     color: Colors.white,
                                    //     //Colors.grey,
                                    //     fontSize: 16,
                                    //     fontWeight:
                                    //         FontWeight.w600)
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
                : RefreshIndicator(
              color: theme.primaryColor,
              onRefresh: () => Dataconstants.runningController
                  .fetchReportRunningAlgo(),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pull down to refresh',
                          style: TextStyle(
                              color: theme.textTheme.bodyText1.color),
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
                      child: ListView.builder(
                          itemCount: RunningController
                              .reportRunningAlgoLists.length,
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
                                          builder: (context,
                                              scrollController) {
                                            return AlgoDetail(
                                                controller:
                                                scrollController,
                                                model: RunningController
                                                    .reportRunningAlgoLists[
                                                index]);
                                          });
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, left: 5, right: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 2,
                                          height: 97,
                                          color: RunningController
                                              .reportRunningAlgoLists[
                                          index]
                                              .instStatus ==
                                              "P"
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    RunningController
                                                        .reportRunningAlgoLists[
                                                    index]
                                                        .algoName,
                                                    // 'MACD$index'
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                      vertical: 3,
                                                      horizontal: 7,
                                                    ),
                                                    color: RunningController.reportRunningAlgoLists[index].algoId ==
                                                        4
                                                        ? Colors.grey
                                                        .withOpacity(
                                                        0.2)
                                                        : RunningController
                                                        .reportRunningAlgoLists[
                                                    index]
                                                        .buySell ==
                                                        "B"
                                                        ? ThemeConstants
                                                        .buyColor
                                                        .withOpacity(
                                                        0.2)
                                                        : ThemeConstants
                                                        .sellColor
                                                        .withOpacity(
                                                        0.2),
                                                    child: Text(
                                                      RunningController
                                                          .reportRunningAlgoLists[
                                                      index]
                                                          .algoId ==
                                                          4
                                                          ? "AUTO"
                                                          : RunningController.reportRunningAlgoLists[index].buySell ==
                                                          "B"
                                                          ? 'BUY'
                                                          : 'SELL',
                                                      style:
                                                      TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        color: RunningController
                                                            .reportRunningAlgoLists[
                                                        index]
                                                            .algoId ==
                                                            4
                                                            ? Colors
                                                            .grey
                                                            : RunningController.reportRunningAlgoLists[index].buySell ==
                                                            "B"
                                                            ? ThemeConstants
                                                            .buyColor
                                                            : ThemeConstants
                                                            .sellColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    top: 5,
                                                    bottom: 1),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            RunningController.reportRunningAlgoLists[index].exch == "N"
                                                                ? "NSE"
                                                                : "BSE",
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                color:
                                                                Colors.grey[600])),
                                                        SizedBox(
                                                            width: 3),
                                                        Text(
                                                            RunningController.reportRunningAlgoLists[index].exchType == "C"
                                                                ? "EQ "
                                                                : "DR ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                color:
                                                                Colors.grey[600])),
                                                        Text(
                                                          RunningController.reportRunningAlgoLists[index].exchType ==
                                                              "D"
                                                              ? ""
                                                              : ': ${RunningController.reportRunningAlgoLists[index].model.name}',
                                                          style: TextStyle(
                                                              fontSize:
                                                              13),
                                                        ),
                                                        Text(
                                                          RunningController.reportRunningAlgoLists[index].exchType ==
                                                              "C"
                                                              ? ""
                                                              : ': ${RunningController.reportRunningAlgoLists[index].desc}',
                                                          style: TextStyle(
                                                              fontSize:
                                                              13),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("LTP : ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                color:
                                                                Colors.grey[600])),
                                                        Observer(
                                                          builder: (_) => DecimalText(
                                                              RunningController.reportRunningAlgoLists[index].model.close ==
                                                                  0.0
                                                                  ? RunningController.reportRunningAlgoLists[index].model.prevDayClose.toStringAsFixed(RunningController.reportRunningAlgoLists[index].model.precision)
                                                                  : RunningController.reportRunningAlgoLists[index].model.close.toStringAsFixed(RunningController.reportRunningAlgoLists[index].model.precision),
                                                              style: TextStyle(
                                                                fontSize:
                                                                13,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color: RunningController.reportRunningAlgoLists[index].model.priceColor == 1
                                                                    ? ThemeConstants.buyColor
                                                                    : RunningController.reportRunningAlgoLists[index].model.priceColor == 2
                                                                    ? ThemeConstants.sellColor
                                                                    : theme.textTheme.bodyText1.color,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    top: 5,
                                                    bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(children: [
                                                      Text(
                                                        'Start :',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        // RunningController.reportRunningAlgoLists[index].startTime??"00.:00"
                                                        DateUtil.getDateWithFormatForAlgoDate(
                                                            RunningController
                                                                .reportRunningAlgoLists[index]
                                                                .startTime,
                                                            "dd-MM-yyyy HH:mm")
                                                            .toString(),
                                                        // Dataconstants.reportAlgoModel.reportAlgo.startTime.toString()
                                                        // 'datetime'
                                                      )
                                                    ]),
                                                    Row(
                                                      children: [
                                                        // Text('P&L'),
                                                        Text(
                                                          'End :',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          DateUtil.getDateWithFormatForAlgoDate(
                                                              RunningController.reportRunningAlgoLists[index].endTime,
                                                              "dd-MM-yyyy HH:mm")
                                                              .toString(),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                        EdgeInsets
                                                            .symmetric(
                                                          vertical: 3,
                                                          horizontal:
                                                          7,
                                                        ),
                                                        color: Colors
                                                            .cyan
                                                            .withOpacity(
                                                            0.2),
                                                        child: Text(
                                                          RunningController.reportRunningAlgoLists[index].orderType ==
                                                              "I"
                                                              ? "INTRADAY"
                                                              : RunningController.reportRunningAlgoLists[index].exchType ==
                                                              "D"
                                                              ? "NORMAL".toUpperCase()
                                                              : "DELIVERY",
                                                          style:
                                                          TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            color: Colors
                                                                .cyan,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: 5),
                                                      Container(
                                                        padding:
                                                        EdgeInsets
                                                            .symmetric(
                                                          vertical: 3,
                                                          horizontal:
                                                          7,
                                                        ),
                                                        color: theme
                                                            .primaryColor
                                                            .withOpacity(
                                                            0.2),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              RunningController.reportRunningAlgoLists[index].algoId ==
                                                                  4
                                                                  ? "Open Qty"
                                                                  : "Placed Qty",
                                                              style: TextStyle(
                                                                  color:
                                                                  theme.primaryColor),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              8,
                                                            ),
                                                            Text(
                                                              RunningController.reportRunningAlgoLists[index].placedQty.toString() ==
                                                                  "null"
                                                                  ? "0"
                                                                  : RunningController.reportRunningAlgoLists[index].placedQty.toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                  theme.primaryColor),
                                                              // '(50,20,09)'
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                        vertical: 3,
                                                        horizontal: 7,
                                                      ),
                                                      color: Colors
                                                          .amber[700]
                                                          .withOpacity(
                                                          0.2),
                                                      child: Row(
                                                          children: [
                                                            Text(
                                                              (RunningController.reportRunningAlgoLists[index].algoId ==
                                                                  4)
                                                                  ? "Max Open Qty"
                                                                  : "Total Qty",
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.amber[700]),
                                                              // 'Return'
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              10,
                                                            ),
                                                            Text(
                                                              RunningController
                                                                  .reportRunningAlgoLists[index]
                                                                  .totalQty
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.amber[700]),
                                                              // '1%'
                                                            )
                                                          ]))
                                                ],
                                              ),
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
                  ],
                ),
              ),
            );
          })

            // Observer(
            //
            //
            //     builder: (context) =>
            //     Dataconstants.reportAlgoModel.fetchingOrders == false
            //         ? Center(
            //       child: CircularProgressIndicator(
            //         valueColor:
            //         AlwaysStoppedAnimation(theme.primaryColor),
            //       ),
            //     )
            //         : RunningController.reportRunningAlgoLists.isEmpty
            //         ?
            //     RefreshIndicator(
            //       color: theme.primaryColor,
            //       onRefresh: () =>Dataconstants.itsClient.reportAlgo(),
            //       child: SingleChildScrollView(
            //         physics: NeverScrollableScrollPhysics(),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           // mainAxisSize: MainAxisSize.max,
            //           children: [
            //             Row(
            //               mainAxisAlignment:
            //               MainAxisAlignment.center,
            //               children: [
            //                 Text(
            //                   'Pull down to refresh',
            //                   style: TextStyle(color: theme.textTheme.bodyText1.color),
            //                 ),
            //                 SizedBox(
            //                   width: 3,
            //                 ),
            //                 Icon(
            //                   Icons.refresh,
            //                   size: 18,
            //                   color: theme.textTheme.bodyText1.color,
            //                 ),
            //               ],
            //             ),
            //             // SizedBox(height: 130),
            //             Padding(
            //               padding: const EdgeInsets.only(top: 250,bottom: 300),
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.max,
            //                 children: [
            //                   Text(
            //                     "Nothing to see here yet.\nAdd an algorithm to get started",
            //                     style: TextStyle(
            //                         color: Colors.grey[500],
            //                         fontSize: 15),
            //                     textAlign: TextAlign.center,
            //                   ),
            //                   SizedBox(height: 10),
            //                   ElevatedButton(
            //                     key:  Dataconstants.coachMarkerKey,
            //                     color: theme.primaryColor,
            //                     onPressed: () async {
            //                       setState(() {
            //                         Dataconstants.isFromScripDetailToAdvanceScreen =
            //                         false;
            //                         Dataconstants.isFinishedAlgoModify = false;
            //                         Dataconstants.isAwaitingAlgoModify = false;
            //                         // //print(
            //                         //     'isAwaitingAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
            //                         //  Dataconstants.itsClient.fetch();
            //                       });
            //                       Navigator.of(context).push(MaterialPageRoute(
            //                           builder: (context) =>
            //                               AlgorithmScreen())); // AlgorithmScreen()))    AdvanceOrder
            //                     },
            //                     child: Container(
            //
            //                         height: 40,
            //                         width: 90,
            //                         child:
            //                         Center(
            //                           child: Text("Add Algo",
            //                               style: TextStyle(
            //                                   color: Colors.white,
            //                                   //Colors.grey,
            //                                   fontSize: 16,
            //                                   fontWeight: FontWeight.w600)),
            //                         )
            //                     ),
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(40),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //
            //           ],
            //         ),
            //       ),
            //     )
            //         : RefreshIndicator(
            //       color: theme.primaryColor,
            //       onRefresh: () => Dataconstants.itsClient.reportAlgo(),
            //       child: Padding(
            //         padding: const EdgeInsets.only(
            //             left: 8, right: 8, bottom: 8),
            //         child: Column(
            //           crossAxisAlignment:
            //           CrossAxisAlignment.center,
            //           children: [
            //             Row(
            //               mainAxisAlignment:
            //               MainAxisAlignment.center,
            //               children: [
            //                 Text(
            //                   'Pull down to refresh',
            //                   style: TextStyle(color: theme.textTheme.bodyText1.color),
            //                 ),
            //                 SizedBox(
            //                   width: 3,
            //                 ),
            //                 Icon(
            //                   Icons.refresh,
            //                   size: 18,
            //                   color:theme.textTheme.bodyText1.color,
            //                 ),
            //               ],
            //             ),
            //             Expanded(
            //               child: ListView.builder(
            //                   itemCount: RunningController.reportRunningAlgoLists
            //                       .length,
            //                   shrinkWrap: true,
            //                   physics:
            //                   AlwaysScrollableScrollPhysics(),
            //                   itemBuilder: (context, index) {
            //                     return InkWell(
            //                       onTap: () {
            //                         showModalBottomSheet(
            //                             isScrollControlled: true,
            //                             context: context,
            //                             builder: (context) {
            //                               return DraggableScrollableSheet(
            //                                   expand: false,
            //                                   minChildSize: 0.3,
            //                                   initialChildSize:
            //                                   0.5,
            //                                   maxChildSize: 0.75,
            //                                   builder: (context, scrollController) {
            //                                     return AlgoDetail(
            //                                         controller:
            //                                         scrollController,
            //                                         model: Dataconstants
            //                                             .reportAlgoModel
            //                                             .reportAlgoLists[index]);
            //                                   });
            //                             });
            //                       },
            //                       child: Padding(
            //                         padding:
            //                         const EdgeInsets.only(
            //                             top: 12,
            //                             left: 5,
            //                             right: 5),
            //                         child: Column(
            //                           children: [
            //                             Row(
            //                               crossAxisAlignment:
            //                               CrossAxisAlignment
            //                                   .start,
            //                               children: [
            //                                 Container(
            //                                   width: 2,
            //                                   height: 97,
            //                                   color: Dataconstants
            //                                       .reportAlgoModel
            //                                       .reportAlgoLists[
            //                                   index]
            //                                       .instStatus ==
            //                                       "P"
            //                                       ? Colors.red
            //                                       : Colors.green,
            //                                 ),
            //                                 SizedBox(
            //                                   width: 8,
            //                                 ),
            //                                 Expanded(
            //                                   child: Column(
            //                                     children: [
            //                                       Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                                         children: [
            //                                           Text(
            //                                             RunningController.reportRunningAlgoLists[index].algoName,
            //                                             // 'MACD$index'
            //                                           ),
            //                                           Container(
            //                                             padding:
            //                                             EdgeInsets.symmetric(
            //                                               vertical:
            //                                               3,
            //                                               horizontal:
            //                                               7,
            //                                             ),
            //                                             color: RunningController.reportRunningAlgoLists[index].algoId ==
            //                                                 4
            //                                                 ? Colors.grey.withOpacity(0.2)
            //                                                 : RunningController.reportRunningAlgoLists[index].buySell == "B"
            //                                                 ? ThemeConstants.buyColor.withOpacity(0.2)
            //                                                 : ThemeConstants.sellColor.withOpacity(0.2),
            //                                             child:
            //                                             Text(
            //                                               RunningController.reportRunningAlgoLists[index].algoId == 4
            //                                                   ? "AUTO"
            //                                                   : RunningController.reportRunningAlgoLists[index].buySell == "B"
            //                                                   ? 'BUY'
            //                                                   : 'SELL',
            //                                               style:
            //                                               TextStyle(
            //                                                 fontWeight:
            //                                                 FontWeight.w500,
            //                                                 color: RunningController.reportRunningAlgoLists[index].algoId == 4
            //                                                     ? Colors.grey
            //                                                     : RunningController.reportRunningAlgoLists[index].buySell == "B"
            //                                                     ? ThemeConstants.buyColor
            //                                                     : ThemeConstants.sellColor,
            //                                               ),
            //                                             ),
            //                                           ),
            //
            //                                         ],),
            //                                       Padding(
            //                                         padding: const EdgeInsets.only(top: 5, bottom: 1),
            //                                         child: Row(
            //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                                           children: [
            //                                             Row(
            //                                               children: [
            //                                                 Text(Dataconstants.reportAlgoModel.reportAlgo.exch == "N" ? "NSE" : "BSE",
            //                                                     style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            //                                                 SizedBox(
            //                                                     width: 3),
            //                                                 Text(
            //                                                     RunningController.reportRunningAlgoLists[index].exchType == "C" ? "EQ " : "DR ",
            //                                                     style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            //                                                 Text(
            //                                                   RunningController.reportRunningAlgoLists[index].exchType == "D"
            //                                                       ? ""
            //                                                       : ': ${RunningController.reportRunningAlgoLists[index].model.name}',
            //                                                   style:
            //                                                   TextStyle(fontSize: 13),
            //                                                 ),
            //                                                 Text(
            //                                                   RunningController.reportRunningAlgoLists[index].exchType == "C"
            //                                                       ? ""
            //                                                       : ': ${RunningController.reportRunningAlgoLists[index].desc}',
            //                                                   style:
            //                                                   TextStyle(fontSize: 13),
            //                                                 ),
            //                                               ],
            //                                             ),
            //                                             Row(
            //                                               children: [
            //                                                 Text(
            //                                                     "LTP : "
            //                                                     ,
            //                                                     style: TextStyle(fontSize: 13, color: Colors.grey[600])
            //                                                 ),
            //                                                 Observer(
            //                                                   builder: (_) =>
            //                                                       DecimalText(
            //                                                           RunningController.reportRunningAlgoLists[index].model.close == 0.0
            //                                                               ? RunningController.reportRunningAlgoLists[index].model.prevDayClose
            //                                                               .toStringAsFixed(
            //                                                               RunningController.reportRunningAlgoLists[index].model.precision) : RunningController.reportRunningAlgoLists[index].model.close
            //                                                               .toStringAsFixed(
            //                                                               RunningController.reportRunningAlgoLists[index].model.precision),
            //                                                           style: TextStyle(
            //                                                             fontSize: 13,
            //                                                             fontWeight: FontWeight.bold,
            //                                                             color: RunningController.reportRunningAlgoLists[index].model.priceColor == 1
            //                                                                 ? ThemeConstants.buyColor
            //                                                                 : RunningController.reportRunningAlgoLists[index].model.priceColor == 2
            //                                                                 ? ThemeConstants.sellColor
            //                                                                 : theme.textTheme.bodyText1.color,
            //                                                           )),
            //                                                 ),
            //                                               ],
            //                                             ),
            //
            //                                           ],
            //                                         ),
            //                                       ),
            //                                       Padding(
            //                                         padding: const EdgeInsets
            //                                             .only(
            //                                             top: 5,
            //                                             bottom:
            //                                             5),
            //                                         child: Row(
            //                                           mainAxisAlignment:
            //                                           MainAxisAlignment
            //                                               .spaceBetween,
            //                                           children: [
            //                                             Row(
            //                                                 children: [
            //                                                   Text(
            //                                                     'Start :',
            //                                                     style: TextStyle(color: Colors.grey),
            //                                                   ),
            //                                                   SizedBox(
            //                                                     width: 8,
            //                                                   ),
            //                                                   Text(
            //                                                     // RunningController.reportRunningAlgoLists[index].startTime??"00.:00"
            //                                                     DateUtil.getDateWithFormatForAlgoDate(RunningController.reportRunningAlgoLists[index].startTime, "dd-MM-yyyy HH:mm").toString(),
            //                                                     // Dataconstants.reportAlgoModel.reportAlgo.startTime.toString()
            //                                                     // 'datetime'
            //                                                   )
            //                                                 ]),
            //                                             Row(
            //                                               children: [
            //                                                 // Text('P&L'),
            //                                                 Text(
            //                                                   'End :',
            //                                                   style:
            //                                                   TextStyle(color: Colors.grey),
            //                                                 ),
            //                                                 SizedBox(
            //                                                   width:
            //                                                   8,
            //                                                 ),
            //                                                 Text(
            //                                                   DateUtil.getDateWithFormatForAlgoDate(RunningController.reportRunningAlgoLists[index].endTime, "dd-MM-yyyy HH:mm").toString(),
            //                                                 )
            //                                               ],
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                       Row(
            //                                         mainAxisAlignment:
            //                                         MainAxisAlignment
            //                                             .spaceBetween,
            //                                         children: [
            //                                           Row(
            //                                             children: [
            //                                               Container(
            //                                                 padding:
            //                                                 EdgeInsets.symmetric(
            //                                                   vertical:
            //                                                   3,
            //                                                   horizontal:
            //                                                   7,
            //                                                 ),
            //                                                 color: Colors
            //                                                     .cyan
            //                                                     .withOpacity(0.2),
            //                                                 child:
            //                                                 Text(
            //                                                   RunningController.reportRunningAlgoLists[index].orderType == "I"
            //                                                       ? "INTRADAY"
            //                                                       : RunningController.reportRunningAlgoLists[index].exchType == "D"
            //                                                       ?"NORMAL".toUpperCase()
            //                                                       :"DELIVERY",
            //                                                   style:
            //                                                   TextStyle(
            //                                                     fontWeight: FontWeight.w500,
            //                                                     color: Colors.cyan,),),),
            //                                               SizedBox(width: 5),
            //                                               Container(
            //                                                 padding: EdgeInsets.symmetric(
            //                                                   vertical:
            //                                                   3,
            //                                                   horizontal:
            //                                                   7,
            //                                                 ),
            //                                                 color: theme
            //                                                     .primaryColor
            //                                                     .withOpacity(0.2),
            //                                                 child:
            //                                                 Row(
            //                                                   children: [
            //                                                     Text(
            //                                                       RunningController.reportRunningAlgoLists[index].algoId == 4 ? "Open Qty" : "Placed Qty",
            //                                                       style: TextStyle(color: theme.primaryColor),
            //                                                     ),
            //                                                     SizedBox(
            //                                                       width: 8,
            //                                                     ),
            //                                                     Text(
            //                                                       RunningController.reportRunningAlgoLists[index].placedQty.toString()=="null"
            //                                                           ?"0":RunningController.reportRunningAlgoLists[index].placedQty.toString(),
            //                                                       style: TextStyle(color: theme.primaryColor),
            //                                                       // '(50,20,09)'
            //                                                     ),
            //                                                   ],
            //                                                 ),
            //                                               ),
            //                                             ],
            //                                           ),
            //                                           Container(
            //                                               padding:
            //                                               EdgeInsets
            //                                                   .symmetric(
            //                                                 vertical:
            //                                                 3,
            //                                                 horizontal:
            //                                                 7,
            //                                               ),
            //                                               color: Colors
            //                                                   .amber[
            //                                               700]
            //                                                   .withOpacity(
            //                                                   0.2),
            //                                               child: Row(
            //                                                   children: [
            //                                                     Text(
            //                                                       (RunningController.reportRunningAlgoLists[index].algoId == 4) ? "Max Open Qty" : "Total Qty",
            //                                                       style: TextStyle(color: Colors.amber[700]),
            //                                                       // 'Return'
            //                                                     ),
            //                                                     SizedBox(
            //                                                       width: 10,
            //                                                     ),
            //                                                     Text(
            //                                                       RunningController.reportRunningAlgoLists[index].totalQty.toString(),
            //                                                       style: TextStyle(color: Colors.amber[700]),
            //                                                       // '1%'
            //                                                     )
            //                                                   ]))
            //                                         ],
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                             SizedBox(height: 17),
            //                             Divider(
            //                               height: 2,
            //                               thickness: 1.2,
            //                               color:
            //                               theme.dividerColor,
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     );
            //                   }),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )
            //
            // ),
          ),
          // Expanded(
          //   child: Observer(
          //       builder:
          //           (context) =>
          //       Dataconstants.reportRunningsModel.fetchingOrders ==
          //           false
          //           ? Center(
          //         child: CircularProgressIndicator(
          //           valueColor: AlwaysStoppedAnimation(
          //               theme.primaryColor),
          //         ),
          //       )
          //           : Dataconstants.reportRunningsModel.reportRunningAlgoLists.isEmpty
          //           ?
          //       RefreshIndicator(
          //         color: theme.primaryColor,
          //         onRefresh: () => Dataconstants.itsClient.reportRunningAlgo(),
          //         child: SingleChildScrollView(
          //           physics: NeverScrollableScrollPhysics(),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             // mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Row(
          //                 mainAxisAlignment:
          //                 MainAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     'Pull down to refresh',
          //                     style: TextStyle(color: theme.textTheme.bodyText1.color),
          //                   ),
          //                   SizedBox(
          //                     width: 3,
          //                   ),
          //                   Icon(
          //                     Icons.refresh,
          //                     size: 18,
          //                     color: theme.textTheme.bodyText1.color,
          //                   ),
          //                 ],
          //               ),
          //               // SizedBox(height: 130),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 250,bottom: 300),
          //                 child: Column(
          //                   children: [
          //                     Text(
          //                       "Nothing to see here yet.\nAdd an algorithm to get started",
          //                       style: TextStyle(
          //                           color: Colors.grey[500],
          //                           fontSize: 15),
          //                       textAlign: TextAlign.center,
          //                     ),
          //                     SizedBox(height: 10),
          //                     RaisedButton(
          //                       color: theme.primaryColor,
          //                       onPressed: ()  async {
          //                         setState(() {
          //                           Dataconstants.isFromScripDetailToAdvanceScreen =
          //                           false;
          //                           Dataconstants.isFinishedAlgoModify = false;
          //                           Dataconstants.isAwaitingAlgoModify = false;
          //                           // //print(
          //                           //     'isAwaitingAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
          //                           //  Dataconstants.itsClient.fetch();
          //                         });
          //                         Navigator.of(context).push(MaterialPageRoute(
          //                             builder: (context) =>
          //                                 AlgorithmScreen())); // AlgorithmScreen()))    AdvanceOrder
          //                       },
          //                       child: Container(
          //                           height: 40,
          //                           width: 90,
          //                           child:
          //                           Center(
          //                             child: Text("Add Algo",
          //                                 style: TextStyle(
          //                                     color: Colors.white,
          //                                     //Colors.grey,
          //                                     fontSize: 16,
          //                                     fontWeight: FontWeight.w600)),
          //                           )
          //                       ),
          //                       shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(40),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //
          //             ],
          //           ),
          //         ),
          //       )
          //           : RefreshIndicator(
          //         color: theme.primaryColor,
          //         onRefresh: () => Dataconstants.itsClient.reportRunningAlgo(),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Row(
          //               mainAxisAlignment:
          //               MainAxisAlignment.center,
          //               children: [
          //                 Text(
          //                   'Pull down to refresh',
          //                   style: TextStyle(color: theme.textTheme.bodyText1.color),
          //                 ),
          //                 SizedBox(
          //                   width: 3,
          //                 ),
          //                 Icon(
          //                   Icons.refresh,
          //                   size: 18,
          //                   color: theme.textTheme.bodyText1.color,
          //                 ),
          //               ],
          //             ),
          //             Expanded(
          //               child: Padding(
          //                 padding: const EdgeInsets.only(
          //                     left: 8, right: 8, bottom: 8),
          //                 child: ListView.builder(
          //                     itemCount: Dataconstants
          //                         .reportRunningsModel
          //                         .reportRunningAlgoLists
          //                         .length,
          //                     shrinkWrap: true,
          //                     physics:
          //                     AlwaysScrollableScrollPhysics(),
          //                     itemBuilder: (context, index) {
          //                       return InkWell(
          //                         onTap: () {
          //                           showModalBottomSheet(
          //                               isScrollControlled:
          //                               true,
          //                               context: context,
          //                               builder: (context) {
          //                                 return DraggableScrollableSheet(
          //                                     expand: false,
          //                                     minChildSize:
          //                                     0.3,
          //                                     initialChildSize:
          //                                     0.5,
          //                                     maxChildSize:
          //                                     0.75,
          //                                     builder: (context,
          //                                         scrollController) {
          //                                       return AlgoDetail(
          //                                           controller:
          //                                           scrollController,
          //                                           model: Dataconstants
          //                                               .reportRunningsModel
          //                                               .reportRunningAlgoLists[index]);
          //                                     });
          //                               });
          //                           // showModalBottomSheet(
          //                           //     isScrollControlled: true,
          //                           //     context: context,
          //                           //     builder: (context) {
          //                           //       return AlgoDetail(
          //                           //           model: Dataconstants
          //                           //                   .reportRunningsModel
          //                           //                   .reportRunningAlgoLists[
          //                           //               index]);
          //                           //     });
          //                         },
          //                         child: Padding(
          //                           padding:
          //                           const EdgeInsets.only(
          //                               top: 12,
          //                               left: 5,
          //                               right: 5),
          //                           child: Column(
          //                             children: [
          //                               Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                 children: [
          //                                   Text(
          //                                     Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].algoName,
          //                                     style: TextStyle(
          //                                         fontSize:
          //                                         17),
          //                                     // 'MACD$index'
          //                                   ),
          //                                   Container(
          //                                     padding: EdgeInsets
          //                                         .symmetric(
          //                                       vertical: 3,
          //                                       horizontal: 7,
          //                                     ),
          //                                     color: Dataconstants
          //                                         .reportRunningsModel
          //                                         .reportRunningAlgoLists[
          //                                     index]
          //                                         .algoId ==
          //                                         4
          //                                         ? Colors
          //                                         .grey
          //                                         .withOpacity(
          //                                         0.2)
          //                                         : Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].buySell ==
          //                                         "B"
          //                                         ? ThemeConstants
          //                                         .buyColor
          //                                         .withOpacity(
          //                                         0.2)
          //                                         : ThemeConstants
          //                                         .sellColor
          //                                         .withOpacity(0.2),
          //                                     child: Text(
          //                                       Dataconstants
          //                                           .reportRunningsModel
          //                                           .reportRunningAlgoLists[
          //                                       index]
          //                                           .algoId ==
          //                                           4
          //                                           ? "AUTO"
          //                                           : Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].buySell ==
          //                                           "B"
          //                                           ? 'BUY'
          //                                           : 'SELL',
          //                                       style:
          //                                       TextStyle(
          //                                         fontWeight:
          //                                         FontWeight
          //                                             .w500,
          //                                         color: Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].algoId ==
          //                                             4
          //                                             ? Colors
          //                                             .grey
          //                                             : Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].buySell ==
          //                                             "B"
          //                                             ? ThemeConstants.buyColor
          //                                             : ThemeConstants.sellColor,
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                               Padding(
          //                                 padding:  EdgeInsets.only(top: 5, bottom: 5),
          //                                 child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     Row(children: [
          //                                       Text(
          //                                         Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].exch ==
          //                                             "N"
          //                                             ? "NSE"
          //                                             : "BSE",
          //                                         style: TextStyle(
          //                                             fontSize:
          //                                             13,
          //                                             color:
          //                                             Colors.grey[600]),
          //                                       ),
          //                                       SizedBox(
          //                                           width:
          //                                           3),
          //                                       Text(
          //                                         Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].exchType ==
          //                                             "C"
          //                                             ? "EQ "
          //                                             : "DR ",
          //                                         style: TextStyle(
          //                                             fontSize:
          //                                             13,
          //                                             color:
          //                                             Colors.grey[600]),
          //                                       ),
          //                                       Text(
          //                                         Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].exchType ==
          //                                             "C"
          //                                             ? ': ${Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].model.name}'
          //                                             : '',
          //                                         style: TextStyle(
          //                                             fontSize:
          //                                             13),
          //                                       ),
          //                                       SizedBox(
          //                                         width: 3,
          //                                       ),
          //                                       Text(
          //                                         Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].exchType ==
          //                                             "D"
          //                                             ? ': ${Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].desc}'
          //                                             : '',
          //                                         style: TextStyle(
          //                                             fontSize:
          //                                             13),
          //                                       ),
          //                                     ],),
          //                                     Row(
          //                                       children: [
          //                                         Text(
          //                                             "LTP : "
          //                                             ,
          //                                             style: TextStyle(fontSize: 13, color: Colors.grey[600])
          //                                         ),
          //                                         Observer(
          //                                           builder: (_) =>
          //                                               DecimalText(
          //                                                   Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].model.close == 0.0
          //                                                       ? Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].model.prevDayClose
          //                                                       .toStringAsFixed(
          //                                                       Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].model.precision) : Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].model.close
          //                                                       .toStringAsFixed(
          //                                                       Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].model.precision),
          //                                                   style: TextStyle(
          //                                                     fontSize: 13,
          //                                                     fontWeight: FontWeight.bold,
          //                                                     color: Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].model.priceColor == 1
          //                                                         ? ThemeConstants.buyColor
          //                                                         : Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].model.priceColor == 2
          //                                                         ? ThemeConstants.sellColor
          //                                                         : theme.textTheme.bodyText1.color,
          //                                                   )),
          //                                         ),
          //                                       ],
          //                                     ),
          //
          //
          //                                   ],
          //                                 ),
          //                               ),
          //                               Row(
          //                                 children: [
          //                                   Row(children: [
          //                                     Text(
          //                                       'Start :',
          //                                       style: TextStyle(
          //                                           color: Colors
          //                                               .grey),
          //                                     ),
          //                                     SizedBox(
          //                                       width: 8,
          //                                     ),
          //                                     Text(
          //                                       DateUtil.getDateWithFormatForAlgoDate(
          //                                           Dataconstants
          //                                               .reportRunningsModel
          //                                               .reportRunningAlgoLists[index]
          //                                               .startTime,
          //                                           "dd-MM-yyyy HH:mm")
          //                                           .toString(),
          //                                     )
          //                                   ]),
          //                                   Spacer(),
          //                                   Padding(
          //                                     padding:
          //                                     const EdgeInsets
          //                                         .only(
          //                                         top: 7,
          //                                         bottom:
          //                                         7),
          //                                     child: Row(
          //                                       children: [
          //                                         // Text('P&L'),
          //                                         Text(
          //                                           'End :',
          //                                           style: TextStyle(
          //                                               color:
          //                                               Colors.grey),
          //                                         ),
          //                                         SizedBox(
          //                                           width: 8,
          //                                         ),
          //                                         Text(
          //                                           DateUtil.getDateWithFormatForAlgoDate(
          //                                               Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].endTime,
          //                                               "dd-MM-yyyy HH:mm")
          //                                               .toString(),
          //                                         )
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                               Row(
          //                                 children: [
          //                                   Row(
          //                                     children: [
          //                                       Container(
          //                                         padding:
          //                                         EdgeInsets
          //                                             .symmetric(
          //                                           vertical:
          //                                           3,
          //                                           horizontal:
          //                                           7,
          //                                         ),
          //                                         color: Colors
          //                                             .cyan
          //                                             .withOpacity(
          //                                             0.2),
          //                                         child: Text(
          //                                           Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].orderType ==
          //                                               "I"
          //                                               ? "INTRADAY"
          //                                               : Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].exchType== "D"
          //                                               ? "NORMAL".toUpperCase()
          //                                               : "DELIVERY",
          //                                           style:
          //                                           TextStyle(
          //                                             fontWeight:
          //                                             FontWeight.w500,
          //                                             color: Colors
          //                                                 .cyan,
          //                                           ),
          //                                         ),
          //                                       ),
          //                                       SizedBox(
          //                                           width: 5),
          //                                       Container(
          //                                         padding:
          //                                         EdgeInsets
          //                                             .symmetric(
          //                                           vertical:
          //                                           3,
          //                                           horizontal:
          //                                           7,
          //                                         ),
          //                                         color: theme
          //                                             .primaryColor
          //                                             .withOpacity(
          //                                             0.2),
          //                                         child: Row(
          //                                           children: [
          //                                             Text(
          //                                               Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].algoId == 4
          //                                                   ? "Open Qty"
          //                                                   : "Placed Qty",
          //                                               style:
          //                                               TextStyle(color: theme.primaryColor),
          //                                               // '(50,20,09)'
          //                                             ),
          //                                             SizedBox(
          //                                               width:
          //                                               8,
          //                                             ),
          //                                             Text(
          //                                               Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].placedQty.toString()=="null"?
          //                                               "0"
          //                                                   :Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].placedQty.toString(),
          //                                               style:
          //                                               TextStyle(color: theme.primaryColor),
          //                                               // '(50,20,09)'
          //                                             ),
          //                                           ],
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   Spacer(),
          //                                   Container(
          //                                     padding: EdgeInsets
          //                                         .symmetric(
          //                                       vertical: 3,
          //                                       horizontal: 7,
          //                                     ),
          //                                     color: Colors
          //                                         .amber[700]
          //                                         .withOpacity(
          //                                         0.2),
          //                                     child: Row(
          //                                       children: [
          //                                         Text(
          //                                           Dataconstants.reportRunningsModel.reportRunningAlgoLists[index].algoId ==
          //                                               4
          //                                               ? "Max Open Qty"
          //                                               : "Total Qty",
          //                                           style: TextStyle(
          //                                               color:
          //                                               Colors.amber[700]),
          //                                           // 'Return'
          //                                         ),
          //                                         SizedBox(
          //                                           width: 10,
          //                                         ),
          //                                         Text(
          //                                           Dataconstants
          //                                               .reportRunningsModel
          //                                               .reportRunningAlgoLists[
          //                                           index]
          //                                               .totalQty
          //                                               .toString(),
          //                                           style: TextStyle(
          //                                               color:
          //                                               Colors.amber[700]),
          //                                           // '1%'
          //                                         )
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                               SizedBox(
          //                                 height: 17,
          //                               ),
          //                               Divider(
          //                                 height: 2,
          //                                 thickness: 1.2,
          //                                 color: theme
          //                                     .dividerColor,
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       );
          //                     }),
          //               ),
          //             ),
          //           ],
          //         ),
          //       )),
          // ),
        ],
      ),
    );
  }
}

class AlgoDetail extends StatefulWidget {
  final ReportRunningAlgo model;
  ScrollController controller;

  AlgoDetail({this.model, this.controller});

//  const ({Key? key}) : super(key: key);

  @override
  _AlgoDetailState createState() => _AlgoDetailState(model, controller);
}

class _AlgoDetailState extends State<AlgoDetail> {
  _AlgoDetailState(ReportRunningAlgo model, ScrollController controller);

  int instructionDateConverted;
  List<dynamic> comments = [];
  String name;
  int algoId;
  String algoPhrase;
  String algoType;
  String algoSegment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var instructionDate =
    DateUtil.getAnyFormattedDate(DateTime.now(), "dd-MMM-yyyy hh:mm:ss");

    //print('insTructionTime pass sdfdsf = $instructionDate');
    instructionDateConverted = DateUtil.getIntFromDate1(instructionDate);
    //print(
    //     'insTructionTime pass Converted to integer = $instructionDateConverted');

    // Dataconstants.itsClient2.reportRunningAlgo();
    Dataconstants.isFinishedAlgoModify = false;
    Dataconstants.isAwaitingAlgoModify = false;
    Dataconstants.isFromScripDetailToAdvanceScreen = false;
    //print(
    //     'isFinishedAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      controller: widget.controller,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          //  height: 410,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FractionallySizedBox(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    widthFactor: 0.25,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:theme.primaryColor,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                        side: BorderSide(

                            width: 1.0,
                            color: theme.primaryColor,
                            style: BorderStyle.solid),
                      ),
                      // color: theme.primaryColor,
                      onPressed: () async {
                        await Dataconstants.itsClient2.stoptAlgo(
                          instructionId: widget.model.instId,
                        );
                        await Dataconstants.runningController
                            .fetchReportRunningAlgo();
                        // Dataconstants.itsClient.reportRunningAlgo();
                        Navigator.pop(context);
                        // CommonFunction.firebaselogEvent(true,"algo_stop","_Click","algo_stop");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        // height: 40,
                        // width: 90,
                        child: Row(
                          children: [
                            Icon(
                              Icons.not_started_outlined,
                              size: 30,
                              color: Colors.white, // Colors.grey,
                            ),
                            SizedBox(width: 8),
                            Text("Stop",
                                style: TextStyle(
                                    color: Colors.white,
                                    //Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),
                    ),
                    //  Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(theme.primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  side: BorderSide(color: Color(0xFF5367FC))))),
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                      // color: theme.primaryColor,
                      onPressed: () async {
                        await Dataconstants.itsClient2.pauseAlgo(
                          instructionId: widget.model.instId,
                        );
                        if (Dataconstants.pauseAlgoStatus == "Success") {
                          CommonFunction.showBasicToast('Algo Pause');
                        }
                        await Dataconstants.runningController
                            .fetchReportRunningAlgo();
                        // await Dataconstants.itsClient.reportRunningAlgo();
                        // CommonFunction.firebaselogEvent(true,"algo_pause","_Click","algo_pause");
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        // height: 40,
                        // width: 85,
                        child: Row(
                          children: [
                            Icon(
                              Icons.pause_circle_outline,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text("Pause",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        // Navigator.pop(context);
                        var tempModel = CommonFunction.getScripDataModel(
                            exch: widget.model.exch,
                            exchCode: widget.model.scripCode,
                            getNseBseMap: true);
                        // Dataconstants.algoLogModel.algoLogLists.clear();
                        await Dataconstants.itsClient2.algoLog(
                          instructionId: widget.model.instId,
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlgoGetDetail(
                                    modifyModel: tempModel,
                                    instructionId: widget.model.instId,
                                    buySel: widget.model.buySell)
                            ));
                        // CommonFunction.firebaselogEvent(true,"algo_log","_Click","algo_log");
                      },

                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
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
                    // Spacer(),
                    // OutlineButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //
                    //     if (widget.model.algoId == 1) {
                    //       name = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[0].algoName;
                    //       algoId = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[0].algoId;
                    //       algoPhrase = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[0].algoPhrase;
                    //       algoType = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[0].algoType;
                    //       algoSegment = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[0].algoSegment;
                    //     } else if (widget.model.algoId == 2) {
                    //       name = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[1].algoName;
                    //       algoId = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[1].algoId;
                    //       algoPhrase = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[1].algoPhrase;
                    //       algoType = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[1].algoType;
                    //       algoSegment = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[1].algoSegment;
                    //     } else if (widget.model.algoId == 3) {
                    //       name = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[2].algoName;
                    //       algoId = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[2].algoId;
                    //       algoPhrase = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[2].algoPhrase;
                    //       algoType = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[2].algoType;
                    //       algoSegment = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[2].algoSegment;
                    //     } else if (widget.model.algoId == 4) {
                    //       name = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[3].algoName;
                    //       algoId = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[3].algoId;
                    //       algoPhrase = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[3].algoPhrase;
                    //       algoType = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[3].algoType;
                    //       algoSegment = Dataconstants
                    //           .fetchAlgoListsNew.fetchAlgoLists[3].algoSegment;
                    //     }
                    //
                    //     var tempModel = CommonFunction.getScripDataModel(
                    //         exch: widget.model.exch,
                    //         exchCode: widget.model.scripCode,
                    //         getNseBseMap: true);
                    //
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => AdvanceOrder(
                    //               name: name,
                    //               id: algoId,
                    //               phrase: algoPhrase,
                    //               type: algoType,
                    //               segment: algoSegment,
                    //               modifyModel: tempModel,
                    //             )));
                    //
                    //     setState(() {
                    //       Dataconstants.isRunningAlgoModify = true;
                    //       Dataconstants.runningAlgoToAdvanceScreen = widget.model;
                    //     });
                    //   },
                    //   borderSide: BorderSide(
                    //     color: theme.primaryColor,
                    //     style: BorderStyle.solid,
                    //   ),
                    //   disabledBorderColor: Theme.of(context).dividerColor,
                    //   child: Container(
                    //       height: 40,
                    //       width: 80,
                    //       child: Align(
                    //           alignment: Alignment.center,
                    //           child: Text("Modify",
                    //               style: TextStyle(
                    //                   color: theme.primaryColor,
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w400)))),
                    // )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration: BoxDecoration(
                      color: ThemeConstants.themeMode.value == ThemeMode.light
                          ? Colors.grey.shade200
                          : Colors.blueGrey[900]),
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
                            Text(
                                DateUtil.getDateWithFormatForAlgoDate(
                                    widget.model.startTime, "dd-MM-yyyy HH:mm")
                                    .toString(),
                                // widget.model.startTime??"00:00",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: theme.textTheme.bodyText1.color,
                                )),
                            Text(
                                DateUtil.getDateWithFormatForAlgoDate(
                                    widget.model.endTime, "dd-MM-yyyy HH:mm")
                                    .toString(),
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
                    Text(widget.model.algoId == 4 ? "Max Open Qty" : "Total Qty",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
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
                    Text(
                        widget.model.algoId == 3 || widget.model.algoId == 4
                            ? "Averaging Qty"
                            : "Slice Qty",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
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
                    Text("Sent Qty",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
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
                    Text((widget.model.algoId != 4) ? "Placed Qty" : "Open Qty",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
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
                          Text("Rejected Qty",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
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
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: theme.textTheme.bodyText1.color),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Traded Qty',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
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
                    Text('Rejected Qty',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
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
                    Text('Pending Qty',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
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
                if (widget.model.algoId == 3 ||
                    widget.model.algoId == 4 ||
                    widget.model.algoId == 2)
                  Column(
                    children: [
                      Text(
                        "Price :",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: theme.textTheme.bodyText1.color),
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
                          Text("Price Range High",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
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
                          Text("Price Range Low",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
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
                          Text("Avg Start Price",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
                          Text(
                              widget.model.atMarket == "M"
                                  ? "Mkt"
                                  : widget.model.avgLimitPrice.toString() ?? " ",
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
                          Text("Avg Entry Diff",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
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
                                Text("Avg Exit Diff",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey)),
                                Text(
                                    widget.model.avgExitDiff.toStringAsFixed(2) ??
                                        " ",
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
                          Text("Avg Direction",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
                          Text(
                              widget.model.avgDirection == "D"
                                  ? "Down"
                                  : "Up" ?? " ",
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
                          Text("Time Interval",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
                          Text(
                              DateUtil.getDateWithFormatForAlgoDate(
                                  widget.model.timeInterval,
                                  "dd-MM-yyyy HH:mm:ss")
                                  .toString()
                                  .split(' ')[1]
                                  .split(".")[0],
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
              ],
            )),
      ),
    );
  }
}
