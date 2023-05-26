import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/controllers/DetailController.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';
import 'combinedledgerbackoffice.dart';
import 'contractnote.dart';
import 'pnlreport.dart';
import 'sebimtfcfrreport.dart';
import 'sebimtfledger.dart';
import 'tradereport.dart';

class BackOfficeReport extends StatefulWidget {
  @override
  State<BackOfficeReport> createState() => _BackOfficeReportState();
}

class _BackOfficeReportState extends State<BackOfficeReport> {

  var res;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fun1();

      await CommonFunction.backOfficeTrPLSummaryCMFY();
      await CommonFunction.backOfficeTrPLSummaryCMFYDetail();
      await CommonFunction.backOfficeTrPLSummaryCMYTDDetail2();

      // await Dataconstants.summaryController.getSummaryApi();
      // await Dataconstants.detailsController.getDetailResult();
      //
      // await CommonFunction.getPnlYears();
      // Dataconstants.trPositionsCMDetailController.getTrPositionsCmDetailGetDataResult();
    });

    super.initState();
  }

  void fun1()async{
    try{
      String mydata = "pqrs@@1008_pqrs##1008_11";
      String bs64 = base64.encode(mydata.codeUnits);
      //print(bs64);

      var header = {
        "authkey" : bs64
      };

      res = await ITSClient.httpGetPortfolio(
          "https://mobilepms.jmfonline.in/WebLoginValidatePassword3.svc/WebLoginValidatePassword3GetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~*~~*~~*",
          header
      );

      var jsonRes = jsonDecode(res);

      Dataconstants.authKey = jsonRes["WebLoginValidatePassword3GetDataResult"][0]["AuthorisationKey"];

    }catch(e, s){
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 2,
        backgroundColor: Utils.whiteColor,
        title: Text(
          "Back office Reports",
          style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
        ),
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
            // setState(() {
            //   DataConstants.moreSelectedIndex = 0;
            // });
          },
          child: Icon(
            Icons.arrow_back,
            color: Utils.greyColor,
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                // InAppSelection.mainScreenIndex = 1;
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (_) => MainScreen(
                      toChangeTab: false,
                    )), (route) => false);
              },
              child: SvgPicture.asset('assets/appImages/tranding.svg')),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>CombinedLedgerBackoffice())),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/appImages/backoffice/combledreport.svg',
                              ),
                              SizedBox(width: 10,),
                              Text("Combined Ledger Reports",
                                style: Utils.fonts(
                                  size: 18.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>TradeReports())),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/appImages/backoffice/traderepot.svg',
                              ),
                              SizedBox(width: 10,),
                              Text("Trade Reports",
                                style: Utils.fonts(
                                  size: 18.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: ()=>{
                      
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/appImages/backoffice/marketupdatereview.svg',
                              ),
                              SizedBox(width: 10,),
                              Text("Market Update & Review Reports",
                                style: Utils.fonts(
                                  size: 18.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SebiMtfLedger())),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/appImages/backoffice/sebimtf.svg',
                              ),
                              SizedBox(width: 10,),
                              Text("Sebi MTF Ledger Reports",
                                style: Utils.fonts(
                                  size: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SebiMtfCfrReport())),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/appImages/backoffice/sebimtfcfr.svg',
                              ),
                              SizedBox(width: 10,),
                              Text("Sebi MTF CFR Reports",
                                style: Utils.fonts(
                                  size: 18.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>backOffice())),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/appImages/backoffice/pndlreport.svg',
                              ),
                              SizedBox(width: 10,),
                              Text("P&L Reports",
                                style: Utils.fonts(
                                  size: 18.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ContractNote())),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/appImages/backoffice/contranctnote.svg',
                              ),
                              SizedBox(width: 10,),
                              Text("Contract Notes",
                                style: Utils.fonts(
                                  size: 18.0,
                                  color: Utils.blackColor,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
