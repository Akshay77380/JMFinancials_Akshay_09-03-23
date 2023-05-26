import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../style/theme.dart';
import '../../util/Utils.dart';

class EquitySipOrderReview extends StatelessWidget {
  final  qty,
      frequency,
      duration, name, exch, startDate, endDate, ltp, ordeValue;
  final bool isAmount;

  EquitySipOrderReview({
    @required this.qty,
    this.frequency,
    this.duration,
    this.name,
    this.exch,
    this.startDate,
    this.endDate,
    this.ltp,
    this.ordeValue, this.isAmount});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return

      DraggableScrollableSheet(
          maxChildSize: 0.6,
          initialChildSize: 0.5,minChildSize: 0.4,
          expand: false,
          builder: (context, controller) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              controller: controller,

              child: Container(
                //  height: 410,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: FractionallySizedBox(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            height: 5,
                            decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(5)),
                          ),
                          widthFactor: 0.25,
                        ),
                      ),

                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Review your SIP",
                        style: TextStyle(fontSize: 22.0),
                      ),
                      // Divider(height: 2,),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        isAmount?"SIP AMOUNT":
                        "SIP QUANTITY",
                        style: TextStyle(
                            color: Utils.greyColor,
                            fontSize: 20.0),
                      ),
                      Text(
                        qty,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22.0,
                            color: theme.textTheme.bodyText1.color
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Frequency",
                                style: TextStyle(
                                    color: Utils.greyColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                frequency,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                frequency=="Daily"?"No. of Days":
                                frequency=="Weekly"?"No. of Weeks":
                                frequency=="Monthly"?"No. of Months":
                                "No. of Quarters"
                                ,
                                style: TextStyle(
                                    color: Utils.greyColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                duration,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.0,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: ThemeConstants.buyColor.withOpacity(0.1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            )),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text("STOCK YOU BUY",
                                style: TextStyle(
                                    fontSize: 15.0, color: ThemeConstants.buyColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start  ,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: Text(name,
                                            style:TextStyle(
                                                fontSize: 20.0,
                                                color: Utils.blackColor,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Text(exch == 'N' ? 'NSE Equity' : 'BSE Equity',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Utils.blackColor,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  Observer(
                                    builder: (_) => Text(
                                      ltp,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: double.parse(ltp)>0.0?ThemeConstants.buyColor:ThemeConstants.sellColor

                                        // theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  // Text('Market Price',
                                  //     style: TextStyle(
                                  //         fontSize: 14.0,
                                  //         color: Utils.blackColor,
                                  //         fontWeight: FontWeight.w500)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Start Date",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text(startDate,
                              style: TextStyle(
                                  fontSize: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("End Date",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text(endDate,
                              style: TextStyle(
                                  fontSize: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Product",
                      //         style:TextStyle(
                      //             fontSize: 14.0,
                      //             fontWeight: FontWeight.w400,
                      //             color: Utils.greyColor)),
                      //     Text('-',
                      //         style: TextStyle(
                      //             fontSize: 14.0, color: Utils.blackColor))
                      //   ],
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("LTP",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text(ltp,
                              style: TextStyle(
                                  fontSize: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Order Value",
                      //         style: TextStyle(
                      //             fontSize: 14.0,
                      //             fontWeight: FontWeight.w400,
                      //             color: Utils.greyColor)),
                      //     Text(ordeValue,
                      //         style: TextStyle(
                      //             fontSize: 14.0, color: Utils.blackColor))
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  )),

              // child: Container(
              //     height: 410,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Center(
              //           child: FractionallySizedBox(
              //             child: Container(
              //               margin: EdgeInsets.symmetric(vertical: 5),
              //               height: 5,
              //               decoration: BoxDecoration(
              //                   color: Colors.grey[600],
              //                   borderRadius: BorderRadius.circular(5)),
              //             ),
              //             widthFactor: 0.25,
              //           ),
              //         ),
              //         SizedBox(height: 10),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           // crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             ElevatedButton(
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: theme.primaryColor,
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(40),
              //                 ),
              //               ),
              //               onPressed: () async {
              //                 // await Dataconstants.itsClient.stoptAlgo(
              //                 //   instructionId: widget.model.instId,
              //                 // );
              //                 // await Dataconstants.runningController
              //                 //     .fetchReportRunningAlgo();
              //                 // Dataconstants.itsClient.reportRunningAlgo();
              //                 Navigator.pop(context);
              //                 CommonFunction.firebaselogEvent(
              //                     true, "algo_stop", "_Click", "algo_stop");
              //               },
              //               child: Container(
              //                 padding:
              //                     EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              //                 // height: 40,
              //                 // width: 90,
              //                 child: Row(
              //                   children: [
              //                     Icon(
              //                       Icons.not_started_outlined,
              //                       size: 30,
              //                       color: Colors.white, // Colors.grey,
              //                     ),
              //                     SizedBox(width: 8),
              //                     Text("Stop",
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             //Colors.grey,
              //                             fontSize: 16,
              //                             fontWeight: FontWeight.w400))
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             //  Spacer(),
              //             ElevatedButton(
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: theme.primaryColor,
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(40),
              //                 ),
              //               ),
              //               onPressed: () async {
              //                 await Dataconstants.itsClient.pauseAlgo(
              //                   instructionId: widget.model.instId,
              //                 );
              //                 if (Dataconstants.pauseAlgoStatus == "Success") {
              //                   CommonFunction.showBasicToast('Algo Pause');
              //                 }
              //                 await Dataconstants.runningController
              //                     .fetchReportRunningAlgo();
              //                 // await Dataconstants.itsClient.reportRunningAlgo();
              //                 CommonFunction.firebaselogEvent(
              //                     true, "algo_pause", "_Click", "algo_pause");
              //                 Navigator.pop(context);
              //               },
              //               child: Container(
              //                 padding:
              //                     EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              //                 // height: 40,
              //                 // width: 85,
              //                 child: Row(
              //                   children: [
              //                     Icon(
              //                       Icons.pause_circle_outline,
              //                       size: 30,
              //                       color: Colors.white,
              //                     ),
              //                     SizedBox(width: 8),
              //                     Text("Pause",
              //                         style: TextStyle(
              //                             color: Colors.white,
              //                             fontSize: 16,
              //                             fontWeight: FontWeight.w400))
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             OutlinedButton(
              //               onPressed: () async {
              //                 // Navigator.pop(context);
              //                 var tempModel = CommonFunction.getScripDataModel(
              //                     exch: widget.model.exch,
              //                     exchCode: widget.model.scripCode,
              //                     getNseBseMap: true);
              //                 Dataconstants.algoLogModel.algoLogLists.clear();
              //                 await Dataconstants.itsClient.algoLog(
              //                   instructionId: widget.model.instId,
              //                 );
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) => AlgoGetDetail(
              //                             modifyModel: tempModel,
              //                             instructionId: widget.model.instId,
              //                             buySel: widget.model.buySell)));
              //                 CommonFunction.firebaselogEvent(
              //                     true, "algo_log", "_Click", "algo_log");
              //               },
              //               style: OutlinedButton.styleFrom(
              //                 side: BorderSide(
              //                   width: 1.0,
              //                   color: Colors.blue,
              //                   style: BorderStyle.solid,
              //                 ),
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(40),
              //                 ),
              //               ),
              //               child: Text(
              //                 "Algo Log",
              //                 style: TextStyle(
              //                     color: Colors.blue,
              //                     // color: theme.textTheme.bodyText1.color,
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w600),
              //               ),
              //             ),
              //             // Spacer(),
              //             // OutlinedButton(
              //             //   onPressed: () {
              //             //     Navigator.pop(context);
              //             //
              //             //     if (widget.model.algoId == 1) {
              //             //       name = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[0].algoName;
              //             //       algoId = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[0].algoId;
              //             //       algoPhrase = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[0].algoPhrase;
              //             //       algoType = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[0].algoType;
              //             //       algoSegment = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[0].algoSegment;
              //             //     } else if (widget.model.algoId == 2) {
              //             //       name = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[1].algoName;
              //             //       algoId = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[1].algoId;
              //             //       algoPhrase = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[1].algoPhrase;
              //             //       algoType = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[1].algoType;
              //             //       algoSegment = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[1].algoSegment;
              //             //     } else if (widget.model.algoId == 3) {
              //             //       name = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[2].algoName;
              //             //       algoId = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[2].algoId;
              //             //       algoPhrase = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[2].algoPhrase;
              //             //       algoType = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[2].algoType;
              //             //       algoSegment = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[2].algoSegment;
              //             //     } else if (widget.model.algoId == 4) {
              //             //       name = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[3].algoName;
              //             //       algoId = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[3].algoId;
              //             //       algoPhrase = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[3].algoPhrase;
              //             //       algoType = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[3].algoType;
              //             //       algoSegment = Dataconstants
              //             //           .fetchAlgoListsNew.fetchAlgoLists[3].algoSegment;
              //             //     }
              //             //
              //             //     var tempModel = CommonFunction.getScripDataModel(
              //             //         exch: widget.model.exch,
              //             //         exchCode: widget.model.scripCode,
              //             //         getNseBseMap: true);
              //             //
              //             //     Navigator.of(context).push(MaterialPageRoute(
              //             //         builder: (context) => AdvanceOrder(
              //             //               name: name,
              //             //               id: algoId,
              //             //               phrase: algoPhrase,
              //             //               type: algoType,
              //             //               segment: algoSegment,
              //             //               modifyModel: tempModel,
              //             //             )));
              //             //
              //             //     setState(() {
              //             //       Dataconstants.isRunningAlgoModify = true;
              //             //       Dataconstants.runningAlgoToAdvanceScreen = widget.model;
              //             //     });
              //             //   },
              //             //   borderSide: BorderSide(
              //             //     color: theme.primaryColor,
              //             //     style: BorderStyle.solid,
              //             //   ),
              //             //   disabledBorderColor: Theme.of(context).dividerColor,
              //             //   child: Container(
              //             //       height: 40,
              //             //       width: 80,
              //             //       child: Align(
              //             //           alignment: Alignment.center,
              //             //           child: Text("Modify",
              //             //               style: TextStyle(
              //             //                   color: theme.primaryColor,
              //             //                   fontSize: 16,
              //             //                   fontWeight: FontWeight.w400)))),
              //             // )
              //           ],
              //         ),
              //         SizedBox(
              //           height: 12,
              //         ),
              //         Container(
              //           width: MediaQuery.of(context).size.width,
              //           height: 120,
              //           decoration: BoxDecoration(
              //               color: ThemeConstants.themeMode.value == ThemeMode.light
              //                   ? Colors.grey.shade200
              //                   : Colors.blueGrey[900]),
              //           child: Padding(
              //             padding:
              //                 const EdgeInsets.only(top: 10, left: 15, right: 15),
              //             child: Column(
              //               children: [
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text(widget.model.algoName,
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //                           color: theme.textTheme.bodyText1.color,
              //                         )),
              //                     Row(
              //                       children: [
              //                         Text("ID : ",
              //                             style: TextStyle(
              //                               fontSize: 16,
              //                               fontWeight: FontWeight.w400,
              //                               color: theme.textTheme.bodyText1.color,
              //                             )),
              //                         Text(widget.model.instId.toString(),
              //                             style: TextStyle(
              //                               fontSize: 16,
              //                               fontWeight: FontWeight.w400,
              //                               color: theme.textTheme.bodyText1.color,
              //                             )),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 SizedBox(
              //                   height: 8,
              //                 ),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.model.exch == "N"
              //                                 ? "NSE : "
              //                                 : "BSE : ",
              //                             style: TextStyle(
              //                               fontSize: 16,
              //                               fontWeight: FontWeight.w400,
              //                               color: theme.textTheme.bodyText1.color,
              //                             )),
              //                         Text(
              //                             widget.model.exchType == "C"
              //                                 ? "EQ "
              //                                 : "DR ",
              //                             style: TextStyle(
              //                               fontSize: 16,
              //                               fontWeight: FontWeight.w400,
              //                               color: theme.textTheme.bodyText1.color,
              //                             )),
              //                       ],
              //                     ),
              //                     Text(widget.model.desc,
              //                         style: TextStyle(
              //                           fontSize:
              //                               widget.model.exchType == "C" ? 16 : 14,
              //                           fontWeight: FontWeight.w400,
              //                           color: theme.textTheme.bodyText1.color,
              //                         )),
              //                   ],
              //                 ),
              //                 SizedBox(
              //                   height: 8,
              //                 ),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Row(
              //                       children: [
              //                         // Text("Buy/Sell :  ", style: TextStyle(
              //                         //   fontSize: 16,
              //                         //   fontWeight: FontWeight.w400,
              //                         //   color: theme.textTheme.bodyText1.color,
              //                         // )),
              //                         Text(
              //                             widget.model.buySell == "B"
              //                                 ? "Buy"
              //                                 : "Sell",
              //                             style: TextStyle(
              //                               fontSize: 16,
              //                               fontWeight: FontWeight.w400,
              //                               color: theme.textTheme.bodyText1.color,
              //                             )),
              //                       ],
              //                     ),
              //                     Text(
              //                         widget.model.orderType == "I"
              //                             ? "INTRADAY"
              //                             : widget.model.exchType == "D"
              //                                 ? "NORMAL".toUpperCase()
              //                                 : "DELIVERY",
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //                           color: theme.textTheme.bodyText1.color,
              //                         )),
              //                   ],
              //                 ),
              //                 SizedBox(
              //                   height: 8,
              //                 ),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text(
              //                         DateUtil.getDateWithFormatForAlgoDate(
              //                                 widget.model.startTime,
              //                                 "dd-MM-yyyy HH:mm")
              //                             .toString(),
              //                         // widget.model.startTime??"00:00",
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //                           color: theme.textTheme.bodyText1.color,
              //                         )),
              //                     Text(
              //                         DateUtil.getDateWithFormatForAlgoDate(
              //                                 widget.model.endTime,
              //                                 "dd-MM-yyyy HH:mm")
              //                             .toString(),
              //                         // widget.model.endTime??"00:00",
              //                         //widget.model.endTime.toString(),
              //                         style: TextStyle(
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.w400,
              //                           color: theme.textTheme.bodyText1.color,
              //                         )),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 15,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //                 widget.model.algoId == 4
              //                     ? "Max Open Qty"
              //                     : "Total Qty",
              //                 style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: Colors.grey)),
              //             Text(widget.model.totalQty.toString(),
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w400,
              //                   color: theme.textTheme.bodyText1.color,
              //                 )),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //                 widget.model.algoId == 3 || widget.model.algoId == 4
              //                     ? "Averaging Qty"
              //                     : "Slice Qty",
              //                 style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: Colors.grey)),
              //             Text(widget.model.slicingQty.toString(),
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w400,
              //                   color: theme.textTheme.bodyText1.color,
              //                 )),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text("Sent Qty",
              //                 style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: Colors.grey)),
              //             Text(widget.model.sentQty.toString(),
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w400,
              //                   color: theme.textTheme.bodyText1.color,
              //                 )),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //                 (widget.model.algoId != 4)
              //                     ? "Placed Qty"
              //                     : "Open Qty",
              //                 style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: Colors.grey)),
              //             Text(widget.model.placedQty.toString(),
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w400,
              //                   color: theme.textTheme.bodyText1.color,
              //                 )),
              //           ],
              //         ),
              //         if (widget.model.algoId != 4)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 8,
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text("Rejected Qty",
              //                       style: TextStyle(
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.w400,
              //                           color: Colors.grey)),
              //                   Text(widget.model.rejectedQty.toString(),
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         color: theme.textTheme.bodyText1.color,
              //                       )),
              //                 ],
              //               ),
              //               SizedBox(
              //                 height: 3,
              //               ),
              //             ],
              //           ),
              //         if (widget.model.algoId != 4 && widget.model.algoId != 5)
              //           Column(
              //             children: [
              //               SizedBox(
              //                 height: 8,
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(
              //                     "Pending Qty",
              //                     style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         color: Colors.grey),
              //                   ),
              //                   Text(widget.model.pendingQty.toString(),
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         color: theme.textTheme.bodyText1.color,
              //                       )),
              //                 ],
              //               ),
              //               SizedBox(
              //                 height: 3,
              //               ),
              //             ],
              //           ),
              //         if (widget.model.algoId != 4)
              //           SizedBox(
              //             height: 3,
              //           ),
              //         Divider(
              //           thickness: 1.0,
              //           color: theme.dividerColor,
              //         ),
              //         SizedBox(
              //           height: 3,
              //         ),
              //         Text(
              //           "Exchange :",
              //           style: TextStyle(
              //               fontWeight: FontWeight.w600,
              //               fontSize: 20,
              //               color: theme.textTheme.bodyText1.color),
              //         ),
              //         SizedBox(
              //           height: 12,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text('Traded Qty',
              //                 style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: Colors.grey)),
              //             Text(widget.model.exchTradedQty.toString(),
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w400,
              //                   color: theme.textTheme.bodyText1.color,
              //                 )),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text('Rejected Qty',
              //                 style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: Colors.grey)),
              //             Text(widget.model.exchRejectedQty.toString(),
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w400,
              //                   color: theme.textTheme.bodyText1.color,
              //                 )),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text('Pending Qty',
              //                 style: TextStyle(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w400,
              //                     color: Colors.grey)),
              //             Text(widget.model.exchPendingQty.toString(),
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w400,
              //                   color: theme.textTheme.bodyText1.color,
              //                 )),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 3,
              //         ),
              //         Divider(
              //           thickness: 1.0,
              //           color: theme.dividerColor,
              //         ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         if (widget.model.algoId == 3 ||
              //             widget.model.algoId == 4 ||
              //             widget.model.algoId == 2)
              //           Column(
              //             children: [
              //               Text(
              //                 "Price :",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.w600,
              //                     fontSize: 20,
              //                     color: theme.textTheme.bodyText1.color),
              //               ),
              //               SizedBox(
              //                 height: 12,
              //               ),
              //             ],
              //           ),
              //         if (widget.model.algoId == 2)
              //           Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text("Price Range High",
              //                       style: TextStyle(
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.w400,
              //                           color: Colors.grey)),
              //                   Text(widget.model.priceRangeHigh.toStringAsFixed(2),
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         color: theme.textTheme.bodyText1.color,
              //                       )),
              //                 ],
              //               ),
              //               SizedBox(
              //                 height: 8,
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text("Price Range Low",
              //                       style: TextStyle(
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.w400,
              //                           color: Colors.grey)),
              //                   Text(widget.model.priceRangeLow.toStringAsFixed(2),
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         color: theme.textTheme.bodyText1.color,
              //                       )),
              //                 ],
              //               ),
              //               SizedBox(
              //                 height: 8,
              //               ),
              //             ],
              //           ),
              //         if (widget.model.algoId == 3 || widget.model.algoId == 4)
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text("Avg Start Price",
              //                       style: TextStyle(
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.w400,
              //                           color: Colors.grey)),
              //                   Text(
              //                       widget.model.atMarket == "M"
              //                           ? "Mkt"
              //                           : widget.model.avgLimitPrice.toString() ??
              //                               " ",
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         color: theme.textTheme.bodyText1.color,
              //                       )),
              //                 ],
              //               ),
              //               SizedBox(
              //                 height: 8,
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text("Avg Entry Diff",
              //                       style: TextStyle(
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.w400,
              //                           color: Colors.grey)),
              //                   Text(
              //                       widget.model.avgEntryDiff.toStringAsFixed(2) ??
              //                           " ",
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         color: theme.textTheme.bodyText1.color,
              //                       )),
              //                 ],
              //               ),
              //               SizedBox(
              //                 height: 8,
              //               ),
              //               if (widget.model.algoId == 4)
              //                 Column(
              //                   children: [
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Text("Avg Exit Diff",
              //                             style: TextStyle(
              //                                 fontSize: 14,
              //                                 fontWeight: FontWeight.w400,
              //                                 color: Colors.grey)),
              //                         Text(
              //                             widget.model.avgExitDiff
              //                                     .toStringAsFixed(2) ??
              //                                 " ",
              //                             style: TextStyle(
              //                               fontSize: 14,
              //                               fontWeight: FontWeight.w400,
              //                               color: theme.textTheme.bodyText1.color,
              //                             )),
              //                       ],
              //                     ),
              //                     SizedBox(
              //                       height: 8,
              //                     ),
              //                   ],
              //                 ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text("Avg Direction",
              //                       style: TextStyle(
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.w400,
              //                           color: Colors.grey)),
              //                   Text(
              //                       widget.model.avgDirection == "D"
              //                           ? "Down"
              //                           : "Up" ?? " ",
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         color: theme.textTheme.bodyText1.color,
              //                       )),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         if (widget.model.algoId != 4 && widget.model.algoId != 3)
              //           Column(
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text("Time Interval",
              //                       style: TextStyle(
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.w400,
              //                           color: Colors.grey)),
              //                   Text(
              //                       DateUtil.getDateWithFormatForAlgoDate(
              //                               widget.model.timeInterval,
              //                               "dd-MM-yyyy HH:mm:ss")
              //                           .toString()
              //                           .split(' ')[1]
              //                           .split(".")[0],
              //                       // (widget.model.timeInterval/60).toString().padLeft(2, '0'),
              //                       style: TextStyle(
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400,
              //                         color: theme.textTheme.bodyText1.color,
              //                       )),
              //                 ],
              //               ),
              //             ],
              //           )
              //       ],
              //     )),


            ),
          );
        }
      );








    //   Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Container(
    //     height: MediaQuery.of(context).size.height - 260,
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           Card(
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10)),
    //             color: Colors.white,
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Column(
    //                 children: [
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                         "Review your SIP",
    //                         style: TextStyle(fontSize: 20.0),
    //                       ),
    //                       InkWell(
    //                         onTap: () {
    //                           Navigator.pop(context);
    //                         },
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                               border: Border.all(
    //                                 color: Colors.green,
    //                                 width: 2,
    //                               ),
    //                               color: Colors.green.withOpacity(0.5),
    //                               borderRadius: BorderRadius.all(
    //                                 Radius.circular(20.0),
    //                               )
    //                           ),
    //                           child: Padding(
    //                             padding: const EdgeInsets.symmetric(
    //                                 horizontal: 8.0, vertical: 2.0),
    //                             child: Text(
    //                               "CLOSE",
    //                               style: TextStyle(
    //                                   fontSize: 16.0, color: Utils.blackColor),
    //                             ),
    //                           ),
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                   ),
    //                   Text(
    //                     "SIP QUANTITY",
    //                     style: TextStyle(
    //                         color: Utils.greyColor,
    //                         fontSize: 20.0),
    //                   ),
    //                   Text(
    //                     qty,
    //                     style: TextStyle(
    //                       fontWeight: FontWeight.w700,
    //                         fontSize: 22.0,
    //                       color: theme.textTheme.bodyText1.color
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             "Frequency",
    //                             style: TextStyle(
    //                                 color: Utils.greyColor,
    //                                 fontSize: 15.0,
    //                                 fontWeight: FontWeight.w400),
    //                           ),
    //                           Text(
    //                             frequency,
    //                             style: TextStyle(
    //                               fontWeight: FontWeight.w700,
    //                               fontSize: 15.0,
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.end,
    //                         children: [
    //                           Text(
    //                             "No. of Months",
    //                             style: TextStyle(
    //                                 color: Utils.greyColor,
    //                                 fontSize: 15.0,
    //                                 fontWeight: FontWeight.w400),
    //                           ),
    //                           Text(
    //                             duration,
    //                             style: TextStyle(
    //                               fontWeight: FontWeight.w700,
    //                               fontSize: 15.0,
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                   ),
    //                   Container(
    //                     decoration: BoxDecoration(
    //                         color: ThemeConstants.buyColor.withOpacity(0.1),
    //                         borderRadius: BorderRadius.all(
    //                           Radius.circular(15.0),
    //                         )),
    //                     child: Column(
    //                       children: [
    //                         SizedBox(
    //                           height: 10,
    //                         ),
    //                         Text("STOCK YOU BUY",
    //                             style: TextStyle(
    //                                 fontSize: 15.0, color: ThemeConstants.buyColor)),
    //                         Padding(
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 20.0, vertical: 15.0),
    //                           child: Row(
    //                             mainAxisAlignment:
    //                             MainAxisAlignment.spaceBetween,
    //                             children: [
    //                               Column(
    //                                 crossAxisAlignment: CrossAxisAlignment.start  ,
    //                                 children: [
    //                                   FittedBox(
    //                                     fit: BoxFit.cover,
    //                                     child: Text(name,
    //                                         style:TextStyle(
    //                                             fontSize: 20.0,
    //                                             color: Utils.blackColor,
    //                                             fontWeight: FontWeight.w700)),
    //                                   ),
    //                                   Text(exch == 'N' ? 'NSE Equity' : 'BSE Equity',
    //                                       style: TextStyle(
    //                                           fontSize: 14.0,
    //                                           color: Utils.blackColor,
    //                                           fontWeight: FontWeight.w500)),
    //                                 ],
    //                               ),
    //                               Text('Market Price',
    //                                   style: TextStyle(
    //                                       fontSize: 14.0,
    //                                       color: Utils.blackColor,
    //                                       fontWeight: FontWeight.w500)),
    //                             ],
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text("Start Date",
    //                           style: TextStyle(
    //                               fontSize: 14.0,
    //                               fontWeight: FontWeight.w400,
    //                               color: Utils.greyColor)),
    //                       Text(startDate,
    //                           style: TextStyle(
    //                               fontSize: 14.0, color: Utils.blackColor))
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text("End Date",
    //                           style: TextStyle(
    //                               fontSize: 14.0,
    //                               fontWeight: FontWeight.w400,
    //                               color: Utils.greyColor)),
    //                       Text(endDate,
    //                           style: TextStyle(
    //                               fontSize: 14.0, color: Utils.blackColor))
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text("Product",
    //                           style:TextStyle(
    //                               fontSize: 14.0,
    //                               fontWeight: FontWeight.w400,
    //                               color: Utils.greyColor)),
    //                       Text('-',
    //                           style: TextStyle(
    //                               fontSize: 14.0, color: Utils.blackColor))
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text("LTP",
    //                           style: TextStyle(
    //                               fontSize: 14.0,
    //                               fontWeight: FontWeight.w400,
    //                               color: Utils.greyColor)),
    //                       Text(ltp,
    //                           style: TextStyle(
    //                               fontSize: 14.0, color: Utils.blackColor))
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text("Order Value",
    //                           style: TextStyle(
    //                               fontSize: 14.0,
    //                               fontWeight: FontWeight.w400,
    //                               color: Utils.greyColor)),
    //                       Text(ordeValue,
    //                           style: TextStyle(
    //                               fontSize: 14.0, color: Utils.blackColor))
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           Card(
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10)),
    //               color: ThemeConstants.buyColor,
    //               child: Column(
    //                 children: [
    //                     InkWell(
    //                       onTap: () {},
    //                       child: Padding(
    //                         padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 20.0),
    //                         child: Text("START SIP",
    //                             style: TextStyle(
    //                                 fontSize: 16.0, color: Utils.whiteColor)),
    //                       ),
    //                     ),
    //                 ],
    //               ),
    //             )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
