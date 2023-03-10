import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/exchData.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/Utils.dart';
import '../../util/Dataconstants.dart';
import 'package:http/http.dart' as http;
class EquitySipOrderReview extends StatelessWidget {
  final String qty,
      frequency,
      duration, name, exch,startDate,endDate, ltp, ordeValue;

  var exchType,symbol,upperLimitPrice,lowerLimitPrice,scriptCode;



  EquitySipOrderReview({
    @required this.qty,
    this.frequency,
    this.duration,
    this.name,
    this.exch,
    this.symbol,
    this.exchType,
    this.startDate,
    this.endDate,
    this.ltp,
    this.ordeValue,
    this.upperLimitPrice,
    this.lowerLimitPrice,
    this.scriptCode});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 260,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Review your SIP",
                            style: Utils.fonts(size: 20.0),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  color: Colors.green.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2.0),
                                child: Text(
                                  "CLOSE",
                                  style: Utils.fonts(
                                      size: 16.0, color: Utils.blackColor),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "SIP QUANTITY",
                        style: Utils.fonts(
                            color: Utils.greyColor,
                            size: 20.0),
                      ),
                      Text(
                        qty,
                        style: Utils.fonts(
                          fontWeight: FontWeight.w700,
                          size: 22.0,
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
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                frequency,
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 15.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "No. of Months",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                duration,
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 15.0,
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
                                style: Utils.fonts(
                                    size: 15.0, color: ThemeConstants.buyColor)),
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
                                            style: Utils.fonts(
                                                size: 20.0,
                                                color: Utils.blackColor,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Text(exch == 'N' ? 'NSE Equity' : 'BSE Equity',
                                          style: Utils.fonts(
                                              size: 14.0,
                                              color: Utils.blackColor,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  Text('Market Price',
                                      style: Utils.fonts(
                                          size: 14.0,
                                          color: Utils.blackColor,
                                          fontWeight: FontWeight.w500)),
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
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text(startDate,
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("End Date",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text(endDate,
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Product",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('-',
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("LTP",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text(ltp,
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order Value",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text(ordeValue,
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: ThemeConstants.buyColor,
                  child: Column(
                    children: [
                        InkWell(
                          onTap: () async {
                            // String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(startDate as DateTime);
                            // String startDateString = 'StartDate:"$formattedDate"';
                            // qty,
                            // frequency,
                            // duration, name, exch, startDate, endDate, ltp, ordeValue;



                            DateTime start_parsedDate = DateFormat('dd MMM yyyy').parse(startDate);
                            DateTime end_parsedDate = DateFormat('dd MMM yyyy').parse(endDate);

                            String start_formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(start_parsedDate);
                            String end_formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(end_parsedDate);

                            print(start_formattedDate);
                            print(end_formattedDate);

                            print("Sip Data :"
                                "Exch :$exch"+","+
                                "Exch type:$exchType"+","+
                                "Symbol :$symbol"+","+
                                "ScriptCode:$scriptCode"+","+
                                "StartDate: $start_formattedDate"+","+
                                "ExpiryDate: $end_formattedDate"+","+
                                "SIPPeriod :$duration"+","+
                                "Qty :$qty"+","+
                                "Value:$ordeValue"+","+
                                "UpperPriceLimit :$upperLimitPrice"+","+
                                "LowerPriceLimit $lowerLimitPrice"+","
                                "Session token : ${Dataconstants.loginData.data.jwtToken}"
                                );
                            http.Response response =  await http.post(Uri.parse("https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/create"),
                                headers: {
                                  'Accept': 'application/json',
                                  'Content-Type': 'application/json'
                                },
                                body: jsonEncode({
                                  "Source": "MOB",
                                  "SessionToken": Dataconstants.loginData.data.jwtToken,
                                  "ClientCode": Dataconstants.feUserID,
                                  "APIVersion" : 2,
                                  "Data": {
                                    "Exch":exch,
                                    "ExchType":"C",
                                    "Symbol":name,
                                    "ScripCode":scriptCode,
                                    "StartDate":start_formattedDate,
                                    "ExpiryDate":end_formattedDate,
                                    "SIPPeriod":duration,
                                    "Qty":qty,
                                    "Value":ordeValue,
                                    "UpperPriceLimit":upperLimitPrice,
                                    "LowerPriceLimit":lowerLimitPrice
                                  }
                                }));
                            print("Response body${response.body}");
                            print("session Token :${Dataconstants.loginData.data.jwtToken}");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 20.0),
                            child: Text("START SIP",
                                style: Utils.fonts(
                                    size: 16.0, color: Utils.whiteColor)),
                          ),
                        ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
