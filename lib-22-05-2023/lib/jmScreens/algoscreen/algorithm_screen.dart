import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:markets/util/Utils.dart';
import '../../controllers/AlgoController/fetchAlgoController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../widget/algoWidget/search_text_widget.dart';
import 'advanceOrder_screen.dart';

class AlgorithmScreen extends StatefulWidget {
  final String scripnameFromScripDetail;
  final String closePriceFromScripDetail;
  final int scripCode;

  const AlgorithmScreen({Key key, this.scripnameFromScripDetail, this.closePriceFromScripDetail, this.scripCode}) : super(key: key);

  // const Await({Key? key}) : super(key: key);

  @override
  _AlgorithmScreenState createState() => _AlgorithmScreenState(scripnameFromScripDetail, closePriceFromScripDetail, scripCode);
}

class _AlgorithmScreenState extends State<AlgorithmScreen> {
  _AlgorithmScreenState(String scripnameFromScripDetail, closePriceFromScripDetail, scripCode);

  // String name='';
  var tempModel = null;

  @override
  void initState() {
    super.initState();
    // Dataconstants.itsClient.fetch();
    Dataconstants.fetchAlgoController.fetchAlgoList();

    // //print(" fetch algo respons ${FetchAlgoController.fetchAlgoLists.length}");

    // //print('isAlgoModify ${Dataconstants.isAwaitingAlgoModify}');

    // //print('isFromScripDetailToAdvanceScreen :${Dataconstants.isFromScripDetailToAdvanceScreen}');

    // //print('scripname from scripdetailscreen :${widget.scripnameFromScripDetail} ');
    // //print('close price from scripdetailscreen :${widget.closePriceFromScripDetail} ');
    // //print('scrip Code  from scripdetailscreen :${widget.scripCode} ');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    int index = 0;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          // automaticallyImplyLeading: false,
          title: Text(
            'Algorithm',
            // style: TextStyle(color: theme.textTheme.bodyText1.color),
            style: Utils.fonts(size: 20.0, fontWeight: FontWeight.w600, color: theme.textTheme.bodyText1.color),
          ),
        ),
        body: Obx(() {
          return FetchAlgoController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: theme.primaryColor,
                  ),
                )
              : FetchAlgoController.fetchAlgoLists.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "No Algos",
                            // style: TextStyle(color: theme.primaryColor,fontSize: 18,fontWeight: FontWeight.w500),
                            style: Utils.fonts(size: 20.0, fontWeight: FontWeight.w600, color: theme.textTheme.bodyText1.color),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(width: 1.0, color: Colors.white, style: BorderStyle.solid),
                              ),
                              // borderSide: (BorderSide(
                              //   color: theme.primaryColor,
                              // )),
                              child: Text(
                                'Refresh',
                                style: TextStyle(color: theme.primaryColor),
                              ),
                              onPressed: () => Dataconstants.fetchAlgoController.fetchAlgoList()),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: theme.primaryColor,
                      onRefresh: () => Dataconstants.fetchAlgoController.fetchAlgoList(),
                      child: Column(
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
                                elevation: 1,
                                margin: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom: 4,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0),
                                            child: SearchTextWidget(
                                                function: () {
                                                  // FinishedAl;
                                                },
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          if (FetchAlgoController.fetchAlgoLists.length <= 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 310),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Center(
                                    child: Text(
                                      "No Algo Found",
                                      style: TextStyle(color: theme.primaryColor, fontSize: 18, fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8, top: 3),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                    itemCount: FetchAlgoController.fetchAlgoLists.length,
                                    //   Dataconstants.fetchAlgoModel.fetchAlgo.algoId,
                                    shrinkWrap: true,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (Dataconstants.isFromScripDetailToAdvanceScreen == true)
                                            tempModel = CommonFunction.getScripDataModel(exch: widget.scripnameFromScripDetail, exchCode: widget.scripCode, getNseBseMap: true);
                                          var paramModel = FetchAlgoController.fetchAlgoLists[index].algoParam;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AdvanceOrder(
                                                      name: FetchAlgoController.fetchAlgoLists[index].algoName,
                                                      id: FetchAlgoController.fetchAlgoLists[index].algoId == 6 ? 3 : FetchAlgoController.fetchAlgoLists[index].algoId,
                                                      phrase: FetchAlgoController.fetchAlgoLists[index].algoPhrase,
                                                      type: FetchAlgoController.fetchAlgoLists[index].algoType,
                                                      segment: FetchAlgoController.fetchAlgoLists[index].algoSegment,
                                                      modifyModel: tempModel,
                                                      paramModel: paramModel,
                                                      algoPriceBetterment: FetchAlgoController.fetchAlgoLists[index].algoId == 6 ? true : false)));
                                          Dataconstants.algoScriptModel = null;
                                          // CommonFunction.firebaselogEvent(true,"algo_select","_Click","algo_select");
                                          // //print("params : ${FetchAlgoController.fetchAlgoLists[index].algoParam} ");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 3),
                                          child: Card(
                                            elevation: 1,
                                            color: theme.cardColor,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        FetchAlgoController.fetchAlgoLists[index].algoName,
                                                        // 'Moving Average',
                                                        // style: TextStyle(
                                                        //     fontSize: 16,
                                                        //     fontWeight:
                                                        //     FontWeight.w600),

                                                        style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w600),
                                                      ),
                                                      // Card(
                                                      //     elevation: 8,
                                                      //     shape: RoundedRectangleBorder(
                                                      //         borderRadius:
                                                      //         BorderRadius.all(
                                                      //             Radius.circular(
                                                      //                 30))),
                                                      //     color: theme.cardTheme.color,
                                                      //     child: Container(
                                                      //         height: 30,
                                                      //         width: 30,
                                                      //         decoration: BoxDecoration(
                                                      //             borderRadius:
                                                      //             BorderRadius.all(
                                                      //                 Radius
                                                      //                     .circular(
                                                      //                     20))),
                                                      //         child: RotationTransition(
                                                      //           turns:
                                                      //           new AlwaysStoppedAnimation(
                                                      //               20 / 360),
                                                      //           child: Icon(
                                                      //               Icons.push_pin,
                                                      //               size: 15,
                                                      //               color: theme
                                                      //                   .textTheme
                                                      //                   .bodyText1
                                                      //                   .color),
                                                      //         )))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    FetchAlgoController.fetchAlgoLists[index].algoPhrase,
                                                    //'MACD',
                                                    // style:
                                                    // TextStyle(fontSize: 11,color: theme.textTheme.bodyText1.color),
                                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color),
                                                  ),

                                                  // Container(
                                                  //   // height: 20,
                                                  //   // width: 275,
                                                  //   padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.5),
                                                  //   decoration: BoxDecoration(
                                                  //       // color: Colors.lightBlue[900],
                                                  //       border: Border.all(
                                                  //         width: 1,
                                                  //         color: Colors.transparent,
                                                  //         // color: Colors.lightBlue,
                                                  //       ),
                                                  //       // borderRadius: BorderRadius.all(
                                                  //       //     Radius.circular(20))
                                                  //
                                                  //   ),
                                                  //   child: Text(
                                                  //     FetchAlgoController.fetchAlgoLists[index]
                                                  //         .algoPhrase,
                                                  //     //'MACD',
                                                  //     style:
                                                  //     TextStyle(fontSize: 11,color: theme.textTheme.bodyText1.color),
                                                  //   ),
                                                  // ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Type: ',
                                                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                                                            // style: TextStyle(
                                                            //     color: Colors.grey),
                                                          ),
                                                          Text(
                                                            FetchAlgoController.fetchAlgoLists[index].algoType,
                                                            style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color),
                                                            //' Trend Following'
                                                          ),
                                                        ],
                                                      ),
                                                      Container(height: 20, width: 1, color: Colors.grey // theme.textTheme.bodyText1.color,

                                                          ),
                                                      //   SizedBox(width: 50,),
                                                      // DottedLine(
                                                      //   dashLength: 3,
                                                      //   dashGapLength: 2,
                                                      //   lineThickness: 2,
                                                      //   dashColor: Colors.grey,
                                                      //   dashGapColor:
                                                      //   Colors.transparent,
                                                      //   direction: Axis.vertical,
                                                      //   lineLength: 20,
                                                      // ),
                                                      //    Spacer(),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Segment:',
                                                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                                                            // style: TextStyle(
                                                            //     color: Colors.grey),
                                                          ),
                                                          Text(' '
                                                              '${FetchAlgoController.fetchAlgoLists[index].algoSegment}'),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
        })

        // Observer(  builder: (context) => Dataconstants.fetchAlgoModel.fetchingOrders == false?Center(
        //   child: CircularProgressIndicator(
        //     valueColor: AlwaysStoppedAnimation(theme.primaryColor),
        //   ),
        // ):Dataconstants.fetchAlgoModel.fetchingOrders==null? Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text(
        //         "No Algo's",
        //         style: TextStyle(color: theme.primaryColor,fontSize: 18,fontWeight: FontWeight.w500),
        //         textAlign: TextAlign.center,
        //       ),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       OutlineButton(
        //           borderSide: (BorderSide(
        //             color: theme.primaryColor,
        //           )),
        //           child: Text(
        //             'Refresh',
        //             style: TextStyle(color: theme.primaryColor),
        //           ),
        //           onPressed: () => Dataconstants.itsClient.fetch()),
        //     ],
        //   ),
        // ):
        // RefreshIndicator(
        //   color: theme.primaryColor,
        //   onRefresh: () => Dataconstants.itsClient.fetch(),
        //   child: Column(
        //     children: [
        //       Stack(
        //         children: [
        //           Container(
        //             height: 24,
        //             // color: Colors.grey,
        //             color: theme.appBarTheme.color,
        //           ),
        //           Card(
        //             color: theme.accentColor,
        //             elevation: 5,
        //             margin: EdgeInsets.only(
        //               left: 10,
        //               right: 10,
        //               bottom: 4,
        //             ),
        //             child: Container(
        //               padding: EdgeInsets.symmetric(horizontal: 5),
        //               child: Row(
        //                   children: [
        //                     Expanded(
        //                       child: Column(
        //                         mainAxisSize: MainAxisSize.min,
        //                         children: [
        //                           Padding(
        //                             padding:
        //                             const EdgeInsets.only(left: 20.0),
        //                             child: SearchTextWidget(
        //                               function: Dataconstants.fetchAlgoModel
        //                                   .updateFetchAlgoFilteredOrdersBySearch,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //
        //                   ]
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       if(FetchAlgoController.fetchAlgoLists.length<=0)
        //         Padding(
        //           padding: const EdgeInsets.only(top: 310),
        //           child: Align(
        //               alignment: Alignment.bottomCenter,
        //               child: Center(child: Text("No Algo Found",style: TextStyle(color: theme.primaryColor,fontSize: 18,fontWeight: FontWeight.w500),),)),
        //         ),
        //       Expanded(
        //         child: Padding(
        //           padding: const EdgeInsets.only(
        //               bottom: 10, left: 8, right: 8, top: 3),
        //           child: Container(
        //             height: MediaQuery.of(context).size.height,
        //             child: ListView.builder(
        //                 itemCount:FetchAlgoController.fetchAlgoLists.length,
        //                 //   Dataconstants.fetchAlgoModel.fetchAlgo.algoId,
        //                 shrinkWrap: true,
        //                 physics: AlwaysScrollableScrollPhysics(),
        //                 itemBuilder: (context, index) {
        //                   return InkWell(
        //                     onTap: () {
        //
        //
        //                       if(Dataconstants.isFromScripDetailToAdvanceScreen == true)
        //                         tempModel = CommonFunction.getScripDataModel(
        //                             exch: widget.scripnameFromScripDetail,
        //                             exchCode: widget.scripCode,
        //                             getNseBseMap: true);
        //                       var paramModel=FetchAlgoController.fetchAlgoLists[index].algoParam;
        //                       Navigator.push(
        //                           context,
        //                           MaterialPageRoute(
        //
        //                               builder: (context) => AdvanceOrder(
        //                                 name: FetchAlgoController.fetchAlgoLists[index]
        //                                     .algoName,
        //                                 id: FetchAlgoController.fetchAlgoLists[index].algoId,
        //                                 phrase: Dataconstants
        //                                     .fetchAlgoModel
        //                                     .fetchAlgoLists[index]
        //                                     .algoPhrase,
        //                                 type: Dataconstants
        //                                     .fetchAlgoModel
        //                                     .fetchAlgoLists[index]
        //                                     .algoType,
        //                                 segment: FetchAlgoController.fetchAlgoLists[index].algoSegment,
        //                                 modifyModel: tempModel,
        //                                 paramModel:paramModel,
        //                               )));
        //                       Dataconstants.algoScriptModel = null;
        //
        //                       // //print("params : ${FetchAlgoController.fetchAlgoLists[index].algoParam} ");
        //
        //                     },
        //                     child: Padding(
        //                       padding: const EdgeInsets.only(bottom: 3),
        //                       child: Card(
        //                         elevation: 5,
        //                         color: theme.cardColor,
        //                         child: Padding(
        //                           padding: const EdgeInsets.only(
        //                               top: 5,
        //                               bottom: 10,
        //                               left: 10,
        //                               right: 10),
        //                           child: Column(
        //                             crossAxisAlignment:
        //                             CrossAxisAlignment.start,
        //                             children: [
        //                               Row(
        //                                 mainAxisAlignment:
        //                                 MainAxisAlignment.spaceBetween,
        //                                 children: [
        //                                   Text(
        //                                     Dataconstants
        //                                         .fetchAlgoModel
        //                                         .fetchAlgoLists[index]
        //                                         .algoName,
        //                                     // 'Moving Average',
        //                                     style: TextStyle(
        //                                         fontSize: 16,
        //                                         fontWeight:
        //                                         FontWeight.w600),
        //                                   ),
        //                                   // Card(
        //                                   //     elevation: 8,
        //                                   //     shape: RoundedRectangleBorder(
        //                                   //         borderRadius:
        //                                   //         BorderRadius.all(
        //                                   //             Radius.circular(
        //                                   //                 30))),
        //                                   //     color: theme.cardTheme.color,
        //                                   //     child: Container(
        //                                   //         height: 30,
        //                                   //         width: 30,
        //                                   //         decoration: BoxDecoration(
        //                                   //             borderRadius:
        //                                   //             BorderRadius.all(
        //                                   //                 Radius
        //                                   //                     .circular(
        //                                   //                     20))),
        //                                   //         child: RotationTransition(
        //                                   //           turns:
        //                                   //           new AlwaysStoppedAnimation(
        //                                   //               20 / 360),
        //                                   //           child: Icon(
        //                                   //               Icons.push_pin,
        //                                   //               size: 15,
        //                                   //               color: theme
        //                                   //                   .textTheme
        //                                   //                   .bodyText1
        //                                   //                   .color),
        //                                   //         )))
        //                                 ],
        //                               ),
        //                               SizedBox(
        //                                 height: 20,
        //                               ),
        //                               Container(
        //                                 // height: 20,
        //                                 // width: 275,
        //                                 padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.5),
        //                                 decoration: BoxDecoration(
        //                                     color: Colors.lightBlue[900],
        //                                     border: Border.all(
        //                                       width: 1,
        //                                       color: Colors.lightBlue,
        //                                     ),
        //                                     borderRadius: BorderRadius.all(
        //                                         Radius.circular(20))),
        //                                 child: Text(
        //                                   Dataconstants
        //                                       .fetchAlgoModel
        //                                       .fetchAlgoLists[index]
        //                                       .algoPhrase,
        //                                   //'MACD',
        //                                   style:
        //                                   TextStyle(fontSize: 11,color: Colors.white),
        //                                 ),
        //                               ),
        //                               SizedBox(
        //                                 height: 12,
        //                               ),
        //                               Row(
        //                                 mainAxisAlignment:
        //                                 MainAxisAlignment.spaceBetween,
        //                                 children: <Widget>[
        //                                   Row(
        //                                     children: [
        //                                       Text(
        //                                         'Type: ',
        //                                         style: TextStyle(
        //                                             color: Colors.grey),
        //                                       ),
        //                                       Text(Dataconstants
        //                                           .fetchAlgoModel
        //                                           .fetchAlgoLists[index]
        //                                           .algoType
        //
        //                                         //' Trend Following'
        //
        //                                       ),
        //                                     ],
        //                                   ),
        //                                   Container(
        //                                       height: 20,
        //                                       width: 1,
        //                                       color: Colors.grey// theme.textTheme.bodyText1.color,
        //
        //                                   ),
        //                                   //   SizedBox(width: 50,),
        //                                   // DottedLine(
        //                                   //   dashLength: 3,
        //                                   //   dashGapLength: 2,
        //                                   //   lineThickness: 2,
        //                                   //   dashColor: Colors.grey,
        //                                   //   dashGapColor:
        //                                   //   Colors.transparent,
        //                                   //   direction: Axis.vertical,
        //                                   //   lineLength: 20,
        //                                   // ),
        //                                   //    Spacer(),
        //                                   Row(
        //                                     children: [
        //                                       Text(
        //                                         'Segment:',
        //                                         style: TextStyle(
        //                                             color: Colors.grey),
        //                                       ),
        //                                       Text(' '
        //                                           '${FetchAlgoController.fetchAlgoLists[index].algoSegment}'),
        //                                     ],
        //                                   )
        //                                 ],
        //                               )
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   );
        //                 }),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
        // ),
        );
  }
}
