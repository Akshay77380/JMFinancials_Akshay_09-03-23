import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:markets/controllers/DetailController.dart';
// import 'package:markets/controllers/PortfolioControllers/PortfolioEquityController.dart';
import 'package:markets/controllers/PortfolioControllers/PortfolioDerivateController.dart';
import 'package:markets/database/database_helper.dart';
import 'package:markets/jmScreens/portfolio/portfolio.dart';
import 'package:markets/jmScreens/portfolio/zero_portfolio_tabular_view.dart';
import 'package:markets/model/jmModel/DetailModel.dart';
import 'package:markets/model/scripStaticModel.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../model/PortfolioDerivateModel.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../../controllers/PortfolioControllers/PortfolioEquityController.dart';
class zeroPortfolio extends StatefulWidget {
  @override
  State<zeroPortfolio> createState() => _zeroPortfolioState();
}

class _zeroPortfolioState extends State<zeroPortfolio> {
  var res,
      nse_der = 'NSE DER',
      bse_der = 'BSE DER',
      nse_comm = 'NSE MCX',
      bse_comm = 'BSE MCX',
      nse_curr = 'NSE CDX',
      bse_curr = 'BSE CDX';
  double overallCostPrice = 0.0,
      overallLongValue = 0.0,
      marginused = 0.0,
      MTM_pl = 0.0,
      overallLongQty = 0.0,
      overallShortValue = 0.0,
      overall_currency_margin_used = 0.0;

  // Detail detail;
  List<TrPositionsDerivativesFifoCostDetailGetDataResult> data;


  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // TODO: get headers

    // List <ScripStaticModel> data = Dataconstants.exchData[1].getNseDerv('ADANIENT 27 Apr 2023').map((e) => null).toList();
    // print('knv ${data.toString()}');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fun1();
      await Dataconstants.detailsController.getDetailResult();
      await Dataconstants.portfolioEquityController
          .getPortfolioEquity()
          .then((value) {
        setState(() {
        });
      });
      await Dataconstants.portfolio_derivateController
          .getDetailResult()
          .then((value) {
        setState(() {});
      });
      // fetchMTMPL('NSE DER');
      // fetchMTMPL('BSE DER');
      // fetchRealisedPl('NSE DER');
      // List <ScripStaticModel> data = Dataconstants.exchData[1].getNseDerv('ADANIENT 27 Apr 2023');
      // print('knv ${data.toString()}');
    });
    // TODO: implement initState
    super.initState();
  }

  void fun1() async {
    try {
      String mydata = "pqrs@@1008_pqrs##1008_11";
      String bs64 = base64.encode(mydata.codeUnits);
      //print(bs64);

      var header = {"authkey": bs64};
      res = await ITSClient.httpGetPortfolio(
          "https://mobilepms.jmfonline.in/WebLoginValidatePassword3.svc/WebLoginValidatePassword3GetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~*~~*~~*",
          header);
      var jsonRes = jsonDecode(res);
      Dataconstants.authKey = jsonRes["WebLoginValidatePassword3GetDataResult"]
          [0]["AuthorisationKey"];
    } catch (e, s) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    int lastPos = 0;
    // lastPos = detail.trPositionsCmDetailGetDataResult == null ? 0 : detail
    //     .trPositionsCmDetailGetDataResult.length;
    // var netValue = detail.trPositionsCmDetailGetDataResult[detail
    //     .trPositionsCmDetailGetDataResult.length - 1].netValue ?? "0";
    return Scaffold(
      appBar: AppBar(title: Text("Portfolio"), actions: [
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => zeroPortfoliTabular()),
              );
            },
            child:
                SvgPicture.asset("assets/appImages/portfolio/menu_icon.svg")),
        SizedBox(
          width: 15,
        ),
        InkWell(
            onTap: () {
              CommonFunction.marketWatchBottomSheet(context);
            },
            child: SvgPicture.asset("assets/appImages/tranding.svg")),
        SizedBox(
          width: 10,
        )
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                color: Color(0xff7ca6fa).withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Values",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500, size: 14.0),
                                ),
                                Obx(() {
                                  return DetailsControlller.isLoading.value
                                      ? CircularProgressIndicator()
                                      : DetailsControlller
                                              .getDetailResultListItems.isEmpty
                                          ? Text("0")
                                          : Text(
                                              DetailsControlller
                                                  .getDetailResultListItems[
                                                      DetailsControlller
                                                              .getDetailResultListItems
                                                              .length -
                                                          1]
                                                  .valuation
                                                  .toStringAsFixed(2),
                                              // " ",
                                              style: Utils.fonts(
                                                  fontWeight: FontWeight.w900,
                                                  size: 14.0),
                                            );
                                })
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  Color(0xff7ca6fa).withOpacity(0.2),
                              child: Center(
                                  child: SvgPicture.asset(
                                      'assets/appImages/portfolio/zero_wallet.svg')),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Invested",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                Obx(() {
                                  return DetailsControlller.isLoading.value
                                      ? CircularProgressIndicator()
                                      : DetailsControlller
                                              .getDetailResultListItems.isEmpty
                                          ? Text("0.00")
                                          : Text(
                                              DetailsControlller
                                                  .getDetailResultListItems[
                                                      DetailsControlller
                                                              .getDetailResultListItems
                                                              .length -
                                                          1]
                                                  .netValue
                                                  .toStringAsFixed(2),
                                              style: Utils.fonts(
                                                  fontWeight: FontWeight.w900,
                                                  size: 14.0),
                                            );
                                }),
                                Text(
                                  "",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Day's P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: Utils.brightGreenColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: Utils.brightGreenColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Unrealised P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                Obx(() {
                                  return DetailsControlller.isLoading.value
                                      ? const CircularProgressIndicator()
                                      : DetailsControlller
                                              .getDetailResultListItems.isEmpty
                                          ? const Text("0.00")
                                          : Text(
                                              DetailsControlller
                                                  .getDetailResultListItems[
                                                      DetailsControlller
                                                              .getDetailResultListItems
                                                              .length -
                                                          1]
                                                  .unrealisedPl
                                                  .toStringAsFixed(2),
                                              style: Utils.fonts(
                                                  fontWeight: FontWeight.w500,
                                                  size: 14.0,
                                                  color: DetailsControlller
                                                              .getDetailResultListItems[
                                                                  DetailsControlller
                                                                          .getDetailResultListItems
                                                                          .length -
                                                                      1]
                                                              .unrealisedPl <
                                                          0
                                                      ? Colors
                                                          .red // set color to red if unrealisedPl is less than zero
                                                      : Utils
                                                          .brightGreenColor // set color to green if unrealisedPl is greater than or equal to zero
                                                  ),
                                            );
                                }),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Utils.blackColor,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Center(
                    child: SvgPicture.asset(
                        'assets/appImages/portfolio/zero_equity.svg')),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Equity",
                    style: Utils.fonts(fontWeight: FontWeight.w900, size: 14.0),
                  ),
                ),
                Container(
                    height: 30,
                    width: 30,
                    child: Center(
                        child: SvgPicture.asset(
                            'assets/appImages/arrow_right_circle.svg'))),
              ]),
            ),
            // Obx((){
            //   return PortfolioEquityController.isLoading.value
            //       ? CircularProgressIndicator()
            //       : PortfolioEquityController.getPortfolioEquityListItems.isEmpty
            //         ? Text("No data available")
            //         :  InkWell(
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => PortfolioScreenJm(0)),
            //       );
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            //       child: Container(
            //         height: MediaQuery.of(context).size.height * 0.185 ,
            //         width:  MediaQuery.of(context).size.width * 0.99 ,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5.0),
            //             color: Color(0xff7cfaf2).withOpacity(0.2)),
            //         child: Container(
            //           // color: Color(0x7ca6fa),
            //           child: Column(
            //             children: [
            //               Row(
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.symmetric(
            //                         vertical: 13, horizontal: 10
            //                     ),
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: [
            //                         Text(
            //                           "Total Value",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w500,
            //                               size: 14.0),
            //                         ),
            //                         Text(
            //                           PortfolioEquityController.getPortfolioEquityListItems[PortfolioEquityController.getPortfolioEquityListItems.length - 1].netValue.toStringAsFixed(2),
            //                           // " ",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w900,
            //                               size: 14.0),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                   Container(
            //                     height: 75,
            //                   )
            //                 ],
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           "Invested",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w500,
            //                               size: 14.0,
            //                               color: Utils.greyColor),
            //                         ),
            //                         Text(
            //                           PortfolioEquityController.getPortfolioEquityListItems[PortfolioEquityController.getPortfolioEquityListItems.length - 1].netQty.toStringAsFixed(2),
            //                           // " ",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w900, size: 14.0),
            //                         ),
            //                         Text("")
            //                       ],
            //                     ),
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.center,
            //                       children: [
            //                         Text(
            //                           "Day's P/L",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w500,
            //                               size: 14.0,
            //                               color: Utils.greyColor),
            //                         ),
            //                         Text(
            //                           " ",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w500,
            //                               size: 14.0,
            //                               color: Utils.brightGreenColor),
            //                         ),
            //                         Text(
            //                           "3.17%",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w500,
            //                               size: 14.0,
            //                               color: Utils.brightGreenColor),
            //                         )
            //                       ],
            //                     ),
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.end,
            //                       children: [
            //                         Text(
            //                           "Unrealised P/L",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w500,
            //                               size: 14.0,
            //                               color: Utils.greyColor),
            //                         ),
            //                         Text(
            //                           PortfolioEquityController.getPortfolioEquityListItems[PortfolioEquityController.getPortfolioEquityListItems.length - 1].unrealisedPl.toStringAsFixed(2),
            //                           // " ",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w500,
            //                               size: 14.0,
            //                               color: Utils.brightGreenColor),
            //                         ),
            //                         Text(
            //                           " ",
            //                           style: Utils.fonts(
            //                               fontWeight: FontWeight.w500,
            //                               size: 14.0,
            //                               color: Utils.brightGreenColor),
            //                         )
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   );
            //
            // }),
            InkWell(
              onTap: () async {
                await Dataconstants.summaryController.getSummaryApi();
                Dataconstants.holdingController.fetchHolding();
                // Dataconstants.dpHoldingController.getDpHoldings();
                Dataconstants.portfolioHoldingController.getHoldings();
                Dataconstants.portfolioEquityController.getPortfolioEquity();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PortfolioScreenJm(0)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.185,
                  width: MediaQuery.of(context).size.width * 0.99,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xff7cfaf2).withOpacity(0.2)),
                  child: Container(
                    // color: Color(0x7ca6fa),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Total Value",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0),
                                  ),
                                  Obx(() {
                                    return PortfolioEquityController
                                            .isLoading.value
                                        ? CircularProgressIndicator()
                                        : PortfolioEquityController
                                                .getPortfolioEquityListItems
                                                .isEmpty
                                            ? Text("0.00")
                                            : Text(
                                                PortfolioEquityController
                                                    .getPortfolioEquityListItems[
                                                        PortfolioEquityController
                                                                .getPortfolioEquityListItems
                                                                .length -
                                                            1]
                                                    .valuation
                                                    .toStringAsFixed(2),
                                                // " ",
                                                style: Utils.fonts(
                                                    fontWeight: FontWeight.w900,
                                                    size: 14.0),
                                              );
                                  })
                                ],
                              ),
                            ),
                            Container(
                              height: 75,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Invested",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.greyColor),
                                  ),
                                  Obx(() {
                                    return PortfolioEquityController
                                            .isLoading.value
                                        ? CircularProgressIndicator()
                                        : PortfolioEquityController
                                                .getPortfolioEquityListItems
                                                .isEmpty
                                            ? Text("0.00")
                                            : Text(
                                                PortfolioEquityController
                                                    .getPortfolioEquityListItems[
                                                        PortfolioEquityController
                                                                .getPortfolioEquityListItems
                                                                .length -
                                                            1]
                                                    .netValue
                                                    .toStringAsFixed(2),
                                                // " ",
                                                style: Utils.fonts(
                                                    fontWeight: FontWeight.w900,
                                                    size: 14.0),
                                              );
                                  }),
                                  Text(
                                    "",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.brightGreenColor),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Day's P/L",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.greyColor),
                                  ),
                                  Text(
                                    "-",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.brightGreenColor),
                                  ),
                                  Text(
                                    "-",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.brightGreenColor),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Unrealised P/L",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.greyColor),
                                  ),
                                  Obx(() {
                                    return PortfolioEquityController
                                            .isLoading.value
                                        ? CircularProgressIndicator()
                                        : PortfolioEquityController
                                                .getPortfolioEquityListItems
                                                .isEmpty
                                            ? Text("0.00")
                                            : Text(
                                                PortfolioEquityController
                                                    .getPortfolioEquityListItems[
                                                        PortfolioEquityController
                                                                .getPortfolioEquityListItems
                                                                .length -
                                                            1]
                                                    .unrealisedPl
                                                    .toStringAsFixed(2),
                                                style: Utils.fonts(
                                                    fontWeight: FontWeight.w500,
                                                    size: 14.0,
                                                    color: PortfolioEquityController
                                                                .getPortfolioEquityListItems[
                                                                    PortfolioEquityController
                                                                            .getPortfolioEquityListItems
                                                                            .length -
                                                                        1]
                                                                .unrealisedPl <
                                                            0
                                                        ? Colors
                                                            .red // set color to red if unrealisedPl is less than zero
                                                        : Utils
                                                            .brightGreenColor // set color to green if unrealisedPl is greater than or equal to zero
                                                    ),
                                              );
                                  }),
                                  Text(
                                    "-",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.brightGreenColor),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 30,
                    width: 30,
                    child: Center(
                        child: SvgPicture.asset(
                            'assets/appImages/portfolio/zero_derivative.svg'))),
              ),
              Text(
                "Derivative",
                style: Utils.fonts(fontWeight: FontWeight.w900, size: 14.0),
              ),
              Container(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: SvgPicture.asset(
                          'assets/appImages/arrow_right_circle.svg'))),
            ]),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PortfolioScreenJm(1)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.185,
                  width: MediaQuery.of(context).size.width * 0.99,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xffffca5d).withOpacity(0.2),
                  ),
                  child: Container(
                    color: Color(0x7ca6fa),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 13, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "MTM P/L",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                      ),
                                    ),
                                    // FutureBuilder<double>(
                                    //   future: fetchMTMPL(nse_der),
                                    //   builder: (context, snapshot) {
                                    //     if (snapshot.connectionState ==
                                    //         ConnectionState.waiting) {
                                    //       return const CircularProgressIndicator();
                                    //     } else if (snapshot.hasError) {
                                    //       return Text(
                                    //           "Error: ${snapshot.error}");
                                    //     } else if (snapshot.data == null) {
                                    //       return const Text("No data found");
                                    //     } else {
                                    //       // MTM_pl = snapshot.data;
                                    //       return Text(
                                    //         snapshot.data.toStringAsFixed(2),
                                    //         style: Utils.fonts(
                                    //           fontWeight: FontWeight.w500,
                                    //           size: 14.0,
                                    //         ),
                                    //       );
                                    //     }
                                    //   },
                                    // ),
                                      Obx(() {
                                      return PortfolioDerivateController
                                              .isLoading.value
                                          ? CircularProgressIndicator()
                                          : PortfolioDerivateController
                                                  .getDetailResultListItems1
                                                  .isEmpty
                                              ? Text("0.00")
                                              : Text(
                                                  '${Dataconstants.deriv_MTM_PL.toStringAsFixed(2)}',
                                                  style: Utils.fonts(
                                                    fontWeight: FontWeight.w500,
                                                    size: 14.0,
                                                  ),
                                                );
                                    }),
                                    // Obx(()
                                    //   {
                                    //     return PortfolioDerivateController.getDetailResultListItems1.isEmpty?
                                    //         CircularProgressIndicator():Text(
                                    //       '${Dataconstants.deriv_MTM_PL}',
                                    //       style: Utils.fonts(
                                    //         fontWeight: FontWeight.w500,
                                    //         size: 14.0,
                                    //       ),
                                    //     );
                                    //   }
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Margin Used",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.greyColor),
                                  ),
                                  // Obx(() {
                                  //   return PortfolioDerivateController.isLoading
                                  //       .value
                                  //       ? CircularProgressIndicator()
                                  //       : PortfolioDerivateController
                                  //       .getDetailResultListItems.isEmpty
                                  //       ? Text("0.00")
                                  //       : Text(
                                  //     (PortfolioDerivateController
                                  //         .getDetailResultListItems[PortfolioDerivateController
                                  //         .getDetailResultListItems.length - 1].costPrice -
                                  //         PortfolioDerivateController
                                  //             .getDetailResultListItems[PortfolioDerivateController
                                  //             .getDetailResultListItems.length - 1].longQty)
                                  //         .toStringAsFixed(2),
                                  //     style: Utils.fonts(
                                  //         fontWeight: FontWeight.w900,
                                  //         size: 14.0),
                                  //   );
                                  // }),
                                  // FutureBuilder<double>(
                                  //   future: fetchMarginUsed(nse_der),
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return CircularProgressIndicator();
                                  //     } else if (snapshot.hasError) {
                                  //       return Text("Error: ${snapshot.error}");
                                  //     } else if (snapshot.data == null) {
                                  //       return Text("No data found");
                                  //     } else {
                                  //       // marginused = snapshot.data;
                                  //       return Text(
                                  //         snapshot.data.toStringAsFixed(2),
                                  //         style: Utils.fonts(
                                  //           fontWeight: FontWeight.w500,
                                  //           size: 14.0,
                                  //         ),
                                  //       );
                                  //     }
                                  //   },
                                  // ),
                                  Obx(() {
                                    return PortfolioDerivateController
                                        .isLoading.value
                                        ? CircularProgressIndicator()
                                        : PortfolioDerivateController
                                        .getDetailResultListItems1
                                        .isEmpty
                                        ? Text("0.00")
                                        : Text(
                                      '${Dataconstants.deriv_Margin_Used.toStringAsFixed(2)}',
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Day's P/L",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.greyColor),
                                  ),
                                  Text(
                                    "-",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.brightGreenColor),
                                  ),
                                  Text(
                                    "-",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.brightGreenColor),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Realised P/L",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.greyColor),
                                  ),
                                  Text(
                                    "-",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.brightGreenColor),
                                  ),
                                  Text(
                                    "-",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.brightGreenColor),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: SvgPicture.asset(
                        'assets/appImages/portfolio/zero_commodity.svg')),
              ),
              Text(
                "Commodity",
                style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0),
              ),
              Container(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: SvgPicture.asset(
                          'assets/appImages/arrow_right_circle.svg'))),
            ]),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PortfolioScreenJm(3)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.185,
                  width: MediaQuery.of(context).size.width * 0.99,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xff81fba9).withOpacity(0.2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "MTM P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500, size: 14.0),
                                ),
                                // FutureBuilder<double>(
                                //   future: fetchMTMPL(nse_comm),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.connectionState ==
                                //         ConnectionState.waiting) {
                                //       return CircularProgressIndicator();
                                //     } else if (snapshot.hasError) {
                                //       return Text("Error: ${snapshot.error}");
                                //     } else if (snapshot.data == null) {
                                //       return Text("No data found");
                                //     } else {
                                //       MTM_pl = snapshot.data;
                                //       return Text(
                                //         MTM_pl.toStringAsFixed(2),
                                //         style: Utils.fonts(
                                //           fontWeight: FontWeight.w500,
                                //           size: 14.0,
                                //         ),
                                //       );
                                //     }
                                //   },
                                // ),
                                Obx(() {
                                  return PortfolioDerivateController
                                      .isLoading.value
                                      ? CircularProgressIndicator()
                                      : PortfolioDerivateController
                                      .getDetailResultListItems2
                                      .isEmpty
                                      ?const Center(child: Text("0.0",style: TextStyle(color: Colors.black),))
                                      : Text(
                                    '${Dataconstants.cdx_MTM_PL}',
                                    style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Margin Used",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                // FutureBuilder<double>(
                                //   future: fetchMarginUsed(nse_comm),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.connectionState ==
                                //         ConnectionState.waiting) {
                                //       return CircularProgressIndicator();
                                //     } else if (snapshot.hasError) {
                                //       return Text("Error: ${snapshot.error}");
                                //     } else if (snapshot.data == null) {
                                //       return Text("No data found");
                                //     } else {
                                //       marginused = snapshot.data;
                                //       return Text(
                                //         marginused.toStringAsFixed(2),
                                //         style: Utils.fonts(
                                //           fontWeight: FontWeight.w500,
                                //           size: 14.0,
                                //         ),
                                //       );
                                //     }
                                //   },
                                // ),

                                Obx(() {
                                  return PortfolioDerivateController
                                      .isLoading.value
                                      ? CircularProgressIndicator()
                                      : PortfolioDerivateController
                                      .getDetailResultListItems2
                                      .isEmpty
                                      ?const Center(child: Text("0.0",style: TextStyle(color: Colors.black),))
                                      : Text(
                                    '${Dataconstants.cdx_Margin_Used}',
                                    style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                    ),
                                  );
                                }),
                                Text("")
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Day's P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Realised P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 30,
                    width: 30,
                    child: Center(
                        child: SvgPicture.asset(
                            'assets/appImages/portfolio/zero_currency.svg'))),
              ),
              Text(
                "Currency",
                style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0),
              ),
              Container(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: SvgPicture.asset(
                          'assets/appImages/arrow_right_circle.svg'))),
            ]),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PortfolioScreenJm(4)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.185,
                  width: MediaQuery.of(context).size.width * 0.99,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xffa693f6).withOpacity(0.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "MTM P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500, size: 14.0),
                                ),
                                // FutureBuilder<double>(
                                //   future: fetchCurrencyMTMPL(nse_curr),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.connectionState ==
                                //         ConnectionState.waiting) {
                                //       return CircularProgressIndicator();
                                //     } else if (snapshot.hasError) {
                                //       return Text("Error: ${snapshot.error}");
                                //     } else if (snapshot.data == null) {
                                //       return Text("No data found");
                                //     } else {
                                //       marginused = snapshot.data;
                                //       return Text(
                                //         marginused.toStringAsFixed(2),
                                //         style: Utils.fonts(
                                //           fontWeight: FontWeight.w500,
                                //           size: 14.0,
                                //         ),
                                //       );
                                //     }
                                //   },
                                // ),
                                Obx(() {
                                  return PortfolioDerivateController
                                      .isLoading.value
                                      ? CircularProgressIndicator()
                                      : PortfolioDerivateController
                                      .getDetailResultListItems3
                                      .isEmpty
                                      ?const Center(child: Text("0.0",style: TextStyle(color: Colors.black),))
                                      : Text(
                                    '${Dataconstants.cur_MTM_PL}',
                                    style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Invested",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                // "${Dataconstants.deriv_Margin_Used}",
                                // FutureBuilder<double>(
                                //   future: fetchMarginUsed(nse_curr),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.connectionState ==
                                //         ConnectionState.waiting) {
                                //       return CircularProgressIndicator();
                                //     } else if (snapshot.hasError) {
                                //       return Text("Error: ${snapshot.error}");
                                //     } else if (snapshot.data == null) {
                                //       return Text("No data found");
                                //     } else {
                                //       // marginused = snapshot.data;
                                //       return Text(
                                //         snapshot.data.toStringAsFixed(2),
                                //         style: Utils.fonts(
                                //           fontWeight: FontWeight.w500,
                                //           size: 14.0,
                                //         ),
                                //       );
                                //     }
                                //   },
                                // ),
                                Obx(() {
                                  return PortfolioDerivateController
                                      .isLoading.value
                                      ? CircularProgressIndicator()
                                      : PortfolioDerivateController
                                      .getDetailResultListItems3
                                      .isEmpty
                                      ?const Center(child: Text("0.0",style: TextStyle(color: Colors.black),))
                                      : Text(
                                    '${Dataconstants.cur_Margin_Used}',
                                    style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                    ),
                                  );
                                }),
                                Text("")
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Day's P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      color: Utils.greyColor,
                                      size: 14.0),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Realised P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: SvgPicture.asset(
                        'assets/appImages/portfolio/zero_mutual_fund.svg')),
              ),
              Text(
                "Mutual Funds",
                style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0),
              ),
              Container(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: SvgPicture.asset(
                          'assets/appImages/arrow_right_circle.svg'))),
            ]),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PortfolioScreenJm(2)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.185,
                  width: MediaQuery.of(context).size.width * 0.99,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xfff9d3b5).withOpacity(0.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Total Value",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500, size: 14.0),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w700, size: 14.0),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Invested",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                    fontWeight: FontWeight.w700,
                                    size: 14.0,
                                  ),
                                ),
                                Text("")
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Day's P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Unrealised P/L",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.greyColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                ),
                                Text(
                                  "-",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 14.0,
                                      color: Utils.brightGreenColor),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<double> fetchMTMPL(String exchange) async {
    double overallCostPrice = 0.00;
    double overallLongQty = 0.00;
    double overallLongValue = 0.00;
    double MTM_pl = 0.00;
    double marginused = 0.00;

    String rawData = "14610051:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=14610051~~*~~*~~*~~*~~1.0.0.0~~*~~14610051",
        bs64);
    try {
      final Map<String, dynamic> responseData = json.decode(res1);
      final List<Map<String, dynamic>> filteredData = [];

      final List<dynamic> data =
          responseData['TrPositionsDerivativesFIFOCostDetailGetDataResult'];

      for (final Map<String, dynamic> item in data) {
        if (item['Exchange'] == exchange) {
          // overallCostPrice += item['CostPrice'];
          // overallLongQty += item['LongQty'];
          overallLongValue += item['LongValue'];
          MTM_pl = overallLongValue;
          // marginused = overallCostPrice * overallLongQty;

          filteredData.add(
              {'CostPrice': item['CostPrice'], 'LongQty': item['LongQty']});

          print("Overall Costprice $overallCostPrice");
          print("Overall LongQty  $overallLongQty");
          print("Overall LongQty  $MTM_pl");
        }
      }

      return MTM_pl;
    } catch (e, s) {
      print(e);
    }
  }

  Future<double> fetchMarginUsed(String exchange) async {
    double overallCostPrice = 0.00;
    double overallLongQty = 0.00;
    double overallLongValue = 0.00;
    double MTM_pl = 0.00;
    double marginused = 0.00;

    String rawData = "14610051:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=14610051~~*~~*~~*~~*~~1.0.0.0~~*~~14610051",
        bs64);
    try {
      final Map<String, dynamic> responseData = json.decode(res1);
      final List<Map<String, dynamic>> filteredData = [];

      final List<dynamic> data =
          responseData['TrPositionsDerivativesFIFOCostDetailGetDataResult'];

      for (final Map<String, dynamic> item in data) {
        if (item['Exchange'] == exchange) {
          overallCostPrice += item['CostPrice'];
          overallLongQty += item['LongQty'];
          // overallLongValue += item['LongValue'];
          // MTM_pl = overallLongValue;
          marginused = overallCostPrice * overallLongQty;
          filteredData.add(
              {'CostPrice': item['CostPrice'], 'LongQty': item['LongQty']});

          print("Overall Costprice $overallCostPrice");
          print("Overall LongQty  $overallLongQty");
          print("Overall LongQty  $MTM_pl");
        }
      }

      return marginused;
    } catch (e, s) {
      print(e);
    }
  }

  Future<double> fetchCurrencyMTMPL(String exchange) async {
    double overallCostPrice = 0.00;
    double overallLongQty = 0.00;
    double overallShortValue = 0.00;
    double MTM_pl_shortvalue = 0.00;
    double marginused = 0.00;

    String rawData = "14610051:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=14610051~~*~~*~~*~~*~~1.0.0.0~~*~~14610051",
        bs64);
    try {
      final Map<String, dynamic> responseData = json.decode(res1);
      final List<Map<String, dynamic>> filteredData = [];

      final List<dynamic> data =
          responseData['TrPositionsDerivativesFIFOCostDetailGetDataResult'];

      for (final Map<String, dynamic> item in data) {
        if (item['Exchange'] == exchange) {
          // overallCostPrice += item['CostPrice'];
          // overallLongQty += item['LongQty'];
          overallShortValue += item['ShortValue'];
          MTM_pl_shortvalue = overallShortValue;
          // marginused = overallCostPrice * overallLongQty;

          filteredData.add(
              {'CostPrice': item['CostPrice'], 'LongQty': item['LongQty']});

          print("Overall Costprice $overallCostPrice");
          print("Overall LongQty  $overallLongQty");
          print("Overall LongQty  $MTM_pl");
        }
      }

      return MTM_pl_shortvalue;
    } catch (e, s) {
      print(e);
    }
  }

  Future<double> fetchCurrencyMarginUsed(String exchange) async {
    double overallCostPrice = 0.00;
    double overallShortQty = 0.00;
    double currency_marginused = 0.00;

    String rawData = "14610051:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=14610051~~*~~*~~*~~*~~1.0.0.0~~*~~14610051",
        bs64);
    try {
      final Map<String, dynamic> responseData = json.decode(res1);
      final List<Map<String, dynamic>> filteredData = [];

      final List<dynamic> data =
          responseData['TrPositionsDerivativesFIFOCostDetailGetDataResult'];

      for (final Map<String, dynamic> item in data) {
        if (item['Exchange'] == exchange) {
          overallCostPrice += item['CostPrice'];
          overallShortQty += item['ShortQty'];
          // overallLongValue += item['LongValue'];
          // MTM_pl = overallLongValue;
          currency_marginused = overallCostPrice * overallShortQty;

          filteredData.add(
              {'CostPrice': item['CostPrice'], 'LongQty': item['LongQty']});

          print("Overall Costprice $overallCostPrice");
          print("Overall LongQty  $overallLongQty");
          print("Overall LongQty  $MTM_pl");
        }
      }

      return currency_marginused;
    } catch (e, s) {
      print(e);
    }
  }

  // void getmode()  {
  //   data = [];
  //   data.addAll(PortfolioDerivateController.getDetailResultListItems);
  //   data.removeAt(data.length-1);
  //   print('getMode data: $data');
  //   if(data!=null){
  //     for(int i=0;i<data.length;i++)
  //     {
  //       var exchCodense = data[i].exchange;
  //       print("scrip name ${data[i].scripName}");
  //       int exchCode = 0;
  //       if(exchCodense != ""){
  //         num number = num.tryParse(data[i].exchangeInternalScripCode);
  //         if (number == null)
  //         {
  //
  //         }
  //         else
  //         {
  //           exchCode = number;
  //         }
  //       }
  //       else
  //       {
  //         num number = num.tryParse(data[i].scripCode);
  //         if (number == null)
  //         {
  //           // print('Invalid input. Please enter a numeric value.');
  //         }
  //         else
  //         {
  //           exchCode = number;
  //         }
  //       }
  //       var result=CommonFunction.getScripDataModel(
  //           exch: exchCode >= 0 && exchCode < 34999?"N":"B",
  //           exchCode: exchCode,
  //           getNseBseMap: false
  //       );
  //       if(result!=null)
  //       {
  //         print('Close value ${result.close}');
  //         if((checkFunction(data[i].valRate,result.close))=="Profit"){
  //           topGainerList.add(data[i]);
  //           dataListTopGainer.add(result);
  //
  //         }else if(checkFunction(data[i].valRate,result.close)=="Loss") {
  //           topLoserList.add(data[i]);
  //           dataListTopLoss.add(result);
  //         }
  //         print("Result 2 - ${diff(data[i].valRate,result.close)}");
  //         datalist.add(result);
  //         print("Data in get Mode $datalist");
  //       }
  //     }
  //     print('Top Gain: ${topGainerList.length}');
  //     print('Top Loss: ${topLoserList.length}');
  //     print('data : ${data.length}');
  //   }
  // }
  Future<double> fetchRealisedPl(String exchange) async {
    double overallCostPrice = 0.00;
    double overallLongQty = 0.00;
    double overallLongValue = 0.00;
    double MTM_pl = 0.00;
    double marginused = 0.00;
    double reliasedPl = 0.00;
    int ltp = 0;
    double realisedPl = 0.00;
    String scripName = "";
    String rawData = "14610051:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=14610051~~*~~*~~*~~*~~1.0.0.0~~*~~14610051",
        bs64);
    try {
      final Map<String, TrPositionsDerivativesFifoCostDetailGetDataResult>
          responseData = json.decode(res1);

      // final List<TrPositionsDerivativesFifoCostDetailGetDataResult> data =
      //     responseData['TrPositionsDerivativesFIFOCostDetailGetDataResult'] as List;

      // for (final Map<String, dynamic> item in data)
      // {
      //   if (item['Exchange'] == exchange)
      //   {
      //     overallCostPrice += item['CostPrice'];
      //     overallLongQty += item['LongQty'];
      //     scripName = item['ScripName'];
      //     marginused = overallCostPrice * overallLongQty;
      //     List<ScripStaticModel> temp = Dataconstants.exchData[1].tempList;
      //     print(temp);
      //
      //     // realisedPl  = marginused - overallLongQty * ltp;
      //
      //     print("Overall Costprice $overallCostPrice");
      //     print("Overall LongQty  $overallLongQty");
      //     print("Overall LongQty  $MTM_pl");
      //   }
      // }

      return reliasedPl;
    } catch (e, s) {
      print(e);
    }
  }

  void getPortfolioData() {
    setState(() {});
  }

// Future<double> fetchCostPriceAndLongQty3(String exchange) async {
//   String rawData = "14610051:${Dataconstants.authKey}";
//   String bs64 = base64.encode(rawData.codeUnits);
//
//   var res1 = await ITSClient.httpGetDpHoldings(
//       "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=14610051~~*~~*~~*~~*~~1.0.0.0~~*~~14610051",
//       bs64
//   );
//   try {
//     final Map<String, dynamic> responseData = json.decode(res1);
//     final List<Map<String, dynamic>> filteredData = [];
//
//     final List<dynamic> data = responseData['TrPositionsDerivativesFIFOCostDetailGetDataResult'];
//
//     for (final Map<String, dynamic> item in data) {
//       if (item['Exchange'] == exchange) {
//
//         // double overallCostPrice = 0.00;
//         // double overallLongQty = 0.00;
//         // double overallLongValue =0.00;
//         // double MTM_pl =0.00;
//         // double marginused =0.00;
//
//         overallCostPrice += item['CostPrice'];
//         overallLongQty += item['LongQty'];
//         overallLongValue += item['LongValue'];
//         MTM_pl = overallLongValue;
//         marginused = overallCostPrice * overallLongQty;
//
//         filteredData.add({
//           'CostPrice': item['CostPrice'],
//           'LongQty': item['LongQty']
//         });
//
//         print("Overall Costprice $overallCostPrice");
//         print("Overall LongQty  $overallLongQty");
//         print("Overall LongQty  $MTM_pl");
//       }
//     }
//
//     return MTM_pl;
//   } catch (e, s) {
//     print(e);
//   }
// }
// Future<List<Map<String, dynamic>>> fetchCostPriceAndLongQty(String exchange) async {
//   String rawData = "14610051:${Dataconstants.authKey}";
//   String bs64 = base64.encode(rawData.codeUnits);
//
//   var res1 = await ITSClient.httpGetDpHoldings(
//       "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=14610051~~*~~*~~*~~*~~1.0.0.0~~*~~14610051",
//       bs64
//   );
//
//   try {
//     final Map<String, dynamic> responseData = json.decode(res1);
//     final List<Map<String, dynamic>> filteredData = [];
//
//     final List<dynamic> data = responseData['TrPositionsDerivativesFIFOCostDetailGetDataResult'];
//
//
//     for (final Map<String, dynamic> item in data) {
//       if (item['Exchange'] == exchange) {
//         double costPrice = double.parse(item['CostPrice']);
//         int longQty = int.parse(item['LongQty']);
//         overallCostPrice += costPrice;
//         overallLongQty += longQty;
//         filteredData.add({
//           'CostPrice': costPrice,
//           'LongQty': longQty
//         });
//       }
//     }
//
//     print('Overall Cost Price: $overallCostPrice');
//     print('Overall Long Qty: $overallLongQty');
//
//     return filteredData;
//   } catch (e, s) {
//     print(e);
//   }
// }
}

bool check(ScripStaticModel element) {
  if (element.desc == "ADANIENT 27 Apr 2023") {
    print("result ${element.exchCode}");
  }
  return element.desc == "ADANIENT 27 Apr 2023";
}
