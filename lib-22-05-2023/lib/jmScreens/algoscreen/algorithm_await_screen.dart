import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/AlgoController/awaitingController.dart';
import '../../controllers/AlgoController/runningController.dart';
import '../../model/AlgoModels/reportAlgo_Model.dart';
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

class Await extends StatefulWidget {
  // const Await({Key? key}) : super(key: key);

  @override
  _AwaitState createState() => _AwaitState();
}

class _AwaitState extends State<Await> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var awaitReportModel;

  @override
  void initState() {
    super.initState();
    InAppSelection.algoOrderReportScreenTabIndex = 0;
    Dataconstants.awaitingController.fetchReportAwaitingAlgo();
    // Dataconstants.fetchAlgoController.fetchAlgoList();
    //***************************************
    // Dataconstants.itsClient.fetch();
    // Dataconstants.itsClient.reportAlgo();
    Dataconstants.isFromScripDetailToAdvanceScreen = false;
    Dataconstants.isFinishedAlgoModify = false;
    Dataconstants.isAwaitingAlgoModify = false;

    // CommonFunction.firebaselogEvent(true,"algo_await_screen","_Click","algo_await_screen");

    // //print(
    //     'isFinishedAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
    //if(AwaitingController.reportAwaitingAlgoLists.length!=0&&Dataconstants.fetchAlgoModel.fetchAlgoLists.length!=0)
    // for(var i =0;i<=AwaitingController.reportAwaitingAlgoLists.length; i++){
    //   for(var j=0; j<=Dataconstants.fetchAlgoModel.fetchAlgoLists.length;j++){
    //     if(AwaitingController.reportAwaitingAlgoLists[i].algoId==Dataconstants.fetchAlgoModel.fetchAlgoLists[j].algoId){
    //
    //       Dataconstants.awaitReportModel=Dataconstants.fetchAlgoModel;
    //
    //     }
    //   }
    // }
  }

  @override
  void dispose() {
    AwaitingController.reportAwaitingAlgoLists.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
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
                            // Container(
                            //   margin: EdgeInsets.only(
                            //     left: 10,
                            //     right: 10,
                            //     top: 5,
                            //   ),
                            //   child: GestureDetector(
                            //     behavior: HitTestBehavior.opaque,
                            //     onTap: () async {
                            //       var dateMap = await showModalBottomSheet<
                            //           Map<String, String>>(
                            //         context: context,
                            //         builder: (context) => DatePickerSheet(
                            //           InAppSelection.orderBookFromDate,
                            //           InAppSelection.orderBookToDate,
                            //         ),
                            //       );
                            //       if (dateMap != null) {
                            //         setState(() {
                            //           InAppSelection.orderBookFromDate =
                            //           dateMap['from'];
                            //           InAppSelection.orderBookToDate =
                            //           dateMap['to'];
                            //         });
                            //         Dataconstants.itsClient.reportAlgo();
                            //       }
                            //     },
                            //     child: Container(
                            //       margin: EdgeInsets.only(
                            //         left: 10,
                            //         right: 10,
                            //         bottom: 5,
                            //       ),
                            //       child: Row(
                            //         children: [
                            //           Icon(
                            //             Icons.date_range,
                            //             color: Colors.grey[600],
                            //           ),
                            //           SizedBox(width: 15),
                            //           FittedBox(
                            //             fit: BoxFit.scaleDown,
                            //             child: Text(
                            //               'From : ${InAppSelection.orderBookFromDate} To : ${InAppSelection.orderBookToDate}',
                            //               style: TextStyle(
                            //                   fontSize: MediaQuery.of(context)
                            //                       .size
                            //                       .width *
                            //                       0.032),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SearchTextWidget(
                                // function: Dataconstants.reportAlgoModel.updateawaitAlgoFilteredOrdersBySearch,
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
                              // Dataconstants.awaitingController.fetchReportAwaitingAlgo();
                              Dataconstants.runningController.fetchReportRunningAlgo();
                              // Dataconstants.itsClient.reportRunningAlgo();
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text('Stop All',
                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400,color: theme.textTheme.bodyText1.color),),
                                  content: const Text('This will stop all Awaiting and Running Algos. Do you want to Proceed ?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'No');
                                      },
                                      child:  Text(
                                        'No',
                                        style: TextStyle(
                                            color: theme.primaryColor,
                                            fontSize: 17),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (
                                        RunningController.reportRunningAlgoLists.isEmpty &&
                                            AwaitingController.reportAwaitingAlgoLists.isEmpty
                                        )
                                        {
                                          Navigator.pop(context, 'Yes');
                                          {
                                            CommonFunction.showSnackBarKey(
                                              // key: _scaffoldKey,
                                              color: Colors.red,
                                              context: context,
                                              text:
                                              'There is no remaining algo in the list',
                                            );

                                          }
                                        }
                                        {
                                          Dataconstants.itsClient2.stopAllAlgo();
                                        }
                                        Dataconstants.awaitingController.fetchReportAwaitingAlgo();
                                        Dataconstants.runningController.fetchReportRunningAlgo();
                                        // Dataconstants.itsClient2.reportAlgo();
                                        // Dataconstants.itsClient2.reportRunningAlgo();
                                        Navigator.pop(context, 'Yes');
                                      },
                                      child:  Text(
                                        'Yes',
                                        style: TextStyle(
                                            color:  theme.primaryColor,
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
                                Text("Stop All"),
                                SizedBox(width: 8,),
                                Icon(Icons.cancel)
                                // Image(
                                //   // width: MediaQuery.of(context).size.width * 0.45,
                                //   fit: BoxFit.fill,height: 25,width: 25,
                                //     'assets/images/iconBigul/Asset 18@4x.png',
                                //   image: new AssetImage(
                                //
                                //     // BrokerInfo.primaryLogo
                                //   ),
                                // ),
                                // Icon(
                                //   Icons.stop_circle_outlined,
                                //   color: Colors.red,
                                //   size: 30,
                                // ),
                              ],
                            )),
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.sort_rounded),
                      //   onPressed: () {
                      //     FocusManager.instance.primaryFocus.unfocus();
                      //     showModalBottomSheet<void>(
                      //       context: context,
                      //       isScrollControlled: true,
                      //       builder: (BuildContext context) {
                      //         return AwaitAlgoReportFilter(Dataconstants
                      //             .reportAlgoModel
                      //             .getAwaitingAlgoFilterMap());
                      //       },
                      //     );
                      //   },
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
          //   if (Dataconstants
          //       .reportAlgoModel.currentAlgoAwaitingFilters.length >
          //       0)
          //     return Container(
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       alignment: Alignment.centerLeft,
          //       child: Wrap(
          //         spacing: 10,
          //         children:
          //         Dataconstants.reportAlgoModel.currentAlgoAwaitingFilters
          //             .map(
          //               (e) => FilterChip(
          //             label: Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Text(e),
          //                 SizedBox(width: 3),
          //                 Icon(
          //                   Icons.close,
          //                   size: 18,
          //                 ),
          //               ],
          //             ),
          //             onSelected: (value) {
          //               Dataconstants.reportAlgoModel
          //                   .updateAwaitAlgoReportFilter(e);
          //             },
          //           ),
          //         )
          //             .toList(),
          //       ),
          //     );
          //   else
          //     return SizedBox.shrink();
          // }),
          Expanded(
              child:
              Obx((){
                return  AwaitingController.isLoading.value
                    ? Center(
                  child: CircularProgressIndicator(color: theme.primaryColor,),)
                    : AwaitingController.reportAwaitingAlgoLists.isEmpty ?
                RefreshIndicator(
                  color: theme.primaryColor,
                  onRefresh: () =>Dataconstants.awaitingController.fetchReportAwaitingAlgo(),
                  child: SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pull down to refresh',
                              // style: TextStyle(color: theme.textTheme.bodyText1.color),
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
                          padding: const EdgeInsets.only(top: 250,bottom: 300),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Nothing to see here yet.\nAdd an algorithm to get started",
                                // style: TextStyle(
                                //     color: Colors.grey[500],
                                //     fontSize: 15),
                                style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400,color: Colors.grey.shade500),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                key:  Dataconstants.coachMarkerKey,
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>( theme.primaryColor),
                                    shape:
                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40.0),
                                            side:
                                            BorderSide(color: theme.primaryColor)))),
                                // color: theme.primaryColor,
                                onPressed: () async {
                                  setState(() {
                                    Dataconstants.isFromScripDetailToAdvanceScreen =
                                    false;
                                    Dataconstants.isFinishedAlgoModify = false;
                                    Dataconstants.isAwaitingAlgoModify = false;
                                    // //print(
                                    //     'isAwaitingAlgoModify : ${Dataconstants.isFinishedAlgoModify} isRunningAlgoModify: ${Dataconstants.isAwaitingAlgoModify},');
                                    //  Dataconstants.itsClient.fetch();
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          AlgorithmScreen())); // AlgorithmScreen()))    AdvanceOrder
                                  // CommonFunction.firebaselogEvent(true,"add_algo","_Click","add_algo");
                                },
                                child: Container(
                                    height: 40,
                                    width: 90,
                                    child:
                                    Center(
                                      child: Text("Add Algo",
                                        style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w600,color: Colors.white),
                                        // style: TextStyle(
                                        //     color: Colors.white,
                                        //     //Colors.grey,
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.w600)
                                      ),
                                    )
                                ),
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
                  onRefresh: () => Dataconstants.awaitingController.fetchReportAwaitingAlgo(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
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
                              color:theme.textTheme.bodyText1.color,
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: AwaitingController.reportAwaitingAlgoLists.length,
                              shrinkWrap: true,
                              physics:
                              AlwaysScrollableScrollPhysics(),
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
                                              initialChildSize:
                                              0.5,
                                              maxChildSize: 0.75,
                                              builder: (context, scrollController) {
                                                return AlgoDetail(
                                                    controller:
                                                    scrollController,
                                                    model: AwaitingController.reportAwaitingAlgoLists[index]);
                                              });
                                        });
                                  },
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        top: 12,
                                        left: 5,
                                        right: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Container(
                                              width: 2,
                                              height: 97,
                                              color: AwaitingController.reportAwaitingAlgoLists[
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
                                                  Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        AwaitingController.reportAwaitingAlgoLists[index].algoName,
                                                        // 'MACD$index'
                                                      ),
                                                      Container(
                                                        padding:
                                                        EdgeInsets.symmetric(
                                                          vertical:
                                                          3,
                                                          horizontal:
                                                          7,
                                                        ),
                                                        color: AwaitingController.reportAwaitingAlgoLists[index].algoId ==
                                                            4
                                                            ? Colors.grey.withOpacity(0.2)
                                                            : AwaitingController.reportAwaitingAlgoLists[index].buySell == "B"
                                                            ? ThemeConstants.buyColor.withOpacity(0.2)
                                                            : ThemeConstants.sellColor.withOpacity(0.2),
                                                        child:
                                                        Text(
                                                          AwaitingController.reportAwaitingAlgoLists[index].algoId == 4
                                                              ? "AUTO"
                                                              : AwaitingController.reportAwaitingAlgoLists[index].buySell == "B"
                                                              ? 'BUY'
                                                              : 'SELL',
                                                          style:
                                                          TextStyle(
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: AwaitingController.reportAwaitingAlgoLists[index].algoId == 4
                                                                ? Colors.grey
                                                                : AwaitingController.reportAwaitingAlgoLists[index].buySell == "B"
                                                                ? ThemeConstants.buyColor
                                                                : ThemeConstants.sellColor,
                                                          ),
                                                        ),
                                                      ),

                                                    ],),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5, bottom: 1),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(AwaitingController.reportAwaitingAlgoLists[index].exch == "N" ? "NSE" : "BSE",
                                                                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                                                            SizedBox(
                                                                width: 3),
                                                            Text(
                                                                AwaitingController.reportAwaitingAlgoLists[index].exchType == "C" ? "EQ " : "DR ",
                                                                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                                                            Text(
                                                              AwaitingController.reportAwaitingAlgoLists[index].exchType == "D"
                                                                  ? ""
                                                                  : ': ${AwaitingController.reportAwaitingAlgoLists[index].model.name}',
                                                              style:
                                                              TextStyle(fontSize: 13),
                                                            ),
                                                            Text(
                                                              AwaitingController.reportAwaitingAlgoLists[index].exchType == "C"
                                                                  ? ""
                                                                  : ': ${AwaitingController.reportAwaitingAlgoLists[index].desc}',
                                                              style:
                                                              TextStyle(fontSize: 13),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "LTP : "
                                                                ,
                                                                style: TextStyle(fontSize: 13, color: Colors.grey[600])
                                                            ),
                                                            Observer(
                                                              builder: (_) =>
                                                                  DecimalText(
                                                                      AwaitingController.reportAwaitingAlgoLists[index].model.close == 0.0
                                                                          ? AwaitingController.reportAwaitingAlgoLists[index].model.prevDayClose
                                                                          .toStringAsFixed(
                                                                          AwaitingController.reportAwaitingAlgoLists[index].model.precision) : AwaitingController.reportAwaitingAlgoLists[index].model.close
                                                                          .toStringAsFixed(
                                                                          AwaitingController.reportAwaitingAlgoLists[index].model.precision),
                                                                      style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: AwaitingController.reportAwaitingAlgoLists[index].model.priceColor == 1
                                                                            ? ThemeConstants.buyColor
                                                                            : AwaitingController.reportAwaitingAlgoLists[index].model.priceColor == 2
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
                                                    padding: const EdgeInsets
                                                        .only(
                                                        top: 5,
                                                        bottom:
                                                        5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                            children: [
                                                              Text(
                                                                'Start :',
                                                                style: TextStyle(color: Colors.grey),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                // AwaitingController.reportAwaitingAlgoLists[index].startTime??"00.:00"
                                                                DateUtil.getDateWithFormatForAlgoDate(AwaitingController.reportAwaitingAlgoLists[index].startTime, "dd-MM-yyyy HH:mm").toString(),
                                                                // Dataconstants.reportAlgoModel.reportAlgo.startTime.toString()
                                                                // 'datetime'
                                                              )
                                                            ]),
                                                        Row(
                                                          children: [
                                                            // Text('P&L'),
                                                            Text(
                                                              'End :',
                                                              style:
                                                              TextStyle(color: Colors.grey),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                              8,
                                                            ),
                                                            Text(
                                                              DateUtil.getDateWithFormatForAlgoDate(AwaitingController.reportAwaitingAlgoLists[index].endTime, "dd-MM-yyyy HH:mm").toString(),
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
                                                            EdgeInsets.symmetric(
                                                              vertical:
                                                              3,
                                                              horizontal:
                                                              7,
                                                            ),
                                                            color: Colors
                                                                .cyan
                                                                .withOpacity(0.2),
                                                            child:
                                                            Text(
                                                              AwaitingController.reportAwaitingAlgoLists[index].orderType == "I"
                                                                  ? "INTRADAY"
                                                                  : AwaitingController.reportAwaitingAlgoLists[index].exchType == "D"
                                                                  ?"NORMAL".toUpperCase()
                                                                  :"DELIVERY",
                                                              style:
                                                              TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.cyan,),),),
                                                          SizedBox(width: 5),
                                                          Container(
                                                            padding: EdgeInsets.symmetric(
                                                              vertical:
                                                              3,
                                                              horizontal:
                                                              7,
                                                            ),
                                                            color: theme
                                                                .primaryColor
                                                                .withOpacity(0.2),
                                                            child:
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  AwaitingController.reportAwaitingAlgoLists[index].algoId == 4 ? "Open Qty" : "Placed Qty",
                                                                  style: TextStyle(color: theme.primaryColor),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Text(
                                                                  AwaitingController.reportAwaitingAlgoLists[index].placedQty.toString()=="null"
                                                                      ?"0":AwaitingController.reportAwaitingAlgoLists[index].placedQty.toString(),
                                                                  style: TextStyle(color: theme.primaryColor),
                                                                  // '(50,20,09)'
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                          padding:
                                                          EdgeInsets
                                                              .symmetric(
                                                            vertical:
                                                            3,
                                                            horizontal:
                                                            7,
                                                          ),
                                                          color: Colors
                                                              .amber[
                                                          700]
                                                              .withOpacity(
                                                              0.2),
                                                          child: Row(
                                                              children: [
                                                                Text(
                                                                  (AwaitingController.reportAwaitingAlgoLists[index].algoId == 4) ? "Max Open Qty" : "Total Qty",
                                                                  style: TextStyle(color: Colors.amber[700]),
                                                                  // 'Return'
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  AwaitingController.reportAwaitingAlgoLists[index].totalQty.toString(),
                                                                  style: TextStyle(color: Colors.amber[700]),
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
                                          color:
                                          theme.dividerColor,
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
            //         : AwaitingController.reportAwaitingAlgoLists.isEmpty
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
            //                   itemCount: AwaitingController.reportAwaitingAlgoLists
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
            //                                             AwaitingController.reportAwaitingAlgoLists[index].algoName,
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
            //                                             color: AwaitingController.reportAwaitingAlgoLists[index].algoId ==
            //                                                 4
            //                                                 ? Colors.grey.withOpacity(0.2)
            //                                                 : AwaitingController.reportAwaitingAlgoLists[index].buySell == "B"
            //                                                 ? ThemeConstants.buyColor.withOpacity(0.2)
            //                                                 : ThemeConstants.sellColor.withOpacity(0.2),
            //                                             child:
            //                                             Text(
            //                                               AwaitingController.reportAwaitingAlgoLists[index].algoId == 4
            //                                                   ? "AUTO"
            //                                                   : AwaitingController.reportAwaitingAlgoLists[index].buySell == "B"
            //                                                   ? 'BUY'
            //                                                   : 'SELL',
            //                                               style:
            //                                               TextStyle(
            //                                                 fontWeight:
            //                                                 FontWeight.w500,
            //                                                 color: AwaitingController.reportAwaitingAlgoLists[index].algoId == 4
            //                                                     ? Colors.grey
            //                                                     : AwaitingController.reportAwaitingAlgoLists[index].buySell == "B"
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
            //                                                     AwaitingController.reportAwaitingAlgoLists[index].exchType == "C" ? "EQ " : "DR ",
            //                                                     style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            //                                                 Text(
            //                                                   AwaitingController.reportAwaitingAlgoLists[index].exchType == "D"
            //                                                       ? ""
            //                                                       : ': ${AwaitingController.reportAwaitingAlgoLists[index].model.name}',
            //                                                   style:
            //                                                   TextStyle(fontSize: 13),
            //                                                 ),
            //                                                 Text(
            //                                                   AwaitingController.reportAwaitingAlgoLists[index].exchType == "C"
            //                                                       ? ""
            //                                                       : ': ${AwaitingController.reportAwaitingAlgoLists[index].desc}',
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
            //                                                           AwaitingController.reportAwaitingAlgoLists[index].model.close == 0.0
            //                                                               ? AwaitingController.reportAwaitingAlgoLists[index].model.prevDayClose
            //                                                               .toStringAsFixed(
            //                                                               AwaitingController.reportAwaitingAlgoLists[index].model.precision) : AwaitingController.reportAwaitingAlgoLists[index].model.close
            //                                                               .toStringAsFixed(
            //                                                               AwaitingController.reportAwaitingAlgoLists[index].model.precision),
            //                                                           style: TextStyle(
            //                                                             fontSize: 13,
            //                                                             fontWeight: FontWeight.bold,
            //                                                             color: AwaitingController.reportAwaitingAlgoLists[index].model.priceColor == 1
            //                                                                 ? ThemeConstants.buyColor
            //                                                                 : AwaitingController.reportAwaitingAlgoLists[index].model.priceColor == 2
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
            //                                                     // AwaitingController.reportAwaitingAlgoLists[index].startTime??"00.:00"
            //                                                     DateUtil.getDateWithFormatForAlgoDate(AwaitingController.reportAwaitingAlgoLists[index].startTime, "dd-MM-yyyy HH:mm").toString(),
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
            //                                                   DateUtil.getDateWithFormatForAlgoDate(AwaitingController.reportAwaitingAlgoLists[index].endTime, "dd-MM-yyyy HH:mm").toString(),
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
            //                                                   AwaitingController.reportAwaitingAlgoLists[index].orderType == "I"
            //                                                       ? "INTRADAY"
            //                                                       : AwaitingController.reportAwaitingAlgoLists[index].exchType == "D"
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
            //                                                       AwaitingController.reportAwaitingAlgoLists[index].algoId == 4 ? "Open Qty" : "Placed Qty",
            //                                                       style: TextStyle(color: theme.primaryColor),
            //                                                     ),
            //                                                     SizedBox(
            //                                                       width: 8,
            //                                                     ),
            //                                                     Text(
            //                                                       AwaitingController.reportAwaitingAlgoLists[index].placedQty.toString()=="null"
            //                                                           ?"0":AwaitingController.reportAwaitingAlgoLists[index].placedQty.toString(),
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
            //                                                       (AwaitingController.reportAwaitingAlgoLists[index].algoId == 4) ? "Max Open Qty" : "Total Qty",
            //                                                       style: TextStyle(color: Colors.amber[700]),
            //                                                       // 'Return'
            //                                                     ),
            //                                                     SizedBox(
            //                                                       width: 10,
            //                                                     ),
            //                                                     Text(
            //                                                       AwaitingController.reportAwaitingAlgoLists[index].totalQty.toString(),
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
        ],
      ),
    );
  }
}

class AlgoDetail extends StatefulWidget {
  final ReportAlgo model;
  ScrollController controller;

  AlgoDetail({this.model, this.controller});

//  const ({Key? key}) : super(key: key);

  @override
  _AlgoDetailState createState() => _AlgoDetailState(model, controller);
}

class _AlgoDetailState extends State<AlgoDetail> {
  _AlgoDetailState(ReportAlgo model, ScrollController controller);

  int instructionDateConverted;
  String name;
  int algoId;
  String algoPhrase;
  String algoType;
  String algoSegment;
  bool restartButtonColor = false;
  bool pauseButtonColor = false;

  @override
  void initState() {
    super.initState();
    var instructionDate =
    DateUtil.getAnyFormattedDate(DateTime.now(), "dd-MMM-yyyy hh:mm:ss");

    // //print('insTructionTime pass sdfdsf = $instructionDate');
    instructionDateConverted = DateUtil.getIntFromDate1(instructionDate);
    // //print(
    //     'insTructionTime pass Converted to integer = $instructionDateConverted');
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
          //   height: 410,dddd
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
                //   crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(theme.primaryColor),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                side:
                                BorderSide(color: Color(0xFF5367FC))))),


                    // color: theme.primaryColor,
                    onPressed: () async {
                      await Dataconstants.itsClient2.stoptAlgo(
                        instructionId: widget.model.instId,
                      );
                      await Dataconstants.awaitingController.fetchReportAwaitingAlgo();
                      // await Dataconstants.itsClient.reportAlgo();
                      // CommonFunction.firebaselogEvent(true,"algo_stop","_Click","algo_stop");

                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                      // height: 40,
                      // width: 85,
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

                  // if (widget.model.instStatus == "P")
                  // RaisedButton(
                  //   color: theme.primaryColor,
                  //   onPressed: ()  {
                  //     Navigator.pop(context);
                  //
                  //     setState(
                  //       () {
                  //         var model2;
                  //
                  //         name = Dataconstants.fetchAlgoModel
                  //             .fetchAlgoLists[widget.model.algoId - 1].algoName;
                  //         algoId = Dataconstants.fetchAlgoModel
                  //             .fetchAlgoLists[widget.model.algoId - 1].algoId;
                  //         algoPhrase = Dataconstants.fetchAlgoModel
                  //             .fetchAlgoLists[widget.model.algoId - 1].algoPhrase;
                  //         algoType = Dataconstants.fetchAlgoModel
                  //             .fetchAlgoLists[widget.model.algoId - 1].algoType;
                  //         algoSegment = Dataconstants
                  //             .fetchAlgoModel
                  //             .fetchAlgoLists[widget.model.algoId - 1]
                  //             .algoSegment;
                  //
                  //
                  //         var tempModel = CommonFunction.getScripDataModel(
                  //             exch: widget.model.exch,
                  //             exchCode: widget.model.scripCode,
                  //             getNseBseMap: true);
                  //         //print('srgsg ${widget.model.scripCode}');
                  //         var paramModel = Dataconstants.fetchAlgoModel
                  //             .fetchAlgoLists[widget.model.algoId - 1].algoParam;
                  //
                  //         Navigator.of(context).push(MaterialPageRoute(
                  //             builder: (context) => AdvanceOrder(
                  //                 name: name,
                  //                 id: algoId,
                  //                 phrase: algoPhrase,
                  //                 type: algoType,
                  //                 segment: algoSegment,
                  //                 modifyModel: tempModel,
                  //                 paramModel: paramModel)));
                  //
                  //         setState(() {
                  //           Dataconstants.isAwaitingAlgoModify = true;
                  //           Dataconstants.awaitinggAlgoToAdvanceScreen = widget.model;
                  //         });
                  //       },
                  //     );
                  //   },
                  //   child: Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                  //       // height: 40,
                  //       // width: 80,
                  //       child: Align(
                  //           alignment: Alignment.center,
                  //           child: Text("Modify",
                  //               style: TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.w500)))),
                  // ) else


                  if (widget.model.instStatus != "P")
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  side:
                                  BorderSide(color: theme.primaryColor)))),
                      // color: theme.primaryColor,
                      onPressed: () async {
                        {
                          await Dataconstants.itsClient2.pauseAlgo(
                            instructionId: widget.model.instId,
                          );
                          if (Dataconstants.pauseAlgoStatus == "Success") {
                            CommonFunction.showBasicToast('Algo Pause');
                          }
                          await Dataconstants.awaitingController.fetchReportAwaitingAlgo();
                          // await Dataconstants.itsClient.reportAlgo();
                          Navigator.pop(context);
                          // CommonFunction.firebaselogEvent(true,"algo_pause","_Click","algo_pause");
                        }
                      },
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 3),
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
                  if (widget.model.instStatus == "P")
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(theme.primaryColor),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  side: BorderSide(color: Color(0xFF5367FC))))),
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                      // color: theme.primaryColor,
                      onPressed: () async {
                        {
                          await Dataconstants.itsClient2.restartAlgo(
                            instructionId: widget.model.instId,
                            // algoId: widget.model.algoId,
                            // totalQty: widget.model.totalQty,
                            // slicingQty: widget.model.slicingQty,
                            // buySell: widget.model.buySell == "B"
                            //     ? "BUY"
                            //     : "SELL",
                            // orderType: widget.model.orderType == "D"
                            //     ? "Delevery"
                            //     : "Intraday",
                            // timeInterval: widget.model.timeInterval,
                            // startTime: widget.model.startTime,
                            // endTime: widget.model.endTime,
                            // limitPrice: widget.model.limitPrice,
                            // priceRangeLow: widget.model.priceRangeLow,
                            // priceRangeHigh: widget.model.priceRangeHigh,
                            // instructionTime: instructionDateConverted,
                            // // "${DateTime.now().hour}:${DateTime.now().minute}",
                            // instructionId: widget.model.instId,
                            // avgDirection: widget.model.avgDirection,
                            // avgLimitPrice: widget.model.avgLimitPrice,
                            // avgEntryDiff: widget.model.avgEntryDiff,
                            // avgExitDiff: widget.model.avgExitDiff
                          );

                          if (Dataconstants.resumeAlgoStatus == "Success") {
                            CommonFunction.showBasicToast('Algo Resume');
                          }

                          await Dataconstants.awaitingController.fetchReportAwaitingAlgo();
                          // await Dataconstants.itsClient.reportAlgo();
                          Navigator.pop(context);
                        }
                        // CommonFunction.firebaselogEvent(true,"algo_resume","_Click","algo_resume");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        // height: 40,
                        // width: 90,
                        child: Row(
                          children: [
                            Icon(
                              Icons.not_started_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text("Resume",
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
                          )
                      );
                      // CommonFunction.firebaselogEvent(true,"algo_log","_Click","algo_log");

                    },
                    style: OutlinedButton.styleFrom(

                      side: BorderSide(width:1.0 ,color: Colors.white,style: BorderStyle.solid),
                    ),
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

                ],
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                decoration: BoxDecoration(color:ThemeConstants.themeMode.value == ThemeMode.light?Colors.grey.shade200: Colors.blueGrey[900]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,left: 15,right: 15),
                  child: Column(
                    children: [
                      Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(height: 8,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
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
                          ],),
                          Text(
                              widget.model.desc,
                              style: TextStyle(
                                fontSize:widget.model.exchType == "C"? 16:14,
                                fontWeight: FontWeight.w400,
                                color: theme.textTheme.bodyText1.color,
                              )),

                        ],),
                      SizedBox(height: 8,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(height: 8,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ],),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      widget.model.algoId == 4
                          ? "Max Open Qty"
                          : "Total Qty",
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Sent Qty",
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text((widget.model.algoId != 4)?"Placed Qty":"Open Qty",
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
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pending Qty"
                          , style: TextStyle(
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
                SizedBox(height: 3,),
              Divider(
                thickness: 1.0,
                color: theme.dividerColor,
              ),
              SizedBox(
                height: 3,
              ),
              Text("Exchange :"
                ,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: theme.textTheme.bodyText1.color),),

              SizedBox(
                height: 12,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Traded Qty', style: TextStyle(
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rejected Qty', style: TextStyle(
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pending Qty', style: TextStyle(
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
              SizedBox(height: 3,),
              Divider(
                thickness: 1.0,
                color: theme.dividerColor,
              ),
              SizedBox(
                height: 5,
              ),
              if (widget.model.algoId == 3 || widget.model.algoId == 4||widget.model.algoId == 2)
                Column(
                  children: [
                    Text("Price :",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: theme.textTheme.bodyText1.color),),

                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),

              if (widget.model.algoId == 2)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Avg Start Price",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                        Text(
                            widget.model.atMarket == "M"
                                ? "Mkt"
                                : widget.model.avgLimitPrice.toString() ??
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
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Avg Entry Diff",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                        Text(
                            widget.model.avgEntryDiff.toStringAsFixed(2) ??
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
                    if (widget.model.algoId == 4)
                      Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Avg Exit Diff",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey)),
                              Text(
                                  widget.model.avgExitDiff
                                      .toStringAsFixed(2) ??
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
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Avg Direction",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                        Text(widget.model.avgDirection =="D"?"Down":"Up"?? " ",
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
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

              // Row(
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text("Algo Name",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text("Scrip Name",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text("Exchange",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text("Exchange Type",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text("Product Type",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text("Buy/Sell",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text("InstId",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //
              //         if (widget.model.algoId == 4)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text("Open Qty",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //
              //             ],
              //           ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text("Placed Qty",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text("Traded Qty",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //
              //         if (widget.model.algoId != 4)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text("Rejected Qty",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //             ],
              //           ),
              //         if (widget.model.algoId != 4 && widget.model.algoId != 5)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text("Pending Qty",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //             ],
              //           ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //
              //         Text(
              //             widget.model.algoId == 4
              //                 ? "Max Open Quantity"
              //                 : "Total Qty",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //         SizedBox(height: 5,),
              //         Text(
              //             widget.model.algoId == 3 || widget.model.algoId == 4
              //                 ? "Averaging Quantity"
              //                 : "Slice Quantity",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //
              //         SizedBox(height: 5,),
              //         Text("Start ",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text("End ",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w400,
              //                 color: Colors.grey)),
              //
              //
              //         if (widget.model.algoId != 4 && widget.model.algoId != 3)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text("Time Interval",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //             ],
              //           )
              //         else
              //           SizedBox.shrink(),
              //
              //         if (widget.model.algoId == 2)
              //           Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text("Price Range High",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text("Price Range Low",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //             ],
              //           ),
              //         if (widget.model.algoId == 3 || widget.model.algoId == 4)
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text("AvgDirection",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text("AvgLimitPrice",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text("AvgEntryDiff",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //               if (widget.model.algoId == 4)
              //                 Column(
              //                   children: [
              //                     SizedBox(
              //                       height: 5,
              //                     ),
              //                     Text("AvgExitDiff",
              //                         style: TextStyle(
              //                             fontSize: 14,
              //                             fontWeight: FontWeight.w400,
              //                             color: Colors.grey)),
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
              //               Text("HistSize",
              //                   style: TextStyle(
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400,
              //                       color: Colors.grey)),
              //             ],
              //           )
              //       ],
              //     ),
              //     Spacer(),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(widget.model.algoName,
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(
              //             widget.model.exchType == "C"
              //                 ? widget.model.model.name
              //                 : widget.model.desc,
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(widget.model.exch == "N" ? "NSE" : "BSE",
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(widget.model.exchType == "C" ? "EQ " : "DR ",
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(
              //             widget.model.orderType == "I"
              //                 ? "INTRADAY"
              //                 : widget.model.exchType == "D"
              //                 ? "NORMAL".toUpperCase()
              //                 : "DELIVERY",
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(widget.model.buySell == "B" ? "Buy" : "Sell",
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(widget.model.instId.toString(),
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         if (widget.model.algoId == 4)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(
              //                   widget.model.tradedQty
              //                       .toString(),
              //                   // rejected qty
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //
              //             ],
              //           ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(widget.model.orderQty.toString(),
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(height: 5,),
              //         Text(widget.model.exchTradeQty.toString(),
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //
              //         if (widget.model.algoId != 4)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(
              //                   (widget.model.orderQty - widget.model.tradedQty)
              //                       .toString(),
              //                   // rejected qty
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //             ],
              //           ),
              //         if (widget.model.algoId != 4 && widget.model.algoId != 5)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(
              //                   (widget.model.totalQty - widget.model.orderQty)
              //                       .toString(), // pending qty
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //             ],
              //           ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //
              //         Text(widget.model.totalQty.toString(),
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(widget.model.slicingQty.toString(),
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //
              //         Text(
              //             DateUtil.getDateWithFormatForAlgoDate(
              //                 widget.model.startTime, "dd-MM-yyyy HH:mm")
              //                 .toString(),
              //             // widget.model.startTime??"00:00",
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(
              //             DateUtil.getDateWithFormatForAlgoDate(
              //                 widget.model.endTime, "dd-MM-yyyy HH:mm")
              //                 .toString(),
              //             // widget.model.endTime??"00:00",
              //             //widget.model.endTime.toString(),
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: theme.textTheme.bodyText1.color,
              //             )),
              //
              //         if (widget.model.algoId != 4 && widget.model.algoId != 3)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(
              //                   DateUtil.getDateWithFormatForAlgoDate(
              //                       widget.model.timeInterval,
              //                       "dd-MM-yyyy HH:mm:ss")
              //                       .toString()
              //                       .split(' ')[1]
              //                       .split(".")[0],
              //                   // (widget.model.timeInterval/60).toString().padLeft(2, '0'),
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //             ],
              //           )
              //         else
              //           SizedBox.shrink(),
              //
              //         if (widget.model.algoId == 2)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(widget.model.priceRangeHigh.toStringAsFixed(2),
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(widget.model.priceRangeLow.toStringAsFixed(2),
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //             ],
              //           ),
              //         if (widget.model.algoId == 3 || widget.model.algoId == 4)
              //           Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.end,
              //             children: [
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(widget.model.avgDirection ?? " ",
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(
              //                   widget.model.atMarket == "M"
              //                       ? "Mkt"
              //                       : widget.model.avgLimitPrice.toString() ??
              //                       " ",
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //               SizedBox(
              //                 height: 5,
              //               ),
              //               Text(
              //                   widget.model.avgEntryDiff.toStringAsFixed(2) ??
              //                       " ",
              //                   style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: theme.textTheme.bodyText1.color,
              //                   )),
              //               if (widget.model.algoId == 4)
              //                 Column(
              //                   children: [
              //                     SizedBox(
              //                       height: 5,
              //                     ),
              //                     Text(
              //                         widget.model.avgExitDiff
              //                             .toStringAsFixed(2) ??
              //                             " ",
              //                         style: TextStyle(
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.w400,
              //                           color: theme.textTheme.bodyText1.color,
              //                         )),
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
