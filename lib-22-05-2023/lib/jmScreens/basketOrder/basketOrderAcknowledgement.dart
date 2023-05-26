import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../model/basket_order/getScripmFromBasket_model.dart';
import '../../model/exchData.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../mainScreen/MainScreen.dart';
import 'BasketWatch.dart';

class BasketAcknoeledgement extends StatefulWidget {
  final List<Datum2> enabledContract;

  const BasketAcknoeledgement({Key key, this.enabledContract}) : super(key: key);

  @override
  State<BasketAcknoeledgement> createState() => _BasketAcknoeledgementState();
}

class _BasketAcknoeledgementState extends State<BasketAcknoeledgement> {
  var isLight;

  @override
  void initState() {
    // TODO: implement initState
    isLight = ThemeConstants.themeMode.value == ThemeMode.light;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    Dataconstants.contractListOrderResponse.clear();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.appBarTheme.backgroundColor,
          title: Text(
            "Basket Order Acknowledgement",
            style: TextStyle(fontSize: 16, color: theme.textTheme.bodyText1.color),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: SizedBox(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.enabledContract.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          // height: 150,
                          width: width - 30,
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Column(
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${widget.enabledContract[index].model.marketWatchName}"),
                                      // SvgPicture.asset(
                                      //     "assets/images/Basket/${widget.enabledContract[index]..responseStatus == 200 ? 'completed.svg' : 'rejected.svg'}")
                                    ],
                                  ),
                                ),
                                width: width - 30,
                                height: 33,
                                decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 11.0, left: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 23,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(2)),
                                          color: widget.enabledContract[index].transactiontype == 'BUY' ? Color(0xff34C758).withOpacity(0.3) : ThemeConstants.sellColor.withOpacity(0.3)),
                                      child: Center(
                                          child: Text(
                                        "${widget.enabledContract[index].transactiontype}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: widget.enabledContract[index].transactiontype == 'BUY' ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0),
                                      )),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      height: 23,
                                      // width: Dataconstants
                                      //             .basketModel
                                      //             .filteredContractListOfBasket[
                                      //                 index]
                                      //             .lmtMktSlFlg
                                      //             .length ==
                                      //         5
                                      //     ? 55
                                      //     : 75,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2)), color: theme.primaryColor.withOpacity(0.3)),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3),
                                        child: Text(
                                          "${widget.enabledContract[index].ordertype}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w500, fontSize: 14.0),
                                        ),
                                      )),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            text: "Qty : ",
                                            style: TextStyle(color: Colors.grey),
                                            children: [TextSpan(text: "${widget.enabledContract[index].quantity}", style: DefaultTextStyle.of(context).style)])),
                                    // Text(
                                    //     "Qty : ${widget.enabledContract[index].boardLotQty}"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            text: "Price : ",
                                            style: TextStyle(color: Colors.grey),
                                            children: [TextSpan(text: "${widget.enabledContract[index].price}", style: DefaultTextStyle.of(context).style)])),
                                    // Text(
                                    //     "Price : ${widget.enabledContract[index].lmtRt}")
                                  ],
                                ),
                              ),
                              // Container(
                              //   width: width - 30,
                              //   height: 0.5,
                              //   decoration: BoxDecoration(
                              //       color: Color(0xff2E4052),
                              //       // color:
                              //       //     theme.scaffoldBackgroundColor,
                              //       borderRadius:
                              //           BorderRadius.circular(5)),
                              // ),
                              Divider(
                                height: 0,
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 15,
                              )
                              // Padding(
                              //   padding: const EdgeInsets.all(10.0),
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //         child: Text("abc"
                              //           // "${Dataconstants.contractListOrderResponse[index]["Success"]["message"]} ",
                              //           // maxLines: Dataconstants.contractListOrderResponse[index]["Success"]["message"].toString().length<50?1: 2,
                              //           // textAlign: Dataconstants.contractListOrderResponse[index]["Success"]["message"].toString().length<50?TextAlign.start:TextAlign.justify,
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
        bottomNavigationBar:
            // Dataconstants.exchData[0].exchangeStatus != ExchangeStatus.nesOpen ?
            Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        theme.scaffoldBackgroundColor,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: theme.primaryColor)),
                      )),
                  onPressed: () async {
                    Dataconstants.isComingFromGoToBasket = true;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => BasketWatch(isFromScripDetail: false),
                        ),
                        (Route<dynamic> route) => false);
                    Dataconstants.mainScreenIndex = 3;
                    Dataconstants.getAllBasketsController.fetchBasketList();
                    // Dataconstants.mainTabController.animateTo(3);
                  },
                  child: Container(
                    width: 140,
                    height: 45,
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(14))),
                    child: Center(
                      child: Text('Go To Basket',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFF5367FC)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: theme.primaryColor)),
                      )),
                  // side: MaterialStateProperty.all(
                  //     BorderSide(color: theme.primaryColor))),
                  onPressed: () async {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => MainScreen()));

                    // setState(() {
                    //                   Dataconstants.mainScreenIndex = 3;
                    //                   Dataconstants.isEquity = 4;
                    //                 });
                    //                 Navigator.pushReplacement(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                         builder: (context) => MainScreen(
                    //                           changePassword: false,
                    //                           message: '',
                    //                         )));

                    setState(() {
                      Dataconstants.mainScreenIndex = 3;
                      InAppSelection.mainScreenIndex = 3;
                      Dataconstants.isFromToolsToBasketOrder == false;
                    });
                    // Navigator.pop(context);
                    Dataconstants.isComingFromGoToBasket = true;

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MainScreen(
                              changePassword: false,
                              message: '',
                            )));

                    // Dataconstants.mainTabController.animateTo(2);
                  },
                  child: Container(
                    width: 140,
                    height: 45,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(14))),
                    child: Center(
                      child: Text('View Orders',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  )),
            ],
          ),
        )
        // : Padding(
        //     padding: const EdgeInsets.only(bottom: 10.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         ElevatedButton(
        //             style: ButtonStyle(
        //                 backgroundColor: MaterialStateProperty.all(
        //                   theme.scaffoldBackgroundColor,
        //                 ),
        //                 shape: MaterialStateProperty.all(
        //                   RoundedRectangleBorder(
        //                       borderRadius:
        //                           BorderRadius.all(Radius.circular(8)),
        //                       side: BorderSide(color: theme.primaryColor)),
        //                 )),
        //             onPressed: () async {
        //               Dataconstants.mainScreenIndex = 2;
        //               InAppSelection.portfolioReportScreenTabIndex = 2;
        //               Dataconstants.isComingFromGoToBasket = true;
        //
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (context) => MainScreen(
        //                         changePassword: false,
        //                         message: '',
        //                       )));
        //             },
        //             child: Container(
        //               width: 140,
        //               height: 45,
        //               // decoration: BoxDecoration(
        //               //     borderRadius: BorderRadius.all(Radius.circular(14))),
        //               child: Center(
        //                 child: Text('View Open Positions',
        //                     style: TextStyle(
        //                       fontSize: 14,
        //                       color: theme.primaryColor,
        //                       fontWeight: FontWeight.w500,
        //                     )),
        //               ),
        //             )),
        //         ElevatedButton(
        //             style: ButtonStyle(
        //                 backgroundColor:
        //                     MaterialStateProperty.all(Color(0xFF5367FC)),
        //                 shape: MaterialStateProperty.all(
        //                   RoundedRectangleBorder(
        //                       borderRadius:
        //                           BorderRadius.all(Radius.circular(8)),
        //                       side: BorderSide(color: theme.primaryColor)),
        //                 )),
        //             // side: MaterialStateProperty.all(
        //             //     BorderSide(color: theme.primaryColor))),
        //             onPressed: () async {
        //               // Navigator.pushReplacement(
        //               //     context,
        //               //     MaterialPageRoute(
        //               //         builder: (context) => MainScreen()));
        //               Dataconstants.mainScreenIndex = 1;
        //               Navigator.pop(context);
        //               Dataconstants.isComingFromGoToBasket = true;
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (context) => MainScreen(
        //                         changePassword: false,
        //                         message: '',
        //                       )));
        //
        //               // Dataconstants.mainTabController.animateTo(3);
        //             },
        //             child: Container(
        //               width: 140,
        //               height: 45,
        //               decoration: BoxDecoration(
        //                   borderRadius:
        //                       BorderRadius.all(Radius.circular(14))),
        //               child: Center(
        //                 child: Text('View Orders',
        //                     style: TextStyle(
        //                       fontSize: 14,
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w500,
        //                     )),
        //               ),
        //             )),
        //       ],
        //     ),
        //   ),
        );
  }
}
