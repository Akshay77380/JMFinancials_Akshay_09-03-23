import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/stock_sip/SipStockLogController.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../util/DateUtilBigul.dart';
import '../../widget/decimal_text.dart';

class StockSipLog extends StatefulWidget {
  final ScripInfoModel currentModel;

  const StockSipLog({Key key, this.currentModel}) : super(key: key);

  @override
  State<StockSipLog> createState() => _StockSipLogState();
}

class _StockSipLogState extends State<StockSipLog> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "SIP Log",
            style: TextStyle(color: theme.textTheme.bodyText1.color),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            return StockSipLogController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : StockSipLogController.GetSipLogtData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "No SIP Log",
                              style: TextStyle(color: Colors.grey[600], fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: theme.primaryColor,
                                  ),
                                ),
                                child: Text(
                                  'Refresh',
                                  style: TextStyle(color: theme.primaryColor),
                                ),
                                onPressed: () {
                                  Dataconstants.stockSipLogController.fetchGetSipLog(InstId: StockSipLogController.SipLogData.value.instId.toString());
                                })
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: theme.primaryColor,
                        // onRefresh: (){},
                        onRefresh: () => Dataconstants.stockSipLogController.fetchGetSipLog(InstId: StockSipLogController.SipLogData.value.instId.toString()),
                        // Dataconstants.itsClient.algoLog(
                        //   instructionId: widget.instructionId,
                        // ),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              decoration: BoxDecoration(color: theme.cardColor),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Summary",
                                        style: TextStyle(fontSize: 21, color: theme.textTheme.bodyText1.color),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(vertical: 2),
                                    //   child: Text(
                                    //     Dataconstants.algoLogModel.algoLog.algoName ?? " ",
                                    //     // "Averaging Scalper",
                                    //     style: TextStyle(fontSize: 16, color: theme.textTheme.bodyText1.color),
                                    //   ),
                                    // ),
                                    Row(
                                      children: [
                                        Text(
                                          StockSipLogController.SipLogData.value.scripName.toString(),
                                          // "Axis Bank",
                                          // Dataconstants.isFinishedAlgoModify == true
                                          //     ? Dataconstants.finishedAlgoToAdvanceScreen.model.name
                                          //     : " ",
                                          style: TextStyle(fontSize: 14, color: theme.textTheme.bodyText1.color),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Placed Qty : ${StockSipLogController.SipLogData.value.buyPlacedQty.toString()}",
                                          // "Axis Bank",
                                          // Dataconstants.isFinishedAlgoModify == true
                                          //     ? Dataconstants.finishedAlgoToAdvanceScreen.model.name
                                          //     : " ",
                                          style: TextStyle(fontSize: 14, color: theme.textTheme.bodyText1.color),
                                        ),
                                      ],
                                    ),

                                    // if (widget.buySel == "B" || Dataconstants.algoLogModel.algoLog.algoName == "Averaging Scalper")
                                    Row(
                                      children: [
                                        Text(
                                          "Exch Pending Qty : ${StockSipLogController.SipLogData.value.buyExchPendingQty.toString()}",
                                          style: TextStyle(fontSize: 14, color: theme.textTheme.bodyText1.color),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Exch Rejected Qty : ${StockSipLogController.SipLogData.value.buyExchRejectedQty.toString()}",
                                          style: TextStyle(fontSize: 14, color: theme.textTheme.bodyText1.color),
                                        )
                                      ],
                                    ),
                                    // if (widget.buySel == "S" || Dataconstants.algoLogModel.algoLog.algoName == "Averaging Scalper")
                                    //   Row(
                                    //     children: [
                                    //       Text(
                                    //         "Avg Sell Price : ${Dataconstants.algoLogModel.algoLog.avgSellPrice.toStringAsFixed(2) ?? "0.0"}  ",
                                    //         style: TextStyle(fontSize: 16, color: theme.textTheme.bodyText1.color),
                                    //       ),
                                    //       Spacer(),
                                    //       Text(
                                    //         "Sell Qty : ${Dataconstants.algoLogModel.algoLog.sellQty ?? "0"} ",
                                    //         style: TextStyle(fontSize: 16, color: theme.textTheme.bodyText1.color),
                                    //       )
                                    //     ],
                                    //   ),
                                    Row(
                                      children: [
                                        Text(
                                          "Current Rate : ",
                                          style: TextStyle(fontSize: 14, color: theme.textTheme.bodyText1.color),
                                        ),
                                        Observer(
                                          builder: (_) => Text(
                                            widget.currentModel.close.toStringAsFixed(2),
                                          ),
                                          // DecimalText(StockSipLogController.SipLogData.,
                                          //     style: TextStyle(
                                          //       fontSize: 14,
                                          //       fontWeight: FontWeight.w500,
                                          //       color:
                                          //       // currentModel.priceColor == 1
                                          //       //     ? ThemeConstants.buyColor
                                          //       //     : currentModel.priceColor == 2
                                          //       //     ? ThemeConstants.sellColor
                                          //       theme.textTheme.bodyText1.color,
                                          //     )),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Exch Trade Qty : ${StockSipLogController.SipLogData.value.buyExchTradedQty.toString()}",
                                          style: TextStyle(fontSize: 14, color: Colors.orange
                                              // color: theme.textTheme.bodyText1.color
                                              ),
                                        )
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "PL : 120.33",
                                    //       style: TextStyle(
                                    //           fontSize: 16,
                                    //           color: theme.textTheme.bodyText1.color),
                                    //     ),
                                    //     Spacer(),
                                    //     Container(
                                    //       height: 27,
                                    //       // width: 80,
                                    //       child: ElevatedButton(
                                    //         style: ElevatedButton.styleFrom(
                                    //             primary: theme.primaryColor),
                                    //         // color: theme.primaryColor,
                                    //         onPressed: () {},
                                    //         child: Container(
                                    //             child: Align(
                                    //                 alignment: Alignment.center,
                                    //                 child: Text("Square Off",
                                    //                     style: TextStyle(
                                    //                         color: Colors.white,
                                    //                         fontSize: 16,
                                    //                         fontWeight: FontWeight.w500)))),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),

                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Container(
                            //   padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                            //   width: double.infinity,
                            //   height: 170,
                            //   decoration: BoxDecoration(color: theme.cardColor),
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(top: 10),
                            //     child: LineChart(
                            //       LineChartData(
                            //           borderData: FlBorderData(show: false),
                            //           gridData: FlGridData(
                            //               drawHorizontalLine: false, drawVerticalLine: false),
                            //           minX: 0,
                            //           minY: 1,
                            //           maxX: 9,
                            //           maxY: 25,
                            //           titlesData: FlTitlesData(
                            //             rightTitles: SideTitles(showTitles: false),
                            //             topTitles: SideTitles(showTitles: false),
                            //             leftTitles: SideTitles(
                            //               interval: 4,
                            //               showTitles: true,
                            //               getTitles: (value) {
                            //                 return value.toInt().toString();
                            //               },
                            //             ),
                            //             bottomTitles:  SideTitles(
                            //               interval: 1,
                            //               showTitles: true,
                            //               getTitles: (value) {
                            //                 return value.toInt().toString();
                            //               },
                            //             ),
                            //             // SideTitles(
                            //             //   showTitles: true,
                            //             //   getTitles: (value) {
                            //             //     switch (value.toInt()) {
                            //             //       case 0:
                            //             //         return '0';
                            //             //       case 1:
                            //             //         return '1';
                            //             //       case 2:
                            //             //         return '2';
                            //             //       case 3:
                            //             //         return '3';
                            //             //       case 4:
                            //             //         return '4';
                            //             //       case 5:
                            //             //         return '5';
                            //             //       case 6:
                            //             //         return '6';
                            //             //       case 7:
                            //             //         return '7';
                            //             //       case 8:
                            //             //         return '8';
                            //             //     }
                            //             //     return '';
                            //             //   },
                            //             // ),
                            //           ),
                            //           lineBarsData: [
                            //             LineChartBarData(
                            //               colors: [
                            //               theme.primaryColor],
                            //               spots: [
                            //               const FlSpot(0, 1),
                            //               const FlSpot(1, 3),
                            //               const FlSpot(2, 10),
                            //               const FlSpot(3, 7),
                            //               const FlSpot(4, 12),
                            //               const FlSpot(5, 13),
                            //               const FlSpot(6, 17),
                            //               const FlSpot(7, 15),
                            //               const FlSpot(8, 20)
                            //             ],
                            //             )
                            //           ]),
                            //     ),
                            //   ),
                            // ),

                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child:
                                  // Dataconstants.algoLogModel.algoLog.logs.isEmpty
                                  //     ? Center(
                                  //   child: Text(
                                  //     "No log  has been generated",
                                  //     style: TextStyle(color: theme.primaryColor, fontSize: 18, fontWeight: FontWeight.w400),
                                  //   ),
                                  // )
                                  //     :
                                  Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListView.builder(
                                    itemCount: StockSipLogController.GetSipLogtData.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                          child: Container(
                                            // height: 80,
                                            // width: MediaQuery.of(context).size.width,
                                            //  decoration: BoxDecoration(color: theme.cardColor),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                                                        height: 30,
                                                        width: 85,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(40)),
                                                          // color:theme.cardColor,
                                                          color: Color(int.parse(StockSipLogController.GetSipLogtData[index].color)).withOpacity(0.2) ?? theme.cardColor,
                                                        ),
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(StockSipLogController.GetSipLogtData[index].event.trim(),
                                                                // "Buy",
                                                                style: TextStyle(
                                                                    // color:Colors.white,
                                                                    color: Color(int.parse(StockSipLogController.GetSipLogtData[index].color)) ?? Colors.white,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w500)))),

                                                    Text(
                                                      // "16-04-23",
                                                      DateUtilBigul.getDateStockEvent(
                                                          StockSipLogController.GetSipLogtData[index].dateTime.toString().split('T')[0].toString().split(' ')[0].toString()),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      // "17:22:00"
                                                    ),
                                                    // SizedBox(width: 40,),
                                                    // if (Dataconstants.algoLogModel.algoLog.logs[index].qty != 0 && Dataconstants.algoLogModel.algoLog.logs[index].orderRef != "")
                                                    // Dataconstants.algoLogModel.algoLog.logs[index].event !="Failed Buy")
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                // if (Dataconstants.algoLogModel.algoLog.logs[index].qty != 0)
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    FittedBox(
                                                        child: Text(
                                                      "Qty : ${StockSipLogController.GetSipLogtData[index].qty}",
                                                      style: TextStyle(fontSize: 15),
                                                    )),
                                                    FittedBox(
                                                      child: Text(
                                                        "Traded Qty : ${StockSipLogController.GetSipLogtData[index].tradedQty}",
                                                        style: TextStyle(fontSize: 15, color: Colors.orange),
                                                      ),
                                                    )
                                                    // if (Dataconstants.algoLogModel.algoLog.logs[index].orderRef != "")

                                                    // else
                                                    //   FittedBox(
                                                    //       child: Text(
                                                    //         "Qty : 3",
                                                    //         style: TextStyle(fontSize: 15),
                                                    //       )),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                // if (Dataconstants.algoLogModel.algoLog.logs[index].qty != 0 && Dataconstants.algoLogModel.algoLog.logs[index].orderRef != "")
                                                // Dataconstants.algoLogModel.algoLog.logs[index].event !="Failed Buy")
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    // fontSize: 15
                                                    FittedBox(
                                                        child: Text(
                                                      "Traded Price : ₹${StockSipLogController.GetSipLogtData[index].tradedRate}",
                                                      style: TextStyle(fontSize: 15),
                                                    )),

                                                    FittedBox(
                                                        child: Text(
                                                      "Rejected Qty : ${StockSipLogController.GetSipLogtData[index].rejectedQty}",
                                                      style: TextStyle(fontSize: 15, color: Colors.red),
                                                    )),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                // if (Dataconstants.algoLogModel.algoLog.logs[index].orderRef != "")
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Order Ref No :",
                                                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                                    ),
                                                    Text(StockSipLogController.GetSipLogtData[index].orderRef.toString(), style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2, bottom: 5),
                                                  child: Divider(
                                                    thickness: 2,
                                                    color: theme.dividerColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (
                                                context,
                                              ) {
                                                return DraggableScrollableSheet(
                                                    expand: false,
                                                    minChildSize: 0.3,
                                                    initialChildSize: 0.45,
                                                    maxChildSize: 0.75,
                                                    builder: (context, scrollController) {
                                                      return SingleChildScrollView(
                                                        controller: scrollController,
                                                        child: Container(
                                                          padding: EdgeInsets.all(10),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 10),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Center(
                                                                  child: FractionallySizedBox(
                                                                    child: Container(
                                                                      margin: EdgeInsets.symmetric(vertical: 7),
                                                                      height: 5,
                                                                      decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(5)),
                                                                    ),
                                                                    widthFactor: 0.25,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Event :",
                                                                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                                                    ),
                                                                    Text(StockSipLogController.GetSipLogtData[index].event.toString(), style: TextStyle(fontSize: 18)),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Time :",
                                                                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                                                    ),
                                                                    Text(
                                                                        DateUtilBigul.getDateStockEvent(
                                                                            StockSipLogController.GetSipLogtData[index].dateTime.toString().split('T')[0].toString().split(' ')[0].toString()),

                                                                        // StockSipLogController.GetSipLogtData[index].dateTime.toString().split('T')[0].toString().split(' ')[0].toString(),
                                                                        style: TextStyle(fontSize: 18)),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                // if (Dataconstants.algoLogModel.algoLog.logs[index].qty != 0)
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "QTY : ",
                                                                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                                                        ),
                                                                        Text(StockSipLogController.GetSipLogtData[index].qty.toString(), style: TextStyle(fontSize: 18)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Trade Rate :",
                                                                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                                                        ),
                                                                        Text(StockSipLogController.GetSipLogtData[index].tradedRate.toString(), style: TextStyle(fontSize: 18)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Trade Qty :",
                                                                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                                                        ),
                                                                        Text(StockSipLogController.GetSipLogtData[index].tradedQty.toString(), style: TextStyle(fontSize: 18)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                  ],
                                                                ),
                                                                // if (Dataconstants.algoLogModel.algoLog.logs[index].qty != 0 && Dataconstants.algoLogModel.algoLog.logs[index].orderRef != "")
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Price :",
                                                                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                                                        ),
                                                                        Text(StockSipLogController.GetSipLogtData[index].rate.toString(), style: TextStyle(fontSize: 18)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Rejected Qty :",
                                                                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                                                        ),
                                                                        Text(StockSipLogController.GetSipLogtData[index].rejectedQty.toString(), style: TextStyle(fontSize: 18)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                  ],
                                                                ),
                                                                // if (Dataconstants.algoLogModel.algoLog.logs[index].orderRef != "")
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Order Ref No. :",
                                                                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                                                        ),
                                                                        Text(StockSipLogController.GetSipLogtData[index].orderRef.toString(), style: TextStyle(fontSize: 18)),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                                                                  child: Divider(
                                                                    thickness: 2,
                                                                    color: theme.dividerColor,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding: const EdgeInsets.only(top: 2, bottom: 5, left: 0, right: 0),
                                                                  //  height: 40,

                                                                  // decoration: BoxDecoration(color: Colors.green,),
                                                                  child: Text(StockSipLogController.GetSipLogtData[index].description.toString(),
                                                                      style: TextStyle(fontSize: 18),
                                                                      softWrap: true,
                                                                      maxLines: 5,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      //  textDirection: TextDirection.rtl,
                                                                      textAlign: TextAlign.start

                                                                      // "Equity Margin Order Placed\nsuccessfully through RI reference\n20220305N100000305"
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              });
                                        },
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      );
          }
              //     Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Text(
              //         "No Algo Log",
              //         style: TextStyle(color: Colors.grey[600], fontSize: 15),
              //         textAlign: TextAlign.center,
              //       ),
              //       SizedBox(
              //         height: 10,
              //       ),
              //       OutlinedButton(
              //           style: OutlinedButton.styleFrom(
              //             side: BorderSide(
              //               color: theme.primaryColor,
              //             ),
              //           ),
              //           child: Text(
              //             'Refresh',
              //             style: TextStyle(color: theme.primaryColor),
              //           ),
              //           // onPressed: () => Dataconstants.itsClient.algoLog(
              //           //   instructionId: widget.instructionId,)
              //  )
              //     ],
              //   ),
              // ):

              ),
        ));
  }
}
