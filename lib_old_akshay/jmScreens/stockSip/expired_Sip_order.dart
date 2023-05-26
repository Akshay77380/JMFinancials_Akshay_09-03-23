import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:markets/jmScreens/stockSip/stockSip_Log.dart';

import '../../controllers/stock_sip/get_sip_listController.dart';
import '../../model/stock_sip_model/stock_sip_model/get_sip_list.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../util/DateUtilBigul.dart';
import '../../util/Utils.dart';
import 'equity_sip_order_details.dart';
import 'equity_sip_order_screen.dart';
class ExpiredSiporderScreen extends StatefulWidget {
  // const ExpiredSiporderScreen({Key? key}) : super(key: key);

  @override
  State<ExpiredSiporderScreen> createState() => _ExpiredSiporderScreenState();
}

class _ExpiredSiporderScreenState extends State<ExpiredSiporderScreen> {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Obx((){
        return   GetSipListController.isLoading.value?Center(
          child: CircularProgressIndicator(),):
        GetSipListController.ExpiredSipListData.isEmpty?Center(child: Text('There\'s nothing here for now',),) :
        RefreshIndicator(
          onRefresh:  (){
            return  Dataconstants.getSipListController.fetchGetSipListData();
          },
            child: SingleChildScrollView(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15,),
                //   child: Column(
                //       children:[
                //         const SizedBox(
                //           height: 15,
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                     'CURRENT',
                //                     style: TextStyle( fontSize: 12,fontWeight: FontWeight.w500)
                //                 ),
                //                 Text('6,50,325.5',
                //                     style: TextStyle( fontSize: 14,fontWeight: FontWeight.w600)
                //                 )
                //               ],
                //             ),
                //             Column(
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               children: [
                //                 Text('OVERALL P/L',
                //                     style: TextStyle( fontSize: 12,fontWeight: FontWeight.w500)),
                //                 Text('50,325.5',
                //                     style: TextStyle( fontSize: 14,fontWeight: FontWeight.w600,color: ThemeConstants.buyColor))
                //               ],
                //             )
                //           ],
                //         ),
                //       ]
                //   ),
                // ),
                const SizedBox(height: 5,),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemCount: GetSipListController.ExpiredSipListData.length,
                    itemBuilder: (context, index) => ExpiredOrderDetails(
                        theme:theme,
                        ExpiredSipListData:GetSipListController.ExpiredSipListData[index]
                    )),
                const SizedBox(
                  height: 15,
                ),
                // CommonFunction.message('That’s all we have for you today'),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
        ),
          );
    })
    );
  }
}

class ExpiredOrderDetails extends StatelessWidget {
  final ThemeData theme;
  final  GetSipList ExpiredSipListData;
  ExpiredOrderDetails({ this.theme, this.ExpiredSipListData});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            // backgroundColor: Colors.transparent,
            builder: (context) => ExpiredBottomsheetDetails(ExpiredSipListData)
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 12,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(ExpiredSipListData.symbol.toString(), style: TextStyle( fontSize: 14,fontWeight: FontWeight.w600),),
                const SizedBox(width: 5,),
                Text(ExpiredSipListData.exch.toString(), style:  TextStyle(color: Colors.grey, fontSize: 12,fontWeight: FontWeight.w400),),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(3)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text(
                    double.parse(ExpiredSipListData.buyExchTradedRate.toString())>0.0?
                    "${(double.parse(ExpiredSipListData.model.close.toString())-double.parse(ExpiredSipListData.buyExchTradedRate.toString()))/
                        double.parse(ExpiredSipListData.buyExchTradedRate.toString())}%":"0%",
                    // '+12.5%',

                    style:TextStyle( fontSize: 13,fontWeight: FontWeight.w600,color: Colors.white), ),
                )

              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SIP Date', style:TextStyle(color: Colors.grey, fontSize: 12,fontWeight: FontWeight.w400),),
                    const SizedBox(height: 5,),
                    Text(DateUtilBigul.getDateStockEvent(ExpiredSipListData.startDate.toString().split("T")[0].toString().split(" ")[0].toString()).toString(),
                      style: TextStyle( fontSize: 14,fontWeight: FontWeight.w600),)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SIPs Done',
                      style:TextStyle(color: Colors.grey, fontSize: 12,fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      DateUtilBigul.getDateStockEvent(ExpiredSipListData.expiryDate.toString().split("T")[0].toString().split(" ")[0].toString()).toString(),
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('SIP Qty', style:TextStyle(color: Colors.grey, fontSize: 12,fontWeight: FontWeight.w400),),
                    const SizedBox(height: 5,),
                    Text(ExpiredSipListData.qty.toString(), style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Divider(thickness: 1,),
          ],
        ),
      ),

    );
  }
}

///////BOTTOMSHEET DETAILS///////


class ExpiredBottomsheetDetails extends StatefulWidget {
  final GetSipList expiredSipListData;
  ExpiredBottomsheetDetails(this.expiredSipListData);

  // const ExpiredBottomsheetDetails({Key? key}) : super(key: key);

  @override
  State<ExpiredBottomsheetDetails> createState() => _ExpiredBottomsheetDetailsState();
}

class _ExpiredBottomsheetDetailsState extends State<ExpiredBottomsheetDetails> {
  @override
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
                        decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      widthFactor: 0.25,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                        ),
                        onPressed: (){

                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EquitySipOrderScreen(
                                    isClone:true,
                                    isModify:false,
                                    model: widget.expiredSipListData,
                                  ),
                            ),
                          );
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                          // height: 40,
                          // width: 90,
                          child: Row(
                            children: [

                              SizedBox(width: 5),
                              Text("Clone",
                                  style: TextStyle(
                                      color: Colors.white,
                                      //Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400))
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color:theme.cardTheme.color,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "SIP Order Details",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Dataconstants.stockSipLogController.fetchGetSipLog(InstId:widget.expiredSipListData.instId.toString());

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StockSipLog(
                                                currentModel: widget.expiredSipListData.model,
                                              )));

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
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                     widget.expiredSipListData.qty.toString(),
                                        style: TextStyle(
                                            fontSize: 15, fontWeight: FontWeight.w700),
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
                                  //     Text(
                                  //       widget.expiredSipListData.buyExchTradedRate.toString(),
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
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text('Expired',
                                        style: TextStyle(
                                            color: ThemeConstants.themeMode.value == ThemeMode.dark?Color(0xFF7989FE): theme.primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              widget.expiredSipListData.symbol.toString(),
                                              style: TextStyle(
                                                  // color: Colors.black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Observer(
                                              builder: (_) => Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(
                                                      widget.expiredSipListData.model.close.toStringAsFixed(2),//percentChangeText
                                                      style: TextStyle(
                                                        // color: Colors.black,
                                                          fontSize: 17,
                                                          fontWeight:
                                                          FontWeight.w700),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${widget.expiredSipListData.model.priceChangeText} ${widget.expiredSipListData.model.percentChangeText}",
                                                        style: TextStyle(
                                                            color:  widget.expiredSipListData.model.priceChange>0
                                                                ? ThemeConstants.buyColor
                                                                : ThemeConstants.sellColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.w700),
                                                      ),
                                                      Icon(
                                                        widget.expiredSipListData.model.priceChange > 0
                                                            ? Icons.arrow_drop_up_rounded
                                                            : Icons.arrow_drop_down_rounded,
                                                        color:
                                                        widget.expiredSipListData.model.priceChange>0
                                                            ? ThemeConstants.buyColor
                                                            : ThemeConstants.sellColor,
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
                                    style: TextStyle(
                                         color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    widget.expiredSipListData.instId.toString(),
                                    style: TextStyle(
                                      // color: Colors.grey,
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
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    widget.expiredSipListData.sipPeriod.toString(),
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
                              //       "${int.parse(widget.expiredSipListData.expiryDate.toString().split("T")[0].toString().split(" ")[0].toString().split("-")[1].toString())-
                              //           int.parse(widget.expiredSipListData.startDate.toString().split("T")[0].toString().split(" ")[0].toString().split("-")[1].toString())}",
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
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    DateUtilBigul.getDateStockEvent(widget.expiredSipListData.startDate.toString().split("T")[0].toString().split(" ")[0].toString()).toString(),
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
                              // if (widget.status)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "End Date",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      DateUtilBigul.getDateStockEvent(widget.expiredSipListData.expiryDate.toString().split("T")[0].toString().split(" ")[0].toString()).toString(),
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



