import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:markets/jmScreens/stockSip/stockSip_Log.dart';
import '../../model/stock_sip_model/stock_sip_model/get_sip_list.dart';
import '../../style/theme.dart';
import '../../util/DateUtilBigul.dart';
import '../../util/Utils.dart';
import '../../util/Dataconstants.dart';
import 'equity_sip_order_screen.dart';

class EquitySipOrderDetails extends StatefulWidget {
  final bool status;
  final int instId;
  final GetSipList activeSessionList;

  // orderDatum order;

  EquitySipOrderDetails(this.status, this.instId, this.activeSessionList);

  @override
  State<EquitySipOrderDetails> createState() => _EquitySipOrderDetailsState();
}

class _EquitySipOrderDetailsState extends State<EquitySipOrderDetails> {
  @override
// var a,b,duration;
  @override
  void initState() {
    //    a = DateTime.parse(widget.activeSessionList.startDate.toString().split("T")[0].toString().split(" ")[0].toString());
    //    b = DateTime.parse(widget.activeSessionList.expiryDate.toString().split("T")[0].toString().split(" ")[0].toString());
    // if(widget.activeSessionList.sipPeriod=="Weekly"){
    //   duration =b.difference(a).inDays/7;
    // }else if(widget.activeSessionList.sipPeriod=="Yearly"){
    //   duration =b.difference(a).inDays/7;
    // }else if(widget.activeSessionList.sipPeriod=="Yearly"){
    //   duration =b.difference(a).inDays/7;
    // }

    // print(duration);
    super.initState();
  }

  //DateUtilBigul.getIntForSIP(widget.activeSessionList.expiryDate.toString().split("T")[0].toString().split(" ")[0].toString().split("-")[1].toString()).toString(),
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 280,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
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
                    decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(5)),
                  ),
                  widthFactor: 0.25,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () async {
                      var response = await Dataconstants.itsClient.pauseSip(widget.instId);
                      await Dataconstants.getSipListController.fetchGetSipListData();
                      Navigator.pop(context);
                      print("Pause sip Response => ${response["Status"]}");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                      // height: 40,
                      // width: 90,
                      child: Row(
                        children: [
                          Icon(
                            Icons.pause_circle_outline,
                            size: 20,
                            color: Colors.white, // Colors.grey,
                          ),
                          SizedBox(width: 5),
                          Text("Pause",
                              style: TextStyle(
                                  color: Colors.white,
                                  //Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                  ),

                  // SizedBox(width: 25,),
                  //  Spacer(),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: theme.primaryColor,
                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                  //   ),
                  //   onPressed: ()async{
                  //     var response =   await Dataconstants.itsClient.skipNextSip(widget.instId);
                  //     await  Dataconstants.getSipListController.fetchGetSipListData();
                  //     Navigator.pop(context);
                  //     print("Skip Next Sip Response => ${response["Status"]}");
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  //     // height: 40,
                  //     // width: 85,
                  //     child: Row(
                  //       children: [
                  //         Icon(
                  //           Icons.skip_next,
                  //           size: 20,
                  //           color: Colors.white,
                  //         ),
                  //         SizedBox(width: 5),
                  //         Text("Skip Next ",
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w400))
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EquitySipOrderScreen(
                            isModify: true,
                            isClone: false,
                            model: widget.activeSessionList,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                      // height: 40,
                      // width: 85,
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_note_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text("Modify", style: TextStyle(
                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () async {
                      var response = await Dataconstants.itsClient.stopSip(widget.instId);
                      await Dataconstants.getSipListController.fetchGetSipListData();
                      Navigator.pop(context);
                      print("Stop Sip Response => ${response["Status"]}");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                      // height: 40,
                      // width: 85,
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text("Stop ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: theme.cardTheme.color,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SIP Order Details",
                                style: TextStyle(fontSize: 20, color: theme.textTheme.bodyText1.color),
                              ),
                              InkWell(
                                onTap: () {
                                  Dataconstants.stockSipLogController.fetchGetSipLog(InstId: widget.activeSessionList.instId.toString());

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => StockSipLog(currentModel: widget.activeSessionList.model)));
                                },
                                child: Text(
                                  "SIP Log",
                                  style: TextStyle(
                                      color: theme.primaryColor,
                                      // color: theme.textTheme.bodyText1.color,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                              // OutlinedButton(
                              //   onPressed: () async {
                              //
                              //     // Navigator.push(
                              //     //     context,
                              //     //     MaterialPageRoute(
                              //     //         builder: (context) => StockSipLog()));
                              //     // CommonFunction.firebaselogEvent(true,"algo_log","_Click","algo_log");
                              //   },
                              //   style: OutlinedButton.styleFrom(
                              //     side: BorderSide(
                              //       width: 1.0,
                              //       color: theme.primaryColor,
                              //       style: BorderStyle.solid,
                              //     ),
                              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                              //   ),
                              //   child: Text(
                              //     "SIP Log",
                              //     style: TextStyle(
                              //         color: theme.primaryColor,
                              //         // color: theme.textTheme.bodyText1.color,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                            ],
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
                                    "QTY",
                                    style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.activeSessionList.qty.toString(),
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              // Column(
                              //   children: [
                              //     Text(
                              //       "Avg Price",
                              //       style: TextStyle(
                              //           color: Colors.grey,
                              //           fontSize: 15,
                              //           fontWeight: FontWeight.w400),
                              //     ),
                              //     Text(//BuyExchTradedRate
                              //       widget.activeSessionList.buyExchTradedRate.toString(),
                              //       style: TextStyle(
                              //           // color: Colors.grey,
                              //           fontSize: 15,
                              //           fontWeight: FontWeight.w400),
                              //     )
                              //   ],
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Status",
                                    style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "ACTIVE",
                                    // widget.status ? 'ACTIVE' : 'PAUSE',
                                    style: TextStyle(color: ThemeConstants.themeMode.value == ThemeMode.dark ? Color(0xFF7989FE) : theme.primaryColor, fontSize: 15, fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Utils.greyColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                )),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "SIP STOCK",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: Text(
                                          widget.activeSessionList.symbol.toString() == "" ? widget.activeSessionList.description.toString() : widget.activeSessionList.symbol.toString(),
                                          style: TextStyle(
                                              // color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Observer(
                                          builder: (_) => Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Text(
                                                      widget.activeSessionList.model.close.toStringAsFixed(2), //percentChangeText
                                                      style: TextStyle(
                                                          // color: Colors.black,
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${widget.activeSessionList.model.priceChangeText} ${widget.activeSessionList.model.percentChangeText}",
                                                        style: TextStyle(
                                                            color: widget.activeSessionList.model.priceChange > 0 ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w700),
                                                      ),
                                                      Icon(
                                                        widget.activeSessionList.model.priceChange > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                                        color: widget.activeSessionList.model.priceChange > 0 ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                                                        size: 30,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SIP Reference ID',
                                style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                widget.activeSessionList.instId.toString(),
                                style: TextStyle(
                                  // color: Colors.black,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Frequency",
                                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.activeSessionList.sipPeriod.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       "Period",
                          //       style: TextStyle(
                          //           color: Colors.grey,
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w400),
                          //     ),
                          //     Text(
                          //     // DateUtilBigul.getIntForSIP(widget.activeSessionList.expiryDate.toString().split("T")[0].toString().split(" ")[0].toString().split("-")[1].toString()).toString(),
                          //       "${int.parse(widget.activeSessionList.expiryDate.toString().split("T")[0].toString().split(" ")[0].toString().split("-")[1].toString())-
                          //           int.parse(widget.activeSessionList.startDate.toString().split("T")[0].toString().split(" ")[0].toString().split("-")[1].toString())}",
                          //
                          //       style: TextStyle(
                          //         // color: Colors.black,
                          //         fontSize: 14,
                          //       ),
                          //     )
                          //   ],
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Start Date",
                                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                DateUtilBigul.getDateStockEvent(widget.activeSessionList.startDate.toString().split("T")[0].toString().split(" ")[0].toString()).toString(),
                                style: TextStyle(
                                    // color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Next Date",
                                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                DateUtilBigul.getDateStockEvent(widget.activeSessionList.nextTradeDate.toString().split("T")[0].toString().split(" ")[0].toString()).toString(),
                                style: TextStyle(
                                  // color: Colors.black,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // if (widget.status)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "End Date",
                                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                DateUtilBigul.getDateStockEvent(widget.activeSessionList.expiryDate.toString().split("T")[0].toString().split(" ")[0].toString()).toString(),
                                style: TextStyle(
                                  // color: Colors.black,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
