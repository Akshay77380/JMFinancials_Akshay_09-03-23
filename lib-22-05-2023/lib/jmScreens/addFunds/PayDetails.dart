import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'package:markets/model/jmModel/fundtransactionmodel.dart';

import 'AddMoney.dart';

class PayDetails extends StatefulWidget {
  String status;
  Detail details;
  Datum fundTransactionModel;

  PayDetails({this.status, this.details, this.fundTransactionModel});

  @override
  State<PayDetails> createState() => _PayDetailsState();
}

class _PayDetailsState extends State<PayDetails> {
  @override
  void initState() {
    // TODO: implement initState
    getPaymentAccessToken();
    super.initState();
  }

  getPaymentAccessToken() async {
    var header = {"application": "Intellect"};
    var stringResponse = await CommonFunction.getPaymentAccessToken(header);
    var jsonResponse = jsonDecode(stringResponse);
    print("Get access token: ${jsonResponse}");
    Dataconstants.fundstoken = await jsonResponse['data'];
    await Dataconstants.bankDetailsController.getBankDetails();
    // print(Dataconstants.fundstoken);
    // getBankdetails();
    return Dataconstants.fundstoken;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Spacer(),
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                            style: Utils.fonts(color: Utils.greyColor, size: 15.0, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            widget.fundTransactionModel.bankName ?? "",
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
                            style: Utils.fonts(color: Utils.greyColor, size: 15.0, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            widget.status.toString().toUpperCase(),
                            style: Utils.fonts(
                                fontWeight: FontWeight.w700,
                                size: 15.0,
                                color: widget.status.toString().toUpperCase() == "PENDING"
                                    ? Utils.primaryColor
                                    : widget.status.toString().trim().toUpperCase() == "CANCELLED"
                                        ? Utils.darkRedColor
                                        : Utils.darkGreenColor),
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
                        Text("Amount", style: Utils.fonts(size: 15.0, color: Utils.blackColor, fontWeight: FontWeight.w700)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.fundTransactionModel.status == "Pending" ? "₹${widget.details.amount}" : "₹${widget.fundTransactionModel.approvedAmount}",
                                style: Utils.fonts(
                                    size: 35.0,
                                    color: double.parse(widget.details.amount) < 0
                                        ? Utils.darkRedColor
                                        : double.parse(widget.fundTransactionModel.approvedAmount) < 0
                                            ? Utils.darkRedColor
                                            : Utils.darkGreenColor,
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
                      Text("Client ID", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      Text(widget.fundTransactionModel.clientCode, style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Source ID", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      Text(widget.fundTransactionModel.clientCode, style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Instruction No.", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      Text(widget.fundTransactionModel.refNo, style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Instruction Date & Time", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      Text(widget.fundTransactionModel.transactionDate.toString(), style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w700))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.status.toString().toUpperCase() == "SUCCESS")
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Bank Ref. No.", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                            Text("234134223", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
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
                      Text("Remark", style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                      Text("Towards Clear Balance", style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w700))
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
          if (widget.fundTransactionModel.status.toString().toUpperCase() == "PENDING")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0))),
                    color: Utils.primaryColor,
                    child: InkWell(
                      onTap: () async {
                        // Navigator.pop(context);
                        var requestCollPayout = {
                          "Amount": widget.details.amount,
                          "Platform_Flg": "MOBILE",

                          /// WEB/MOBILE/EXE
                          "token": Dataconstants.fundstoken,
                          "Merchant_RefNo": widget.details.refNo, //if Req_action is Modify/cancel then pass this from GetPayoutDetail
                          "Id": widget.details.id, //if Req_action is Modify/cancel then pass this from GetPayoutDetails ID
                          "Req_action": "Cancel" //Initiate / Modify /Cancel
                        };
                        var response = await CommonFunction.getCollectPayout(requestCollPayout);
                        var jsondata = json.decode(response);
                        var message = jsondata["message"];
                        CommonFunction.showBasicToast(message);
                        Navigator.pop(context);

                        CommonFunction.getpaymentstatus();
                        CommonFunction.getPaymentAccessTokenFund();
                        CommonFunction.getLastDates(1);

                        setState(() {});
                        print(message);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Utils.whiteColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text("CANCEL", style: Utils.fonts(size: 16.0, color: Utils.greyColor)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                    ),
                    color: Utils.primaryColor,
                    child: InkWell(
                      onTap: () {
                        Dataconstants.payInModifyButton
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMoney(
                                          money: widget.fundTransactionModel.status == "Pending" ? widget.details.amount : widget.fundTransactionModel.amount,
                                          fromActivity: "PayOut",
                                          type: "modify",
                                          merchantref: widget.details.refNo,
                                          id: widget.details.id,
                                        )))
                            : null;
                        Dataconstants.payInModifyButton = false;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Utils.primaryColor,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text("MODIFY", style: Utils.fonts(size: 16.0, color: Utils.whiteColor)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }
}
