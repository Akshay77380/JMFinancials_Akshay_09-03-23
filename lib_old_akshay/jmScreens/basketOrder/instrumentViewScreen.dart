import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:markets/jmScreens/basketOrder/BasketWatch.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../Controllers/Basket_order/getScripFromBasket_controller.dart';
import '../../model/basket_order/getAllBasket_model.dart';
import '../../model/basket_order/getScripmFromBasket_model.dart';
import '../../model/exchData.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/search_bar_screen.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../widget/slider_button.dart';
import 'basketOrderAcknowledgement.dart';
import 'instrument_modify_screen.dart';
import 'instrument_option_modify_screen.dart';

class AllInstrumentScreen extends StatefulWidget {
  String basketName;
  String date;
  String noOfInstruments;
  String series;
  Datum model;

  AllInstrumentScreen({
    this.basketName,
    this.date,
    this.noOfInstruments,
    this.series,
    Key key,
    this.model,
  }) : super(key: key);

  @override
  State<AllInstrumentScreen> createState() => _AllInstrumentScreenState();
}

class _AllInstrumentScreenState extends State<AllInstrumentScreen> with TickerProviderStateMixin {
  bool isContractEnabled = false;
  bool isPositionIncluded = false;
  String finalMargin = "0", requiredMargin = "0";
  AnimationController animationController;
  bool isLight, visible = true;
  int count = 0;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  List<Datum2> enabledContract = [];

  @override
  void initState() {
    // print(
    //     "isspan => ${Dataconstants.accountInfo[Dataconstants.currentSelectedAccount].isSpan}");
    // callContractList();

    Dataconstants.series = widget.series;
    Dataconstants.basketName = widget.basketName;
    // Dataconstants.basketID = widget.model.basketId;
    Dataconstants.shouldShowExecuteButton = true;
    isLight = ThemeConstants.themeMode.value == ThemeMode.light;
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    // log("print list of placing order list => ${Dataconstants.basketModel.filteredListForPlacingOrder}");

    // TODO: implement initState

    super.initState();
  }

  callContractList() async {
    // Dataconstants.basketModel.finalMargin = "0";
    // Dataconstants.basketModel.requiredMargin = "0";

    await Dataconstants.getScripFromBasketController.getScripmFromBasket(basketId: Dataconstants.basketID);
    // await Dataconstants.itsClient.basketOrderForFno(
    //     requestType: 'F',
    //     exchCode: 'NFO',
    //     routeCrt: '333',
    //     symbol: widget.basketName,
    //     series: widget.series);
    // CommonFunction.margin(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Dataconstants.isShowLoaderForExexuting = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
              // behavior: HitTestBehavior.opaque,
              onTap: () {
                Dataconstants.getAllBasketsController.fetchBasketList();
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back)),
          title: FittedBox(
            child: Row(
              children: [
                Icon(
                  Icons.shopping_basket_outlined,
                  size: 20,
                  color: isLight ? Color(0xff737373) : Color(0xffFFFFFF),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${Dataconstants.isBasketNamemodified ? Dataconstants.newBasketName : widget.basketName}",
                  style: TextStyle(fontSize: 18, color: isLight ? Color(0xff737373) : Color(0xffFFFFFF)),
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                    // backgroundColor:
                    //     theme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // shape: const RoundedRectangleBorder(
                    //     borderRadius:
                    //         BorderRadius.vertical(
                    //             top: Radius.circular(
                    //                 15.0))),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return CreateNewBasket(existingBasketName: Dataconstants.newBasketName, series: "NSE", basketId: widget.model == null ? Dataconstants.basketID : widget.model.basketId);
                    });
              },
              child: Icon(Icons.edit, size: 20, color: isLight ? Color(0xff737373) : Color(0xffFFFFFF)),

              // SvgPicture.asset(
              //     'assets/images/Basket/edit.svg',
              //     color: isLight
              //         ? Color(0xff737373)
              //         : Color(0xffFFFFFF))
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    // backgroundColor:
                    //     theme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0))),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius:
                    //         BorderRadius.circular(10)),
                    context: context,
                    builder: (context) {
                      return Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 30, left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                  child: Container(
                                width: 50,
                                height: 8,
                                decoration: BoxDecoration(color: Color(0xff4A4A4A), borderRadius: BorderRadius.circular(5)),
                              )),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Do you want to delete this basket?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 40,
                                      decoration: BoxDecoration(border: Border.all(color: theme.primaryColor), borderRadius: BorderRadius.all(Radius.circular(5))),
                                      child: Center(
                                        child: Text('Cancel',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF5367FC)), side: MaterialStateProperty.all(BorderSide(color: theme.primaryColor))),
                                      onPressed: () async {
                                        var result = await Dataconstants.itsClient.deleteBasket(widget.model == null ? Dataconstants.basketID : widget.model.basketId);
                                        if (result['status'] == true) {
                                          // Navigator.of(context).popUntil((route) => route.isFirst);

                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (_) => BasketWatch(isFromScripDetail: false),
                                              ), (route) => false
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text("Basket deleted successfully"),
                                          ));
                                          Dataconstants.getAllBasketsController.fetchBasketList();
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 40,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                                        child: Center(
                                          child: Text('Delete',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                      )),
                                ],
                              ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                            ],
                          ));
                    });
              },
              child: Icon(
                Icons.delete,
                size: 20,
                color: isLight ? Color(0xff737373) : Color(0xffFFFFFF),
              ),

              // SvgPicture.asset(
              //     'assets/images/Basket/delete.svg',
              //     color: isLight
              //         ? Color(0xff000000)
              //         : Color(0xffFFFFFF)),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
        key: _scaffoldKey,
        body: WillPopScope(
          onWillPop: () {
            Dataconstants.getAllBasketsController.fetchBasketList();
            return Future.value(true);
          },
          child: SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      color: theme.appBarTheme.color,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 0, right: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              // Row(
                              //   children: [
                              //     GestureDetector(
                              //         behavior: HitTestBehavior.opaque,
                              //         onTap: () {
                              //           Dataconstants.getAllBasketsController.fetchBasketList();
                              //           Navigator.of(context).pop();
                              //         },
                              //         child: Icon(Icons.arrow_back)
                              //         // SvgPicture.asset(
                              //         //             'assets/images/Basket/arrow.svg',
                              //         //             color: isLight
                              //         //                 ? Color(0xff737373)
                              //         //                 : Color(0xffFFFFFF),
                              //         //           )
                              //         ),
                              //     SizedBox(
                              //       width: 25,
                              //     ),
                              //     Icon(Icons.shopping_basket_outlined,size: 20,color:
                              //     isLight
                              //         ? Color(0xff737373)
                              //         : Color(0xffFFFFFF),),
                              //     // SvgPicture.asset(
                              //     //   'assets/images/Basket/basket.svg',
                              //     //   color: isLight
                              //     //       ? Color(0xff737373)
                              //     //       : Color(0xffFFFFFF),
                              //     // ),
                              //     SizedBox(
                              //       width: 10,
                              //     ),
                              //     Text(
                              //       "${Dataconstants.isBasketNamemodified ? Dataconstants.newBasketName : widget.basketName}",
                              //       style: TextStyle(
                              //           fontSize: 18,
                              //           color: isLight
                              //               ? Color(0xff737373)
                              //               : Color(0xffFFFFFF)),
                              //     ),
                              //     SizedBox(
                              //       width: 20,
                              //     ),
                              //     GestureDetector(
                              //         onTap: () async {
                              //           await showModalBottomSheet(
                              //               // backgroundColor:
                              //               //     theme.scaffoldBackgroundColor,
                              //               shape: RoundedRectangleBorder(
                              //                   borderRadius:
                              //                       BorderRadius.circular(10)),
                              //               // shape: const RoundedRectangleBorder(
                              //               //     borderRadius:
                              //               //         BorderRadius.vertical(
                              //               //             top: Radius.circular(
                              //               //                 15.0))),
                              //               isScrollControlled: true,
                              //               context: context,
                              //               builder: (context) {
                              //                 return CreateNewBasket(
                              //                   existingBasketName: Dataconstants.newBasketName,
                              //                     series:"NSE",
                              //                     basketId:widget.model==null?Dataconstants.basketID:widget.model.basketId
                              //                 );
                              //               });
                              //         },
                              //         child:
                              //         Icon(Icons.edit,size: 20,color:isLight
                              //             ? Color(0xff737373)
                              //             : Color(0xffFFFFFF)),
                              //
                              //         // SvgPicture.asset(
                              //         //     'assets/images/Basket/edit.svg',
                              //         //     color: isLight
                              //         //         ? Color(0xff737373)
                              //         //         : Color(0xffFFFFFF))
                              //
                              //     ),
                              //     Spacer(),
                              //     GestureDetector(
                              //       onTap: () {
                              //         showModalBottomSheet(
                              //             // backgroundColor:
                              //             //     theme.scaffoldBackgroundColor,
                              //             shape: RoundedRectangleBorder(
                              //                 borderRadius: BorderRadius.only(
                              //                     topRight: Radius.circular(10.0),
                              //                     topLeft:
                              //                         Radius.circular(10.0))),
                              //             // shape: RoundedRectangleBorder(
                              //             //     borderRadius:
                              //             //         BorderRadius.circular(10)),
                              //             context: context,
                              //             builder: (context) {
                              //               return Padding(
                              //                   padding: EdgeInsets.only(
                              //                       top: 10,
                              //                       bottom: 30,
                              //                       left: 10,
                              //                       right: 10),
                              //                   child: Column(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment.start,
                              //                     crossAxisAlignment:
                              //                         CrossAxisAlignment.start,
                              //                     mainAxisSize: MainAxisSize.min,
                              //                     children: [
                              //                       Center(
                              //                           child: Container(
                              //                         width: 50,
                              //                         height: 8,
                              //                         decoration: BoxDecoration(
                              //                             color:
                              //                                 Color(0xff4A4A4A),
                              //                             borderRadius:
                              //                                 BorderRadius
                              //                                     .circular(5)),
                              //                       )),
                              //                       SizedBox(
                              //                         height: 20,
                              //                       ),
                              //                       Center(
                              //                         child: Column(
                              //                           children: [
                              //                             Text(
                              //                               'Do you want to delete this basket?',
                              //                               style: TextStyle(
                              //                                 fontSize: 14,
                              //                                 fontWeight:
                              //                                     FontWeight.w400,
                              //                               ),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                       SizedBox(
                              //                         height: 20,
                              //                       ),
                              //                       Row(
                              //                         mainAxisAlignment:
                              //                             MainAxisAlignment
                              //                                 .spaceEvenly,
                              //                         children: [
                              //                           GestureDetector(
                              //                             onTap: () {
                              //                               Navigator.of(context)
                              //                                   .pop();
                              //                             },
                              //                             child: Container(
                              //                               width: 150,
                              //                               height: 40,
                              //                               decoration: BoxDecoration(
                              //                                   border: Border.all(
                              //                                       color: theme
                              //                                           .primaryColor),
                              //                                   borderRadius: BorderRadius
                              //                                       .all(Radius
                              //                                           .circular(
                              //                                               5))),
                              //                               child: Center(
                              //                                 child: Text(
                              //                                     'Cancel',
                              //                                     style:
                              //                                         TextStyle(
                              //                                       fontSize: 14,
                              //                                       color: theme
                              //                                           .primaryColor,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .w500,
                              //                                     )),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                           ElevatedButton(
                              //                               style: ButtonStyle(
                              //                                   backgroundColor:
                              //                                       MaterialStateProperty
                              //                                           .all(Color(
                              //                                           0xFF5367FC)),
                              //                                   side: MaterialStateProperty
                              //                                       .all(BorderSide(
                              //                                           color: theme
                              //                                               .primaryColor))),
                              //                               onPressed: () async {
                              //
                              //                                 var result = await Dataconstants.itsClient.deleteBasket(widget.model.basketId);
                              //                                 if (result['status'] ==true) {
                              //                                   Navigator.of(context).popUntil((route) => route.isFirst);
                              //                                   Dataconstants.getAllBasketsController.fetchBasketList();
                              //                                 }
                              //                               },
                              //                               child: Container(
                              //                                 width: 120,
                              //                                 height: 40,
                              //                                 decoration: BoxDecoration(
                              //                                     borderRadius: BorderRadius
                              //                                         .all(Radius
                              //                                             .circular(
                              //                                                 5))),
                              //                                 child: Center(
                              //                                   child: Text(
                              //                                       'Delete',
                              //                                       style:
                              //                                           TextStyle(
                              //                                         fontSize:
                              //                                             14,
                              //                                         color: Colors
                              //                                             .white,
                              //                                         fontWeight:
                              //                                             FontWeight
                              //                                                 .w500,
                              //                                       )),
                              //                                 ),
                              //                               )),
                              //                         ],
                              //                       ),
                              //                       // SizedBox(
                              //                       //   height: 15,
                              //                       // ),
                              //                     ],
                              //                   ));
                              //             });
                              //       },
                              //       child:Icon(Icons.delete,size: 20, color: isLight
                              //           ? Color(0xff737373)
                              //           : Color(0xffFFFFFF),),
                              //
                              //       // SvgPicture.asset(
                              //       //     'assets/images/Basket/delete.svg',
                              //       //     color: isLight
                              //       //         ? Color(0xff000000)
                              //       //         : Color(0xffFFFFFF)),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() {
                                    return Text(
                                      '${GetScripFromBasketController.ScripListList.length}/20 items',
                                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14.0),
                                    );
                                  }),
                                  Text('Created on ${widget.date}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14.0)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      height:
                          // Dataconstants.basketModel.filteredContractListOfBasket.length ==
                          //         0
                          //     ? 30
                          //     :
                          40,
                      width: width,
                    ),
                    // Card(
                    //     color: theme.accentColor,
                    //     margin: EdgeInsets.only(
                    //       left: 20,
                    //       top: 105,
                    //       right: 20,
                    //       // bottom: 3,
                    //     ),
                    //     elevation: 2,
                    //     child: Observer(builder: (context) {
                    //       return Row(
                    //         children: [
                    //           Dataconstants.basketModel
                    //                       .filteredContractListOfBasket.length ==
                    //                   0
                    //               ? SizedBox.shrink()
                    //               : Container(
                    //                   height: 105,
                    //                   decoration: BoxDecoration(
                    //                       color: theme.accentColor,
                    //                       borderRadius: BorderRadius.all(
                    //                           Radius.circular(4))),
                    //                   child: Column(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.start,
                    //                     children: [
                    //                       Padding(
                    //                         padding: EdgeInsets.only(
                    //                           left: 25,
                    //                           // top: 5,
                    //                         ),
                    //                         child: Column(
                    //                           children: [
                    //                             Row(
                    //                               children: [
                    //                                 Column(
                    //                                   crossAxisAlignment:
                    //                                       CrossAxisAlignment
                    //                                           .start,
                    //                                   children: [
                    //                                     SizedBox(
                    //                                       height: 10,
                    //                                     ),
                    //                                     Text(
                    //                                       'Req. Margin',
                    //                                       style: TextStyle(
                    //                                           fontSize: 14,
                    //                                           fontWeight:
                    //                                               FontWeight.w400,
                    //                                           color: theme
                    //                                               .indicatorColor
                    //                                               .withOpacity(
                    //                                                   0.5)),
                    //                                     ),
                    //                                     SizedBox(
                    //                                       height: 7,
                    //                                     ),
                    //                                     Observer(
                    //                                         builder: (context) {
                    //                                       return Text(
                    //                                           "₹${CommonFunction.currencyFormat(double.parse(Dataconstants.basketModel.requiredMargin))}",
                    //                                           style: TextStyle(
                    //                                             fontSize: 18,
                    //                                             fontWeight:
                    //                                                 FontWeight
                    //                                                     .w600,
                    //                                           ));
                    //                                     }),
                    //                                     SizedBox(
                    //                                       height: 10,
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                                 SizedBox(
                    //                                   width: 40,
                    //                                 ),
                    //                                 Column(
                    //                                   crossAxisAlignment:
                    //                                       CrossAxisAlignment
                    //                                           .start,
                    //                                   children: [
                    //                                     SizedBox(
                    //                                       height: 10,
                    //                                     ),
                    //                                     Text(
                    //                                       'Final Margin',
                    //                                       style: TextStyle(
                    //                                           fontSize: 14,
                    //                                           fontWeight:
                    //                                               FontWeight.w400,
                    //                                           color: theme
                    //                                               .indicatorColor
                    //                                               .withOpacity(
                    //                                                   0.5)),
                    //                                     ),
                    //                                     SizedBox(
                    //                                       height: 8,
                    //                                     ),
                    //                                     Observer(
                    //                                         builder: (context) {
                    //                                       return Text(
                    //                                           "₹${CommonFunction.currencyFormat(double.parse(Dataconstants.basketModel.finalMargin))}",
                    //                                           style: TextStyle(
                    //                                             fontSize: 18,
                    //                                             fontWeight:
                    //                                                 FontWeight
                    //                                                     .w600,
                    //                                           ));
                    //                                     }),
                    //                                     SizedBox(
                    //                                       height: 10,
                    //                                     ),
                    //                                   ],
                    //                                 )
                    //                               ],
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                       Container(
                    //                         width: 352,
                    //                         height: 1,
                    //                         decoration: BoxDecoration(
                    //                             color:
                    //                                 Colors.grey.withOpacity(0.5),
                    //                             borderRadius:
                    //                                 BorderRadius.circular(5)),
                    //                       ),
                    //                       Padding(
                    //                         padding: EdgeInsets.only(
                    //                           left: 25,
                    //                           top: 10,
                    //                         ),
                    //                         child: GestureDetector(
                    //                           onTap: () {
                    //                             setState(() {
                    //                               if (isPositionIncluded) {
                    //                                 isPositionIncluded = false;
                    //                                 Dataconstants
                    //                                         .globalIncludeOpenPosition =
                    //                                     isPositionIncluded;
                    //                                 CommonFunction.margin(
                    //                                     isPositionIncluded);
                    //                               } else {
                    //                                 isPositionIncluded = true;
                    //                                 Dataconstants
                    //                                         .globalIncludeOpenPosition =
                    //                                     isPositionIncluded;
                    //                                 CommonFunction.margin(
                    //                                     isPositionIncluded);
                    //                               }
                    //                             });
                    //                           },
                    //                           child: Row(
                    //                             children: [
                    //                               SvgPicture.asset(
                    //                                 "assets/images/Basket/${isPositionIncluded ? 'blueTick.svg' : 'greyTick.svg'}",
                    //                                 color: isPositionIncluded
                    //                                     ? Color(0xff03A9F5)
                    //
                    //                                     // Color(0xff737373)
                    //                                     //     Color(0xff03A9F5)
                    //                                     : theme.indicatorColor
                    //                                         .withOpacity(0.5),
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 10,
                    //                               ),
                    //                               Text(
                    //                                 "Include existing positions",
                    //                                 style: TextStyle(
                    //                                   color: isPositionIncluded
                    //                                       ? Color(0xff03A9F5)
                    //                                       : theme.indicatorColor
                    //                                           .withOpacity(0.5),
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 ),
                    //         ],
                    //       );
                    //     })),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    onTap: () {
                      Dataconstants.isFromBasketOrder = true;
                      Dataconstants.basketName = widget.basketName;
                      if (widget.model != null) Dataconstants.basketID = widget.model.basketId;
                      Dataconstants.isComingFromBasketSearch = true;

                      showSearch(
                        context: context,
                        delegate: SearchBarScreen(InAppSelection.marketWatchID),
                      ).then((value) async {
                        Dataconstants.isFromBasketOrder = false;
                        callContractList();
                      });
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        // hintText: "Search and Add",

                        hintStyle: TextStyle(
                            // color: theme.indicatorColor.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        icon: Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.grey,
                            ),
                            // SvgPicture.asset(
                            //   'assets/images/Basket/search_on_edit_add.svg',
                            //   color: Colors.grey,
                            //   // color: isLight
                            //   //     ? Color(0xff737373)
                            //   //     : Color(0xffFFFFFF)
                            //   // color: theme.indicatorColor.withOpacity(0.5)
                            // ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Search and Add",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: Obx(() {
                    return GetScripFromBasketController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : GetScripFromBasketController.ScripListList.isEmpty
                            ? GestureDetector(
                                onTap: () {
                                  Dataconstants.basketName = widget.basketName;
                                  if (widget.model != null) Dataconstants.basketID = widget.model.basketId;
                                  // else
                                  //   Dataconstants.basketID = widget.model.basketId;
                                  Dataconstants.isFromBasketOrder = true;
                                  Dataconstants.isComingFromBasketSearch = true;
                                  showSearch(
                                    context: context,
                                    delegate: SearchBarScreen(InAppSelection.marketWatchID),
                                  ).then((value) async {
                                    Dataconstants.isFromBasketOrder = false;
                                    callContractList();
                                  });
                                },
                                child: Center(
                                    child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Use ',
                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14.0),
                                      ),
                                      TextSpan(
                                        text: 'Search',
                                        style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 14.0),
                                      ),
                                      TextSpan(
                                        text: ' to Add Scrip in Basket',
                                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                )),
                              )
                            : ReorderableListView.builder(
                                itemCount: GetScripFromBasketController.ScripListList.length,
                                itemBuilder: (context, i) {
                                  return Container(
                                    key: ValueKey(i + 1),
                                    height: 120,
                                    width: width,
                                    margin: EdgeInsets.only(
                                      top: 10,
                                      left: 20,
                                      right: 20,
                                    ),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: theme.cardColor),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8, top: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                                      color: GetScripFromBasketController.ScripListList[i].transactiontype == 'BUY'
                                                          ? ThemeConstants.buyColor.withOpacity(0.3)
                                                          : ThemeConstants.sellColor.withOpacity(0.3)),
                                                  child: Center(
                                                      child: Text(
                                                    "${GetScripFromBasketController.ScripListList[i].transactiontype}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: GetScripFromBasketController.ScripListList[i].transactiontype == 'BUY' ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                                                        // GetScripFromBasketController.ScripListList[i].transactiontype == 'BUY'
                                                        //     ? (Dataconstants
                                                        //                 .basketModel
                                                        //                 .filteredContractListOfBasket[
                                                        //                     i]
                                                        //                 .isContractEnabled ==
                                                        //             false)
                                                        //         ? Color(0xff34C758)
                                                        //             .withOpacity(
                                                        //                 0.5)
                                                        //         : Color(
                                                        //             0xff34C758)
                                                        //     : (Dataconstants
                                                        //                 .basketModel
                                                        //                 .filteredContractListOfBasket[
                                                        //                     i]
                                                        //                 .isContractEnabled ==
                                                        //             false)
                                                        //         ? ThemeConstants
                                                        //             .sellColor
                                                        //             .withOpacity(
                                                        //                 0.5)
                                                        //         : ThemeConstants
                                                        //             .sellColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14.0),
                                                  )),
                                                ),
                                                // SizedBox(
                                                //   width: 10,
                                                // ),
                                                Text(
                                                  "${GetScripFromBasketController.ScripListList[i].scriptDescription}",
                                                  style: TextStyle(color: theme.textTheme.bodyText1.color
                                                      // (Dataconstants
                                                      //             .basketModel
                                                      //             .filteredContractListOfBasket[
                                                      //                 i]
                                                      //             .isContractEnabled ==
                                                      //         false)
                                                      //     ? theme.textTheme
                                                      //         .bodyText1.color
                                                      //         .withOpacity(0.3)
                                                      //     :
                                                      // theme.textTheme.bodyText1.color
                                                      ),
                                                  // "${Dataconstants.basketModel.filteredContractListOfBasket[i].model.marketWatchName}-${Dataconstants.basketModel.filteredContractListOfBasket[i].expryDt}"
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                // : Text(
                                                //     "${Dataconstants.basketModel.filteredContractListOfBasket[i].model.isecName}-${Dataconstants.basketModel.filteredContractListOfBasket[i].expryDt}-${Dataconstants.basketModel.filteredContractListOfBasket[i].strkPrc}-${Dataconstants.basketModel.filteredContractListOfBasket[i].optTyp}"),

                                                // Spacer(),
                                                // Transform.scale(
                                                //   scale: 0.8,
                                                //   child: CupertinoSwitch(
                                                //       dragStartBehavior:
                                                //           DragStartBehavior.start,
                                                //       value: Dataconstants.basketModel.filteredContractListOfBasket[i].isContractEnabled,
                                                //       thumbColor: (Dataconstants
                                                //                   .basketModel
                                                //                   .filteredContractListOfBasket[
                                                //                       i]
                                                //                   .isContractEnabled ==
                                                //               false)
                                                //           ? theme.textTheme
                                                //               .bodyText1.color
                                                //               .withOpacity(0.3)
                                                //           : Colors.white,
                                                //       activeColor: Colors.green,
                                                //       onChanged: (value) async {
                                                //         try {
                                                //           CommonFunction.margin(
                                                //               isPositionIncluded);
                                                //           setState(() {
                                                //             Dataconstants
                                                //                 .basketModel
                                                //                 .filteredListForPlacingOrder[
                                                //                     i]
                                                //                 .isContractEnabled = value;
                                                //             Dataconstants
                                                //                 .basketModel
                                                //                 .filteredContractListOfBasket[
                                                //                     i]
                                                //                 .isContractEnabled = value;
                                                //           });
                                                //
                                                //           // if (value == false) {
                                                //           //   await Future.delayed(
                                                //           //       Duration(
                                                //           //           milliseconds:
                                                //           //           100));
                                                //           //   Dataconstants
                                                //           //               .basketModel
                                                //           //               .filteredListForPlacingOrder[i].isContractEnabled = value;
                                                //           //   // Dataconstants
                                                //           //   //     .basketModel
                                                //           //   //     .removeModelFromListForPlacingOrder(
                                                //           //   //         Dataconstants
                                                //           //   //             .basketModel
                                                //           //   //             .filteredListForPlacingOrder[i]);
                                                //           //
                                                //           //
                                                //           // } else {
                                                //           //   // setState(() {
                                                //           //   //   visible = true;
                                                //           //   // });
                                                //           //   await Future.delayed(
                                                //           //       Duration(
                                                //           //           milliseconds:
                                                //           //           100));
                                                //           //   Dataconstants
                                                //           //       .basketModel
                                                //           //       .addItemForPlacingOrder(
                                                //           //           Dataconstants
                                                //           //               .basketModel
                                                //           //               .filteredListForPlacingOrder[i]);
                                                //           //
                                                //           // }
                                                //
                                                //         } catch (e, s) {
                                                //           print("error => $e");
                                                //         }
                                                //       }),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                  text: TextSpan(
                                                      text: "Qty : ",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        // (Dataconstants
                                                        //             .basketModel
                                                        //             .filteredContractListOfBasket[
                                                        //                 i]
                                                        //             .isContractEnabled ==
                                                        //         false)
                                                        //     ? theme.textTheme
                                                        //         .bodyText1.color
                                                        //         .withOpacity(
                                                        //             0.3)
                                                        //     : Colors.grey
                                                      ),
                                                      children: [
                                                    TextSpan(
                                                      text: "${GetScripFromBasketController.ScripListList[i].quantity}",
                                                      // style: TextStyle(
                                                      // color:
                                                      // (Dataconstants
                                                      //             .basketModel
                                                      //             .filteredContractListOfBasket[
                                                      //                 i]
                                                      //             .isContractEnabled ==
                                                      //         false)
                                                      //     ? theme
                                                      //         .textTheme
                                                      //         .bodyText1
                                                      //         .color
                                                      //         .withOpacity(
                                                      //             0.3)
                                                      //     : theme
                                                      //         .textTheme
                                                      //         .bodyText1
                                                      //         .color
                                                      // )
                                                    )
                                                  ])),
                                              RichText(
                                                  text: TextSpan(
                                                      text: "Price : ",
                                                      style: TextStyle(color: Colors.grey
                                                          // (Dataconstants
                                                          //             .basketModel
                                                          //             .filteredContractListOfBasket[
                                                          //                 i]
                                                          //             .isContractEnabled ==
                                                          //         false)
                                                          //     ? theme.textTheme
                                                          //         .bodyText1.color
                                                          //         .withOpacity(
                                                          //             0.3)
                                                          //     : Colors.grey
                                                          ),
                                                      children: [
                                                    TextSpan(
                                                      text: "${GetScripFromBasketController.ScripListList[i].ordertype == 'MARKET' ? "MKT" : GetScripFromBasketController.ScripListList[i].price}",
                                                      // style: TextStyle(
                                                      //     color: (Dataconstants
                                                      //                 .basketModel
                                                      //                 .filteredContractListOfBasket[
                                                      //                     i]
                                                      //                 .isContractEnabled ==
                                                      //             false)
                                                      //         ? theme
                                                      //             .textTheme
                                                      //             .bodyText1
                                                      //             .color
                                                      //             .withOpacity(
                                                      //                 0.3)
                                                      //         : theme
                                                      //             .textTheme
                                                      //             .bodyText1
                                                      //             .color)
                                                    )
                                                  ])),

                                              // Text(
                                              //     "Price : ${Dataconstants.basketModel.filteredContractListOfBasket[i].lmtRt}"),
                                              Observer(builder: (context) {
                                                return RichText(
                                                    text: TextSpan(text: "LTP : ", style: TextStyle(color: Colors.grey), children: [
                                                  TextSpan(
                                                    text: "${GetScripFromBasketController.ScripListList[i].model.close.toStringAsFixed(2)}",
                                                    style: TextStyle(color: theme.textTheme.bodyText1.color),
                                                    //     style:
                                                    //     TextStyle(
                                                    //         color: Colors.grey
                                                    //         // (Dataconstants
                                                    //         //             .basketModel
                                                    //         //             .filteredContractListOfBasket[
                                                    //         //                 i]
                                                    //         //             .isContractEnabled ==
                                                    //         //         false)
                                                    //         //     ? theme
                                                    //         //         .textTheme
                                                    //         //         .bodyText1
                                                    //         //         .color
                                                    //         //         .withOpacity(
                                                    //         //             0.3)
                                                    //         //     : theme
                                                    //         //         .textTheme
                                                    //         //         .bodyText1
                                                    //         //         .color)
                                                    // ))
                                                  )
                                                ]));
                                              })
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${GetScripFromBasketController.ScripListList[i].duration}"
                                                "  ${GetScripFromBasketController.ScripListList[i].producttype} "
                                                " ${GetScripFromBasketController.ScripListList[i].ordertype}",
                                                // style: TextStyle(
                                                //     color: (Dataconstants
                                                //                 .basketModel
                                                //                 .filteredContractListOfBasket[
                                                //                     i]
                                                //                 .isContractEnabled ==
                                                //             false)
                                                //         ? theme.textTheme
                                                //             .bodyText1.color
                                                //             .withOpacity(0.3)
                                                //         : theme.textTheme
                                                //             .bodyText1.color)
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                  onTap: () {
                                                    // if (Dataconstants.basketModel.filteredContractListOfBasket[i].isContractEnabled == false) {
                                                    //   return;
                                                    // } else

                                                    {
                                                      Dataconstants.basketName = widget.basketName;
                                                      Dataconstants.series = widget.series;
                                                      // Dataconstants.basketModel.filteredContractListOfBasket[i].model.exchCategory == ExchCategory.nseFuture
                                                      //     ? Navigator.push(
                                                      //         context,
                                                      //         MaterialPageRoute(
                                                      //             builder: (context) =>
                                                      //                 InstrumentModifyScreen(
                                                      //                   data: Dataconstants
                                                      //                       .basketModel
                                                      //                       .filteredContractListOfBasket[i],
                                                      //                   model: Dataconstants
                                                      //                       .basketModel
                                                      //                       .filteredContractListOfBasket[
                                                      //                           i]
                                                      //                       .model,
                                                      //                   isPositionIncluded: isPositionIncluded,
                                                      //                   basketName:
                                                      //                       widget
                                                      //                           .basketName,
                                                      //                   isBuy: Dataconstants.basketModel.filteredContractListOfBasket[i].ordrFlw ==
                                                      //                           'B'
                                                      //                       ? true
                                                      //                       : false,
                                                      //                   qty: Dataconstants
                                                      //                       .basketModel
                                                      //                       .filteredContractListOfBasket[
                                                      //                           i]
                                                      //                       .boardLotQty
                                                      //                       .toString(),
                                                      //                   product: Dataconstants
                                                      //                       .basketModel
                                                      //                       .filteredContractListOfBasket[
                                                      //                           i]
                                                      //                       .product,
                                                      //                   shouldModify:
                                                      //                       true,
                                                      //                   isLimit: Dataconstants.basketModel.filteredContractListOfBasket[i].limitMarketText ==
                                                      //                           'L'
                                                      //                       ? true
                                                      //                       : false,
                                                      //                   series: widget
                                                      //                       .series,
                                                      //                   orderReference: Dataconstants
                                                      //                       .basketModel
                                                      //                       .filteredContractListOfBasket[
                                                      //                           i]
                                                      //                       .ordrRfrnc,
                                                      //                 )))
                                                      //     :
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => InStrumentOptionModify(
                                                                    data: GetScripFromBasketController.ScripListList[i],
                                                                    model: GetScripFromBasketController.ScripListList[i].model,
                                                                    isPositionIncluded: isPositionIncluded,
                                                                    basketName: widget.basketName,
                                                                    isBuy: GetScripFromBasketController.ScripListList[i].transactiontype == 'BUY' ? true : false,
                                                                    qty: GetScripFromBasketController.ScripListList[i].quantity.toString(),
                                                                    product: GetScripFromBasketController.ScripListList[i].producttype,
                                                                    shouldModify: true,
                                                                    isLimit: GetScripFromBasketController.ScripListList[i].ordertype == 'LIMIT' ? true : false,
                                                                    series: widget.series,
                                                                    orderReference: GetScripFromBasketController.ScripListList[i].scriptId,
                                                                  )));
                                                    }
                                                  },
                                                  child: Icon(Icons.edit, size: 20, color: isLight ? Color(0xff737373) : Color(0xffFFFFFF))
                                                  // SvgPicture.asset(
                                                  //   'assets/images/Basket/edit.svg',
                                                  //   color: isLight
                                                  //       ? Color(0xff737373)
                                                  //       : Color(0xff9E9E9E),
                                                  // ),
                                                  ),
                                              // SizedBox(
                                              //   width: 20,
                                              // ),
                                              // GestureDetector(
                                              //   // onTap: () async {
                                              //   //   if (Dataconstants
                                              //   //           .basketModel
                                              //   //           .filteredContractListOfBasket[
                                              //   //               i]
                                              //   //           .isContractEnabled ==
                                              //   //       false) {
                                              //   //     return;
                                              //   //   } else {
                                              //   //     setState(() {
                                              //   //       Dataconstants
                                              //   //               .shouldShowExecuteButton =
                                              //   //           false;
                                              //   //     });
                                              //   //     // Dataconstants.isShowExcuteButton=false;
                                              //   //     // await CommonFunction.basketForFno(
                                              //   //     //     context: context,
                                              //   //     //     theme: theme,
                                              //   //     //     action: 'Copy',
                                              //   //     //     index: i,
                                              //   //     //     model: Dataconstants
                                              //   //     //         .basketModel
                                              //   //     //         .filteredContractListOfBasket[
                                              //   //     //             i]
                                              //   //     //         .model,
                                              //   //     //     data: Dataconstants
                                              //   //     //             .basketModel
                                              //   //     //             .filteredContractListOfBasket[
                                              //   //     //         i],
                                              //   //     //     series: widget.series,
                                              //   //     //     basketName:
                                              //   //     //         widget.basketName,
                                              //   //     //     title: 'Instruments');
                                              //   //     setState(() {
                                              //   //       Dataconstants
                                              //   //               .shouldShowExecuteButton =
                                              //   //           true;
                                              //   //     });
                                              //   //
                                              //   //     var result = await Dataconstants
                                              //   //         .itsClient
                                              //   //         .addContractToBasket(
                                              //   //             model: Dataconstants
                                              //   //                 .basketModel
                                              //   //                 .filteredContractListOfBasket[
                                              //   //                     i]
                                              //   //                 .model,
                                              //   //             // productType: 'F',
                                              //   //             productType: Dataconstants
                                              //   //                 .basketModel
                                              //   //                 .filteredContractListOfBasket[
                                              //   //                     i]
                                              //   //                 .product,
                                              //   //             requestType: 'H',
                                              //   //             strikePrice: Dataconstants.basketModel.filteredContractListOfBasket[i].model.exchCategory == ExchCategory.nseFuture
                                              //   //                 ? Dataconstants.basketModel.filteredContractListOfBasket[i].model.strikePrice
                                              //   //                     .toString()
                                              //   //                 : (Dataconstants.basketModel.filteredContractListOfBasket[i].model.strikePrice * 100)
                                              //   //                     .toString(),
                                              //   //             // strikePrice:
                                              //   //             //     model.strikePrice.toString(),
                                              //   //             qty: Dataconstants
                                              //   //                 .basketModel
                                              //   //                 .filteredContractListOfBasket[
                                              //   //                     i]
                                              //   //                 .boardLotQty,
                                              //   //             currentRate:
                                              //   //                 InAppSelection.buyFutureOrderMarketLimit == 0
                                              //   //                     ? ''
                                              //   //                     : Dataconstants.basketModel.filteredContractListOfBasket[i].model.close
                                              //   //                         .toString(),
                                              //   //             limitMarketFlag: Dataconstants
                                              //   //                 .basketModel
                                              //   //                 .filteredContractListOfBasket[i]
                                              //   //                 .limitMarketText,
                                              //   //             limitRate: Dataconstants.basketModel.filteredContractListOfBasket[i].limitMarketText == 'L'
                                              //   //                 ? (double.parse(Dataconstants.basketModel.filteredContractListOfBasket[i].lmtRt) * 100).toString()
                                              //   //                 : Dataconstants.basketModel.filteredContractListOfBasket[i].limitMarketText == 'S'
                                              //   //                     ? (double.parse(Dataconstants.basketModel.filteredContractListOfBasket[i].lmtRt) * 100).toString()
                                              //   //                     : '',
                                              //   //             // limitMarketFlag: InAppSelection
                                              //   //             //                 .buyFutureOrderMarketLimit ==
                                              //   //             //             1 ||
                                              //   //             //         InAppSelection
                                              //   //             //                 .sellFutureOrderMarketLimit ==
                                              //   //             //             1
                                              //   //             //     ? 'L'
                                              //   //             //     : 'M',
                                              //   //             // limitRate: InAppSelection
                                              //   //             //                 .buyFutureOrderMarketLimit ==
                                              //   //             //             1 ||
                                              //   //             //         InAppSelection.sellFutureOrderMarketLimit == 1
                                              //   //             //     ? (double.parse(data.lmtRt)*100).toString()
                                              //   //             //     : "",
                                              //   //             minLotQty: Dataconstants.basketModel.filteredContractListOfBasket[i].model.minimumLotQty.toString(),
                                              //   //             optType: Dataconstants.basketModel.filteredContractListOfBasket[i].model.cpType == 3
                                              //   //                 ? 'CE'
                                              //   //                 : Dataconstants.basketModel.filteredContractListOfBasket[i].model.cpType == 4
                                              //   //                     ? 'PE'
                                              //   //                     : '*',
                                              //   //             orderFlow: Dataconstants.basketModel.filteredContractListOfBasket[i].ordrFlw == 'B' ? 'B' : 'S',
                                              //   //             orderType: Dataconstants.basketModel.filteredContractListOfBasket[i].orderType == 'DAY' ? 'T' : 'I',
                                              //   //             sltpPrice: InAppSelection.buyFutureOrderSL ? Dataconstants.basketModel.filteredContractListOfBasket[i].lmtRt : "");
                                              //   //     if (result['Status'] == 200) {
                                              //   //       CommonFunction.showBasicToast(
                                              //   //           "Contract copied successfully",
                                              //   //           3);
                                              //   //
                                              //   //       await Dataconstants
                                              //   //           .itsClient
                                              //   //           .basketOrderForFno(
                                              //   //               requestType: 'F',
                                              //   //               exchCode: 'NFO',
                                              //   //               routeCrt: '333',
                                              //   //               symbol: widget
                                              //   //                   .basketName,
                                              //   //               series:
                                              //   //                   widget.series);
                                              //   //       CommonFunction.margin(
                                              //   //           isPositionIncluded);
                                              //   //
                                              //   //       if (Dataconstants
                                              //   //               .basketModel
                                              //   //               .fetchingRecords ==
                                              //   //           false) {
                                              //   //         Dataconstants.itsClient
                                              //   //             .basketOrderForFno(
                                              //   //                 requestType: 'E',
                                              //   //                 exchCode: 'NFO',
                                              //   //                 routeCrt: '111',
                                              //   //                 symbol: '',
                                              //   //                 showIndicator:
                                              //   //                     true,
                                              //   //                 series: '');
                                              //   //
                                              //   //         // Navigator.of(context).pop();
                                              //   //       } else {
                                              //   //         // CommonFunction
                                              //   //         //     .showBasicToast(
                                              //   //         //         result['Error']);
                                              //   //       }
                                              //   //     } else {
                                              //   //       // CommonFunction
                                              //   //       //     .showBasicToast(
                                              //   //       //         result['Error']);
                                              //   //     }
                                              //   //   }
                                              //   //
                                              //   //   // Dataconstants.basketModel.clone(
                                              //   //   //     Dataconstants.basketModel
                                              //   //   //         .filteredContractListOfBasket[i]);
                                              //   // },
                                              //   child: Icon(Icons.c,size: 20, color: isLight
                                              //       ? Color(0xff737373)
                                              //       : Color(0xffFFFFFF),),
                                              // ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  var result = await Dataconstants.itsClient.deleteScriptFromBasket(GetScripFromBasketController.ScripListList[i].scriptId);
                                                  if (result['status'] == true) {
                                                    await Dataconstants.getScripFromBasketController.getScripmFromBasket(basketId: widget.model.basketId);
                                                  }
                                                },

                                                // onTap: () async {
                                                //   if (Dataconstants
                                                //           .basketModel
                                                //           .filteredContractListOfBasket[
                                                //               i]
                                                //           .isContractEnabled ==
                                                //       false) {
                                                //     return;
                                                //   } else {
                                                //     // Dataconstants.isShowExcuteButton=false;
                                                //     log("Order ref => ${Dataconstants.basketModel.filteredContractListOfBasket[i].ordrRfrnc}");
                                                //
                                                //     var result = await Dataconstants
                                                //         .itsClient
                                                //         .basketOrderForFno(
                                                //             exchCode: 'NFO',
                                                //             requestType: 'Q',
                                                //             series: widget.series,
                                                //             orderReference:
                                                //                 Dataconstants
                                                //                     .basketModel
                                                //                     .filteredContractListOfBasket[
                                                //                         i]
                                                //                     .ordrRfrnc,
                                                //             symbol: widget
                                                //                 .basketName);
                                                //
                                                //     if (result['Status'] == 500) {
                                                //       // CommonFunction
                                                //       //     .showBasicToast(
                                                //       //         result['Error']);
                                                //     } else {
                                                //       CommonFunction.showBasicToast(
                                                //           "Contract deleted successfully",
                                                //           3);
                                                //
                                                //       await Dataconstants
                                                //           .itsClient
                                                //           .basketOrderForFno(
                                                //               requestType: 'F',
                                                //               exchCode: 'NFO',
                                                //               routeCrt: '333',
                                                //               symbol: widget
                                                //                   .basketName,
                                                //               series:
                                                //                   widget.series);
                                                //       CommonFunction.margin(
                                                //           isPositionIncluded);
                                                //
                                                //       // Dataconstants.basketModel.delete(Dataconstants
                                                //       //     .basketModel
                                                //       //     .filteredContractListOfBasket[index]);
                                                //       if (Dataconstants
                                                //               .basketModel
                                                //               .fetchingRecords ==
                                                //           false) {
                                                //         Dataconstants.itsClient
                                                //             .basketOrderForFno(
                                                //                 requestType: 'E',
                                                //                 exchCode: 'NFO',
                                                //                 routeCrt: '111',
                                                //                 symbol: '',
                                                //                 showIndicator:
                                                //                     true,
                                                //                 series: '');
                                                //       }
                                                //       // Navigator.of(context).pop();
                                                //     }
                                                //     // await CommonFunction.basketForFno(
                                                //     //     context: context,
                                                //     //     theme: theme,
                                                //     //     action: 'Delete',
                                                //     //     index: i,
                                                //     //     model: Dataconstants
                                                //     //         .basketModel
                                                //     //         .filteredContractListOfBasket[
                                                //     //             i]
                                                //     //         .model,
                                                //     //     data: Dataconstants
                                                //     //             .basketModel
                                                //     //             .filteredContractListOfBasket[
                                                //     //         i],
                                                //     //     series: widget.series,
                                                //     //     basketName:
                                                //     //         widget.basketName,
                                                //     //     title: 'Instruments');
                                                //     setState(() {
                                                //       Dataconstants
                                                //               .shouldShowExecuteButton =
                                                //           true;
                                                //     });
                                                //     // Dataconstants.basketModel.delete(
                                                //     //     Dataconstants.basketModel
                                                //     //         .filteredContractListOfBasket[i]);
                                                //   }
                                                // },
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: isLight ? Color(0xff737373) : Color(0xffFFFFFF),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onReorder: (oldIndex, newIndex) {
                                  setState(() {
                                    if (newIndex > oldIndex) {
                                      newIndex = newIndex - 1;
                                    }
                                    final element = GetScripFromBasketController.ScripListList.removeAt(oldIndex);
                                    GetScripFromBasketController.ScripListList.insert(newIndex, element);
                                  });
                                });
                  }),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(() {
          return
              // Dataconstants.shouldShowExecuteButton &&
              //       Dataconstants.basketModel.filteredListForPlacingOrder
              //           .any((element) => element.isContractEnabled == true)
              //   ?

              GetScripFromBasketController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GetScripFromBasketController.ScripListList.isEmpty
                      ? SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: Platform.isIOS ? const EdgeInsets.only(left: 50, right: 10, top: 10, bottom: 70) : const EdgeInsets.only(bottom: 20),
                              child: Dataconstants.isShowLoaderForExexuting
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : SliderButton(
                                      width: MediaQuery.of(context).size.width * 0.67,
                                      shimmer: true,
                                      backgroundColor: theme.cardColor,
                                      foregroundColor: Colors.white,
                                      iconColor: theme.primaryColor,
                                      shimmerHighlight: theme.primaryColor,
                                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.primaryColor),
                                      shimmerBase: Colors.grey,
                                      text: '          Swipe to Execute',
                                      onConfirmation: () async {
                                        setState(() {
                                          Dataconstants.isShowLoaderForExexuting = true;
                                        });

                                        Dataconstants.count = 0;
                                        Dataconstants.contractListOrderResponse.clear();
                                        enabledContract.clear();
                                        for (var j = 0; j < GetScripFromBasketController.ScripListList.length; j++) {
                                          // if (Dataconstants.basketModel.filteredListForPlacingOrder[j].isContractEnabled == true) {
                                          var element = GetScripFromBasketController.ScripListList[j];
                                          enabledContract.add(element);
                                          // }
                                        }
                                        // Dataconstants.basketModel
                                        //     .filteredListForPlacingOrder
                                        //     .where((element) {
                                        //
                                        //  if( element.isContractEnabled == true) {
                                        //     enabledContract.add(element);return true;
                                        //   }else{
                                        //    return false;
                                        //  }
                                        // });

                                        //--------------------------------------------------------------------------------------------------------------
                                        for (var i = 0; i < enabledContract.length; i++) {
                                          var jsons = {
                                            "variety": Dataconstants.exchData[0].exchangeStatus == ExchangeStatus.nesClosed ? "AMO" : "NORMAL",
                                            "tradingsymbol": enabledContract[i].model.tradingSymbol,
                                            "symboltoken": enabledContract[i].model.exchCode.toString(),
                                            "transactiontype": enabledContract[i].transactiontype,
                                            "exchange": enabledContract[i].exchange == "N"
                                                ? "NSE"
                                                : enabledContract[i].exchange == "NFO"
                                                    ? "NFO"
                                                    : "BSE",
                                            "ordertype": enabledContract[i].ordertype,
                                            "producttype": enabledContract[i].producttype,
                                            "duration": enabledContract[i].duration,
                                            "price": enabledContract[i].ordertype == "MARKET" ? "0" : enabledContract[i].price,
                                            "quantity": enabledContract[i].quantity,
                                            "disclosedquantity": enabledContract[i].disclosedquantity,
                                            "triggerprice": enabledContract[i].triggerprice,
                                          };
                                          // json.encode(jsons)
                                          log(jsons.toString());
                                          var response = await CommonFunction.placeOrder(jsons);

                                          var responseJson = json.decode(response.toString());
                                          if (responseJson["status"] == false) {
                                            CommonFunction.showBasicToast(responseJson["emsg"].toString());
                                            break;
                                          }

                                          // await Dataconstants.itsClient.placeBasketLoopExecutionOrder(
                                          //         isResearch: false,
                                          //         index: i,
                                          //         model: enabledContract[i].model,
                                          //         // type: 'S',
                                          //
                                          //         type: enabledContract[i].product == 'I'
                                          //             ? 'S'
                                          //             : enabledContract[i]
                                          //                 .limitMarketText,
                                          //         validity: enabledContract[i]
                                          //                     .orderTypeText ==
                                          //                 'H'
                                          //             ? 'I'
                                          //             : 'T',
                                          //         coverOrderFreshType: enabledContract[i]
                                          //             .limitMarketText,
                                          //         coverOrderFreshRate:enabledContract[i].limitMarketText == 'M'
                                          //             ? '0'
                                          //             :
                                          //         ( double.parse( enabledContract[i].currRt)/100).toStringAsFixed(2),
                                          //         qty: enabledContract[i].boardLotQty,
                                          //         rate:
                                          //         enabledContract[i]
                                          //                 .lmtRt
                                          //                 .toString(),
                                          //         // json["PRDCT_TYP"] == 'F'?'NRML':json["PRDCT_TYP"] == 'P'?'INTRA':json["PRDCT_TYP"] == 'U'?'COVER':json["PRDCT_TYP"] == 'O'?'NRML':
                                          //         // "COVER",
                                          //         product: (enabledContract[i].strkPrc ==
                                          //                 '0')
                                          //             ? enabledContract[i].prdctTyp ==
                                          //                     'NRML'
                                          //                 ? 'F'
                                          //                 : enabledContract[i].prdctTyp ==
                                          //                         'INTRA'
                                          //                     ? 'P'
                                          //                     : 'U'
                                          //             : enabledContract[i].prdctTyp ==
                                          //                     'NRML'
                                          //                 ? 'O'
                                          //                 : 'I',
                                          //         slRate:
                                          //             enabledContract[i].prdctTyp == 'COVER'
                                          //                 ? (double.parse(enabledContract[i].cvrBrkg)/100).toStringAsFixed(2)
                                          //                 : '',
                                          //         buySell:
                                          //             enabledContract[i].ordrFlw == 'B'
                                          //                 ? 'B'
                                          //                 : 'S',
                                          //         reportCalledFrom: ReportCalledFrom.none);

                                          if (i == enabledContract.length - 1) {
                                            setState(() {
                                              Dataconstants.isShowLoaderForExexuting = false;
                                            });

                                            // Dataconstants.mainScreenIndex=2;

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => BasketAcknoeledgement(
                                                          enabledContract: enabledContract,
                                                        )));
                                          }
                                        }
                                      }),
                            )
                            // enabledContract
                            //             .length == 0
                            //     ? SizedBox.shrink()
                            //     :
                            // Obx( () {
                            //   return    ;
                            // }),
                          ],
                        );
          // : SizedBox.shrink();
        }));
  }
}

class CreateNewBasket extends StatefulWidget {
  String existingBasketName;
  String series;
  String basketId;

  CreateNewBasket({
    Key key,
    this.existingBasketName,
    this.series,
    this.basketId,
  }) : super(key: key);

  @override
  State<CreateNewBasket> createState() => _CreateNewBasketState();
}

class _CreateNewBasketState extends State<CreateNewBasket> {
  TextEditingController _createNewBasket;
  bool showOrangeColorButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _createNewBasket = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _createNewBasket.text = widget.existingBasketName;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
        padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Container(
              width: 50,
              height: 8,
              decoration: BoxDecoration(color: Color(0xff4A4A4A), borderRadius: BorderRadius.circular(5)),
            )),
            SizedBox(
              height: 40,
            ),
            Text(
              'Basket',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              maxLength: 15,
              autofocus: true,
              onSubmitted: (value) {
                _createNewBasket.text = value;
              },
              onChanged: (value) {
                if (_createNewBasket.text.isEmpty) {
                  setState(() {
                    showOrangeColorButton = false;
                  });
                } else {
                  setState(() {
                    showOrangeColorButton = true;
                  });
                }
              },
              controller: _createNewBasket,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 14),
                focusColor: theme.primaryColor,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(border: Border.all(color: theme.primaryColor), borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Text('Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF5367FC)), side: MaterialStateProperty.all(BorderSide(color: theme.primaryColor))),
                    onPressed: () async {
                      Dataconstants.isBasketNamemodified = true;
                      // var result = await Dataconstants.itsClient
                      //     .basketOrderForFno(
                      //
                      //
                      //         exchCode: 'NFO',
                      //         requestType: 'N',
                      //         symbol: _createNewBasket.text,
                      //         series: widget.series);

                      var result = await Dataconstants.itsClient.updateBasket(widget.basketId, _createNewBasket.text);
                      if (result['status'] == true) {
                        // Navigator.of(context).pop();
                        Dataconstants.newBasketName = _createNewBasket.text.toString();
                        Navigator.of(context).pop();
                        Dataconstants.getAllBasketsController.fetchBasketList();
                        // Dataconstants.itsClient.basketOrderForFno(
                        //     requestType: 'E',
                        //     exchCode: 'NFO',
                        //     routeCrt: '111',
                        //     symbol: '',
                        //     showIndicator: true,
                        //     series: '');
                      }
                      // else {
                      // CommonFunction.showBasicToast(result["Error"]);
                      // }
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(
                        child: Text('Save',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
