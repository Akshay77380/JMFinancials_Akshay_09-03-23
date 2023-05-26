import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../Controllers/Basket_order/getAllBasket_controller.dart';
import '../../model/scrip_info_model.dart';
import 'basketFutureScreen.dart';
import 'basketOptionScreen.dart';
import 'basketEditAndAdd.dart';
import 'instrumentViewScreen.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';

class BasketWatch extends StatefulWidget {
  final bool isFromScripDetail;
  final ScripInfoModel modelFromScripDetail;

  BasketWatch({@required this.isFromScripDetail, this.modelFromScripDetail});

  // const BasketWatch({Key key, bool isFromScripDetail}) : super(key: key);

  @override
  State<BasketWatch> createState() => _BasketWatchState();
}

class _BasketWatchState extends State<BasketWatch> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    // Dataconstants.getAllBasketsController.fetchBasketList();
    if (widget.isFromScripDetail && GetAllBasketsController.BasketListList.isEmpty) {
      Future.delayed(Duration(seconds: 0)).then((_) {
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
            isScrollControlled: true,
            context: Dataconstants.navigatorKey.currentContext,
            builder: (context) {
              return CreateNewBasket();
            });
      });
    }

    searchController = TextEditingController();
    // TODO: implement initState
    super.initState();
    if (Dataconstants.shouldShowPopForbasket && GetAllBasketsController.BasketListList.length == 0) {
      CommonFunction.showBasicToast("Kindly create new basket", 3);
    } else if (Dataconstants.shouldShowPopForbasket) {
      CommonFunction.showBasicToast("Choose existing basket or create new", 3);
      Dataconstants.shouldShowPopForbasket = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    int counter = 0;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (widget.isFromScripDetail) {
              Navigator.pop(context);
            } else {
              setState(() {
                Dataconstants.isFromToolsToBasketOrder = false;
              });
              Dataconstants.pageController.add(true);
              Navigator.pop(context);
            }
          },
        ),
        centerTitle: false,
        backgroundColor: theme.appBarTheme.color,
        elevation: 0,
        title: Text(
          "Basket Order",
          style: TextStyle(color: theme.textTheme.bodyText1.color),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              GetAllBasketsController.isLoading.value
                  ? CircularProgressIndicator()
                  :
                  // GetAllBasketsController.BasketListList.isEmpty
                  //     ? Container(
                  //         height: 20,
                  //         color: theme.appBarTheme.color,
                  //       )
                  //     :

                  Stack(
                      children: [
                        Container(
                          height: 60,
                          color: theme.appBarTheme.color,
                        ),
                        Card(
                          color: theme.accentColor,
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 30,
                            bottom: 4,
                          ),
                          elevation: 5,
                          child: Container(
                            height: 48,
                            color: theme.accentColor,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.63,
                                        child: TextField(
                                          controller: searchController,
                                          onChanged: (value) {
                                            setState(() {
                                              searchText = value;
                                              Dataconstants.getAllBasketsController.updateHoldingsBySearch(value);
                                            });
                                          },

                                          //onChanged: (value) {
                                          //                                           Dataconstants.holdingController.updateHoldingsBySearch(value);
                                          //                                         },
                                          decoration: InputDecoration(
                                              hintText: "Search Basket",
                                              hintStyle: TextStyle(
                                                  // color: theme.indicatorColor
                                                  //     .withOpacity(0.5),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                              icon: Icon(
                                                Icons.search,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              // SvgPicture.asset(
                                              //   ThemeConstants
                                              //               .themeMode.value ==
                                              //           ThemeMode.light
                                              //       ? "assets/images/Basket/basketSearch.svg"
                                              //       : "assets/images/Basket/basketSearch.svg",
                                              //   color: theme.indicatorColor,
                                              // ),
                                              border: InputBorder.none,
                                              fillColor: theme.accentColor,
                                              filled: true,
                                              focusedBorder: InputBorder.none),
                                        ),
                                      ),
                                      Obx(() {
                                        return GetAllBasketsController.isLoading.value
                                            ? SizedBox.shrink()
                                            :
                                            // (GetAllBasketsController.BasketListList.length != 0)
                                            //   ?
                                            GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return CreateNewBasket();
                                                      });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.shopping_basket_outlined,
                                                      size: 15,
                                                      color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff737373) : Color(0xffFFFFFF),
                                                    ),
                                                    // SvgPicture.asset(
                                                    //     'assets/images/Basket/plus.svg'),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'New Basket',
                                                      style: TextStyle(color: theme.primaryColor, fontSize: 14.0, fontWeight: FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              );
                                        // : SizedBox.shrink();
                                      })
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    return Dataconstants.getAllBasketsController.fetchBasketList();
                  },
                  child: Obx(() {
                    return GetAllBasketsController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : GetAllBasketsController.BasketListList.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // SizedBox(
                                  //   height: 100,
                                  // ),
                                  Text(
                                    'Create your first Basket',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.indicatorColor.withOpacity(0.5)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(theme.scaffoldBackgroundColor), side: MaterialStateProperty.all(BorderSide(color: theme.primaryColor))),
                                      onPressed: () {
                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllInstrumentScreen(),));
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return CreateNewBasket();
                                            });
                                      },
                                      child: Container(
                                        width: 110,
                                        height: 40,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                                        child: Row(
                                          children: [
                                            // SvgPicture.asset(
                                            //     'assets/images/Basket/plus.svg',color: Colors.white,),
                                            // SizedBox(
                                            //   width: 10,
                                            // ),
                                            Text('Create Basket',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: ThemeConstants.themeMode.value == ThemeMode.dark ? Color(0xFF7989FE) : theme.primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ],
                                        ),
                                      ))
                                ],
                              ))
                            : Container(
                                height: MediaQuery.of(context).size.height - 100,
                                child: ListView.builder(
                                    itemCount: GetAllBasketsController.BasketListList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          // Dataconstants
                                          //     .basketForAddingContractFromGetQuuote =
                                          //     Dataconstants
                                          //         .basketModel
                                          //         .filteredBasketList[
                                          //     i]
                                          //         .symbol;
                                          // Dataconstants
                                          //     .dateForAddingContractFromGetQuuote =
                                          //     Dataconstants
                                          //         .basketModel
                                          //         .filteredBasketList[
                                          //     i]
                                          //         .execnDt;
                                          // Dataconstants
                                          //     .noInstrForAddingContractFromGetQuuote =
                                          //     Dataconstants
                                          //         .basketModel
                                          //         .filteredBasketList[
                                          //     i]
                                          //         .minLotQty;
                                          // Dataconstants
                                          //     .seriesForAddingContractFromGetQuuote =
                                          //     Dataconstants
                                          //         .basketModel
                                          //         .filteredBasketList[
                                          //     i]
                                          //         .series;
                                          // Dataconstants.orderRefForAddingContractFromGetQuuote = Dataconstants
                                          //     .basketModel
                                          //     .filteredBasketList[i]
                                          //     .or

                                          // Dataconstants.getScripFromBasketController.getScripmFromBasket(basketId:GetAllBasketsController.BasketListList[index].basketId);

                                          // if (Dataconstants.isComingFromBasketGetQuote) {
                                          //   (Dataconstants.basketModelForFno.exchCategory == ExchCategory.nseFuture)
                                          //       ? Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (context) => BasketFutureOrderScreen(
                                          //               model: Dataconstants
                                          //                   .basketModelForFno,
                                          //               isBuy:
                                          //               true,
                                          //               reportCalledFrom: ReportCalledFrom
                                          //                   .none)))
                                          //       : Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (context) => BasketOptionOrderScreen(
                                          //               model: Dataconstants
                                          //                   .basketModelForFno,
                                          //               isBuy:
                                          //               true,
                                          //               reportCalledFrom:
                                          //               ReportCalledFrom.none)));
                                          // } else

                                          Dataconstants.getScripFromBasketController.getScripmFromBasket(basketId: GetAllBasketsController.BasketListList[index].basketId);

                                          if (Dataconstants.isFromScripDetail) {
                                            Dataconstants.newBasketName = GetAllBasketsController.BasketListList[index].basketName;
                                            Dataconstants.basketID = GetAllBasketsController.BasketListList[index].basketId;
                                            Dataconstants.newDate = Jiffy().format('dd-MM-yyyy');
                                            Dataconstants.newOfInstruments = '0';

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => BasketOptionOrderScreen(model: Dataconstants.modelFromScripDetail, isBuy: true, reportCalledFrom: ReportCalledFrom.none)));
                                          } else {
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => AllInstrumentScreen(
                                                   basketName: GetAllBasketsController.BasketListList[index].basketName,
                                                  date: GetAllBasketsController.BasketListList[index].createdAt.toString().split(" ")[0].toString(),
                                                  series: "NSE",
                                                  noOfInstruments: GetAllBasketsController.BasketListList.length.toString(),
                                                  model: GetAllBasketsController.BasketListList[index]),
                                            ));
                                            Dataconstants.newBasketName = GetAllBasketsController.BasketListList[index].basketName;
                                            Dataconstants.newDate = GetAllBasketsController.BasketListList[index].createdAt.toString().split(" ")[0].toString();
                                            Dataconstants.newOfInstruments = GetAllBasketsController.BasketListList.length.toString();
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: MediaQuery.of(context).size.width - 20,
                                              decoration: BoxDecoration(
                                                  color: theme.cardColor,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(5),
                                                  )),
                                              // color: Colors.grey,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 15, right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("${GetAllBasketsController.BasketListList[index].basketName}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ))
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text("Created on: ${GetAllBasketsController.BasketListList[index].createdAt.toString().split(" ")[0].toString()}",
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.indicatorColor.withOpacity(0.5))),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text("${GetAllBasketsController.BasketListList[index].scriptCount}/20 items",
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.indicatorColor.withOpacity(0.5)))
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        // SvgPicture.asset(
                                                        //     'assets/images/Basket/arrowBasket.svg')
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              );

                    // SingleChildScrollView(
                    //             child: Column(
                    //               children: [
                    //
                    //               ],
                    //             ),
                    //           );
                  }),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

class CreateNewBasket extends StatefulWidget {
  const CreateNewBasket({Key key}) : super(key: key);

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
    _createNewBasket = TextEditingController();
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
              'Create New Basket',
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
                hintText: 'Enter Name',
                hintStyle: TextStyle(fontSize: 14),
                focusColor: theme.primaryColor,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 400,
              height: 46,
              child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(showOrangeColorButton ? Color(0xFF5367FC) : Color(0xff9F9F9F)),
                  ),
                  onPressed: () async {
                    for(var i = 0 ; i < GetAllBasketsController.BasketListList.length; i++){
                      if(GetAllBasketsController.BasketListList[i].basketName.contains(_createNewBasket.text)){
                        CommonFunction.showBasicToast("same name not allowed");
                        return;
                      }
                    }
                    var result = await Dataconstants.itsClient.createBasket(_createNewBasket.text);

                    if (result['status'] == true) {
                      log("result -/> $result");
                      if (Dataconstants.isFromScripDetail) {
                        await Dataconstants.getScripFromBasketController.getScripmFromBasket(basketId: result['data'].toString().split("|")[0].toString().trim());
                        Dataconstants.newBasketName = result['data'].toString().split("|")[1].toString().trim(); //result['Success'][0]['SYMBOL'];
                        Dataconstants.basketID = result['data'].toString().split("|")[0].toString().trim(); //result['Success'][0]['SYMBOL'];
                        Dataconstants.newDate = Jiffy().format('dd-MM-yyyy');
                        Dataconstants.newOfInstruments = '0';

                        // Dataconstants.basketForAddingContractFromGetQuuote = _createNewBasket.text;
                        // Dataconstants.dateForAddingContractFromGetQuuote = Jiffy().format('dd-MM-yyyy');
                        // Dataconstants.noInstrForAddingContractFromGetQuuote = '1';
                        // Dataconstants.seriesForAddingContractFromGetQuuote = result['Success'][0]['SERIES'];
                        // Dataconstants.basketModelForFno.exchCategory == ExchCategory.nseFuture
                        //     ? Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //
                        //                 BasketFutureOrderScreen(
                        //                     model: Dataconstants.modelFromScripDetail,
                        //                     isBuy: true,
                        //                     reportCalledFrom: ReportCalledFrom.none)))
                        //     :
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => BasketOptionOrderScreen(model: Dataconstants.modelFromScripDetail, isBuy: true, reportCalledFrom: ReportCalledFrom.none)));
                      } else {
                        await Dataconstants.getScripFromBasketController.getScripmFromBasket(basketId: "20"); //result['data'].toString().split("|")[0].toString().trim()
                        Navigator.pop(context);
                        // Dataconstants.itsClient.basketOrderForFno(
                        //   requestType: 'E',
                        //   exchCode: 'NFO',
                        //   routeCrt: '111',
                        //   symbol: '',
                        // );
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AllInstrumentScreen(
                            basketName: result['data'].toString().split("|")[1].toString().trim(),
                            date: Jiffy().format('dd-MM-yyyy'),
                            series: "NSE", //result['Success'][0]['SERIES'],
                            noOfInstruments: '0',
                          ),
                        ));
                        Dataconstants.newBasketName = result['data'].toString().split("|")[1].toString().trim(); //result['Success'][0]['SYMBOL'];
                        Dataconstants.basketID = result['data'].toString().split("|")[0].toString().trim(); //result['Success'][0]['SYMBOL'];
                        Dataconstants.newDate = Jiffy().format('dd-MM-yyyy');
                        Dataconstants.newOfInstruments = '0';
                      }
                    } else {
                      CommonFunction.showBasicToast(result['Error']);
                    }

                    // if (_createNewBasket.text.isNotEmpty)
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) => BasketModifyAndAdd(
                    //             basketName: _createNewBasket.text,
                    //             date: '',
                    //             series: result['Success'][0]['SERIES'],
                    //             noOfInstrument: '0',
                    //             // date: result['Success'][0]['SERIES'],
                    //
                    //           )));
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
