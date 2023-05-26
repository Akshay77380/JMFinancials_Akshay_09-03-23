import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markets/jmScreens/addFunds/CombinedLedger.dart';
import 'package:markets/jmScreens/addFunds/PayDetails.dart';

import '../../controllers/PayInController.dart';
import '../../controllers/fundtransactioncontroller.dart';
import '../../controllers/limitController.dart';
import '../../model/PayInmodel.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';

class PayInScreen extends StatefulWidget {

  @override
  State<PayInScreen> createState() => _PayInScreenState();
}

class _PayInScreenState extends State<PayInScreen> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FundTransactionControlller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Utils.primaryColor.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            " Balance",
                            style: Utils.fonts(
                              size: 12.0,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            LimitController.limitData.value.openingBalance,
                            // "0.00",
                            style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600),
                          )
                          // Obx(() {
                          //   return Text(
                          //     Dataconstants.payoutamount,
                          //     style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600),
                          //   );
                          // }),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      "View Pay Out Ledger for",
                      style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CombinedLedger()));
                        },
                        child: SvgPicture.asset("assets/appImages/download.svg"))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  // height: 55,
                  padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Utils.dullWhiteColor),
                  child: DropdownButton<String>(
                      isExpanded: true,
                      items: CommonFunction.productItems.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                          ),
                          onTap: () {
                            CommonFunction.productType = CommonFunction.productItems.values.toString();
                          },
                        );
                      }).toList(),
                      underline: SizedBox(),
                      hint: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CommonFunction.productType,
                            style: Utils.fonts(size: 14.0, color: Utils.dullWhiteColor),
                          ),
                        ],
                      ),
                      icon: Icon(
                        // Add this
                        Icons.arrow_drop_down, // Add this
                        color: Theme.of(context).textTheme.bodyText1.color, // Add this
                      ),
                      onChanged: (value) {
                        // var todayDate = DateTime.now();
                        // var last30Days = new DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
                        // var last10Days = new DateTime(todayDate.year, todayDate.month, todayDate.day - 10);
                        // List<Detail> _list = [];
                        // if (value == "Last 10 Days") {
                        //   for (int i = 0; i < FundTransactionControlller.getFundTransactionListItems.length; i++) {
                        //     print(CommonFunction.productItems.values.toString().split(",")[0].replaceAll("(", ""));
                        //     final DateTime now = DateTime.now();
                        //     DateFormat formatter = DateFormat('yyyy-mm-dd');
                        //     var datecurrentDateEpoch = formatter.format(now);
                        //     var currentDateEpoch = now.millisecondsSinceEpoch;
                        //     var last10DaysEpoch = last10Days.millisecondsSinceEpoch;
                        //     if (currentDateEpoch <= last10DaysEpoch) {
                        //       _list.add(FundTransactionControlller.getFundTransactionListItems[i]);
                        //     }
                        //   }
                        // } else if (value == "Last 30 Days") {
                        //   for (int i = 0; i < FundTransactionControlller.getFundTransactionListItems.length; i++) {
                        //     print(CommonFunction.productItems.values.toString().split(",")[0].replaceAll("(", ""));
                        //     final DateTime now = DateTime.now();
                        //     DateFormat formatter = DateFormat('yyyy-mm-dd');
                        //     var datecurrentDateEpoch = formatter.format(now);
                        //     // var datecurrentDateEpoch = DateFormat('yyyy-mm-dd').parse(DateTime.now().toString());
                        //     var currentDateEpoch = now.millisecondsSinceEpoch;
                        //     var last30DaysEpoch = last30Days.millisecondsSinceEpoch;
                        //     if (last30DaysEpoch <= currentDateEpoch) {
                        //       _list.add(FundTransactionControlller.getFundTransactionListItems[i]);
                        //     }
                        //   }
                        // }
                        //
                        // if (_list.length > 0) {
                        //   FundTransactionControlller.getFundTransactionListItems.clear();
                        // }
                        // setState(() {
                        //   FundTransactionControlller.getFundTransactionListItems.addAll(_list);
                        //   CommonFunction.productType = value;
                        // });
                      }),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                reverse: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){

                      showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: true,
                                  builder: (context) => PayDetailsPayIn(context , index));

                    },
                    child: Container(
                      height: 90,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Utils.dullWhiteColor.withOpacity(0.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Fund Added",
                                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          PayInController.getPayInTransactionListItems[index].completedDate.toString(),
                                          style: Utils.fonts(size: 12.0, color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          PayInController.getPayInTransactionListItems[index].amount,
                                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.darkRedColor),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: PayInController.getPayInTransactionListItems[index].status == Status.FAILED? Utils.lightRedColor.withOpacity(0.2) : Utils.lightGreenColor.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  PayInController.getPayInTransactionListItems[index].status == Status.FAILED ? "FAILED" : "SUCCESS",
                                  style: Utils.fonts(size: 12.0, color:  PayInController.getPayInTransactionListItems[index].status == Status.FAILED ? Utils.lightRedColor.withOpacity(0.7) : Utils.lightGreenColor.withOpacity(0.7)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  // return Text("ghjjk");
                },
                itemCount: PayInController.getPayInTransactionListItems.length,
              ),
            ),
          ),
        ],
      );
    });
  }
}


Widget PayDetailsPayIn(context, index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Spacer(),
          Card(
            margin: EdgeInsets.zero,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pay Out Details",
                        style: Utils.fonts(size: 20.0),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close),
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
                            "BANK",
                            style: Utils.fonts(
                                color: Utils.greyColor,
                                size: 15.0,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            " ",
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
                            "Status",
                            style: Utils.fonts(
                                color: Utils.greyColor,
                                size: 15.0,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            PayInController.getPayInTransactionListItems[index].status.name.toString(),
                            style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size: 15.0,
                              color:Utils.primaryColor
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
                        Text("Amount",
                            style: Utils.fonts(
                                size: 15.0,
                                color: Utils.blackColor,
                                fontWeight: FontWeight.w700)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(PayInController.getPayInTransactionListItems[index].amount,

                                style: Utils.fonts(
                                    size: 35.0,
                                    color: Utils.darkGreenColor,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Client ID",
                          style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Utils.greyColor)),
                      Text(PayInController.getPayInTransactionListItems[index].clientCode.toString(),
                          style: Utils.fonts(
                              size: 12.0,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Source ID",
                          style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Utils.greyColor)),
                      Text(PayInController.getPayInTransactionListItems[index].source.toString(),
                          style: Utils.fonts(
                              size: 12.0,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Instruction No.",
                          style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Utils.greyColor)),
                      Text(" ",
                          style: Utils.fonts(
                              size: 12.0,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Instruction Date & Time",
                          style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Utils.greyColor)),
                      Text(PayInController.getPayInTransactionListItems[index].completedDate.toString(),
                          style: Utils.fonts(
                              size: 12.0,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // if (widget.status.toString().toUpperCase() == "SUCCESS")
                  //   Column(
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text("Bank Ref. No.",
                  //               style: Utils.fonts(
                  //                   size: 14.0,
                  //                   fontWeight: FontWeight.w400,
                  //                   color: Utils.greyColor)),
                  //           Text("234134223",
                  //               style: Utils.fonts(
                  //                   size: 14.0,
                  //                   color: Utils.blackColor,
                  //                   fontWeight: FontWeight.w700))
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //     ],
                  //   ),
                  // if (widget.status.toString().toUpperCase() == "PENDING")
                  //   Column(
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text("Remark",
                  //               style: Utils.fonts(
                  //                   size: 14.0,
                  //                   fontWeight: FontWeight.w400,
                  //                   color: Utils.greyColor)),
                  //           Text("Towards Clear Balance",
                  //               style: Utils.fonts(
                  //                   size: 14.0,
                  //                   color: Utils.blackColor,
                  //                   fontWeight: FontWeight.w700))
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: 10,
                  //       ),
                  //     ],
                  //   ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Remark",
                          style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Utils.greyColor)),
                      Text(" ",
                          style: Utils.fonts(
                              size: 12.0,
                              fontWeight: FontWeight.w700))
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
          // if (widget.fundTransactionModel.status.toString().toUpperCase() == "PENDING")
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Expanded(
          //         child: Card(
          //           margin: EdgeInsets.zero,
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.only(
          //                   topLeft: Radius.circular(10.0),
          //                   bottomLeft: Radius.circular(10.0))),
          //           color: Utils.primaryColor,
          //           child: InkWell(
          //             onTap: () async {
          //               // Navigator.pop(context);
          //               var requestCollPayout = {
          //                 "Amount": widget.details.amount,
          //                 "Platform_Flg" : "MOBILE",  /// WEB/MOBILE/EXE
          //                 "token" : Dataconstants.fundstoken,
          //                 "Merchant_RefNo": widget.details.refNo, //if Req_action is Modify/cancel then pass this from GetPayoutDetail
          //                 "Id": widget.details.id,   //if Req_action is Modify/cancel then pass this from GetPayoutDetails ID
          //                 "Req_action": "Cancel" //Initiate / Modify /Cancel
          //               };
          //               var response = await CommonFunction.getCollectPayout(requestCollPayout);
          //               var jsondata = json.decode(response);
          //               var message = jsondata["message"];
          //               CommonFunction.showBasicToast(message);
          //               Navigator.pop(context);
          //
          //               CommonFunction.getpaymentstatus();
          //               CommonFunction.getPaymentAccessTokenFund();
          //               CommonFunction.getLastDates(1);
          //
          //               setState(() {
          //               });
          //               print(message);
          //             },
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 color: Utils.whiteColor,
          //                 borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(10.0),
          //                     bottomLeft: Radius.circular(10.0)),
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(20.0),
          //                 child: Center(
          //                   child: Text("CANCEL",
          //                       style: Utils.fonts(
          //                           size: 16.0, color: Utils.greyColor)),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Card(
          //           margin: EdgeInsets.zero,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.only(
          //                 topRight: Radius.circular(10.0),
          //                 bottomRight: Radius.circular(10.0)),
          //           ),
          //           color: Utils.primaryColor,
          //           child: InkWell(
          //             onTap: (){
          //               Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoney(money: widget.fundTransactionModel.status == "Pending" ? widget.details.amount : widget.fundTransactionModel.amount,fromActivity: "PayOut", type: "modify",merchantref: widget.details.refNo,id: widget.details.id,)));
          //             },
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 color: Utils.primaryColor,
          //                 borderRadius: BorderRadius.only(
          //                     topRight: Radius.circular(10.0),
          //                     bottomRight: Radius.circular(10.0)),
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(20.0),
          //                 child: Center(
          //                   child: Text("MODIFY",
          //                       style: Utils.fonts(
          //                           size: 16.0, color: Utils.whiteColor)),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   )
          // else
          //   SizedBox.shrink(),
        ],
      ),
    );

}
