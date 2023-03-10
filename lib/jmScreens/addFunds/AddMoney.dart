import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:markets/jmScreens/dashboard/Home.dart';
import 'package:markets/jmScreens/profile/LimitScreen.dart';
import 'package:markets/util/InAppSelections.dart';

import '../../model/jmModel/bankDetails.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';
import 'AddFunds.dart';

class AddMoney extends StatefulWidget {
  var money;
  var fromActivity;
  var type;

  AddMoney(this.money, this.fromActivity, this.type);

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final FocusNode myFocusNodeUserIDLogin = FocusNode();
  final FocusNode myFocusNodePaymentPurposeLogin = FocusNode();
  TextEditingController _loginUserIDController = TextEditingController();
  TextEditingController _paymentPurposeController = TextEditingController();

  // var formatter = NumberFormat('#,##,###');

  setMobileNo(number) {
    _loginUserIDController.text = _loginUserIDController.text.replaceAll(",", "");
    setState(() {
      _loginUserIDController.text += number;
      // _loginUserIDController.text =
      //     formatter.format(int.parse(_loginUserIDController.text));
    });
  }

  removeMobileNo() {
    if (_loginUserIDController.text.isNotEmpty) {
      _loginUserIDController.text = _loginUserIDController.text.replaceAll(",", "");
      setState(() {
        _loginUserIDController.text = _loginUserIDController.text.substring(0, _loginUserIDController.text.length - 1);
        // _loginUserIDController.text =
        //     formatter.format(int.parse(_loginUserIDController.text));
      });
    }
  }

  addDirectMoney(value) {
    if (_loginUserIDController.text.isNotEmpty) {
      var actualValue = int.parse(_loginUserIDController.text.replaceAll(",", ""));
      var finalValue = actualValue + value;
      setState(() {
        // _loginUserIDController.text = formatter.format(finalValue);
        _loginUserIDController.text = finalValue.toString();
      });

      _loginUserIDController.text = finalValue.toString();
    } else {
      _loginUserIDController.text = value.toString();
      setState(() {
        // _loginUserIDController.text = formatter.format(value);
      });
    }
  }

  @override
  void initState() {
    if (widget.fromActivity == "Add Funds") {
      _loginUserIDController.text = widget.money;
    }
    super.initState();
    getPaymentAccessToken();
  }

  getPaymentAccessToken() async {
    var header = {"application": "Intellect"};

    var stringResponse = await CommonFunction.getPaymentAccessToken(header);

    var jsonResponse = jsonDecode(stringResponse);

    //print("Get access token: ${jsonResponse}");

    Dataconstants.fundstoken = jsonResponse['data'];

    //print(Dataconstants.fundstoken);

    getBankdetails();

    return Dataconstants.fundstoken;
  }

  getBankdetails() async {
    try {
      var details = {
        "filtervalue": Dataconstants.feUserID,
        /* "filtervalue2": "NSE|CAPITAL",
        "action": "BankDetails",
        "application": "Intellect",*/
        "token": Dataconstants.fundstoken,
      };

      var stringResponse = await CommonFunction.getBankDetails(details);

      var jsonResponse = jsonDecode(stringResponse);

      if (jsonResponse == null || jsonResponse == '') {
        return;
      }

      final _datanew = jsonResponse['data'];

      var bankname = _datanew[0]['Name'];

      var data = (_datanew).map((i) => Datum.fromJson(i)).toList();

      bankDetails = data;

      bankdetailscontroller.add(requestResponseState.DataReceived);
    } catch (e) {
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          widget.type == "add" ? "Add Money" : "Withdraw Money",
          style: Utils.fonts(color: Utils.greyColor, size: 18.0),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Enter Amount",
                    style: Utils.fonts(size: 16.0, color: Utils.greyColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _loginUserIDController,
                  focusNode: myFocusNodeUserIDLogin,
                  textAlign: TextAlign.center,
                  // showCursor: true,
                  onTap: () {
                    FocusScope.of(context).requestFocus(myFocusNodeUserIDLogin);
                    // myFocusNodeUserIDLogin.requestFocus();
                  },
                  readOnly: true,
                  style: Utils.fonts(size: 25.0, color: Utils.blackColor),
                  decoration: InputDecoration(
                    fillColor: widget.type == "add" ? Utils.lightGreenColor.withOpacity(0.1) : Utils.lightRedColor.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: widget.type == "add" ? Utils.lightGreenColor.withOpacity(0.1) : Utils.lightRedColor.withOpacity(0.1),
                      fontSize: 15,
                    ),
                    focusColor: widget.type == "add" ? Utils.lightGreenColor.withOpacity(0.1) : Utils.lightRedColor.withOpacity(0.1),
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: widget.type == "add" ? Utils.lightGreenColor : Utils.lightRedColor, width: 2.0),
                    ),
                    // labelText: "Mobile No",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (widget.type == "withdraw")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Withdrawable Amount: 9,000   ",
                              textAlign: TextAlign.center,
                              style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5)),
                            ),
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Utils.greyColor.withOpacity(0.6),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("PAYMENT PURPOSE", style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.8))),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _paymentPurposeController,
                        focusNode: myFocusNodePaymentPurposeLogin,
                        showCursor: true,
                        // readOnly: true,
                        style: Utils.fonts(size: 20.0, color: Utils.blackColor),
                        decoration: InputDecoration(
                          suffixIcon: SvgPicture.asset('assets/appImages/edit.svg', height: 20, width: 20, fit: BoxFit.scaleDown),
                          fillColor: Utils.greyColor.withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: widget.type == "add" ? Utils.lightGreenColor.withOpacity(0.1) : Utils.lightRedColor.withOpacity(0.1),
                            fontSize: 15,
                          ),
                          focusColor: widget.type == "add" ? Utils.lightGreenColor.withOpacity(0.1) : Utils.lightRedColor.withOpacity(0.1),
                          filled: true,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Utils.primaryColor.withOpacity(0.5), width: 2.0),
                          ),
                          // labelText: "Mobile No",
                        ),
                      ),
                    ],
                  ),
                if (widget.type == "add")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          addDirectMoney(1000);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Utils.greyColor.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "+1000",
                              style: Utils.fonts(size: 12.0, color: Utils.greyColor),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          addDirectMoney(2000);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Utils.greyColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "+2000",
                              style: Utils.fonts(size: 12.0, color: Utils.greyColor),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          addDirectMoney(5000);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Utils.greyColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "+5000",
                              style: Utils.fonts(size: 12.0, color: Utils.greyColor),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                SizedBox(
                  height: 30,
                ),
                if (widget.type == "add")
                  Container(
                    height: 2,
                    color: Utils.greyColor.withOpacity(0.2),
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setMobileNo("1");
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "1",
                            style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setMobileNo("2");
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "2",
                            style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setMobileNo("3");
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "3",
                            style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setMobileNo("4");
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "4",
                            style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setMobileNo("5");
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "5",
                            style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setMobileNo("6");
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "6",
                            style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setMobileNo("7");
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "7",
                            style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setMobileNo("8");
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "8",
                            style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setMobileNo("9");
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "9",
                            style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     removeMobileNo();
                    //   },
                    //   child: Center(
                    //     child: Container(
                    //       height: 50,
                    //       width: 50,
                    //       decoration: BoxDecoration(
                    //           color: Utils.primaryColor.withOpacity(0.2),
                    //           shape: BoxShape.circle),
                    //       child: Center(
                    //         child: Text(
                    //           ".",
                    //           style: Utils.fonts(
                    //               size: 26.0, color: Utils.primaryColor),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        setMobileNo("0");
                      },
                      child: Center(
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              "0",
                              style: Utils.fonts(size: 26.0, color: Utils.primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        removeMobileNo();
                      },
                      child: Center(
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(color: Utils.primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                          child: Center(
                            child: Icon(Icons.backspace_outlined),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text("Note: You can withdraw money after 4.30 PM as well", textAlign: TextAlign.center, style: Utils.fonts(size: 12.0, color: Utils.greyColor.withOpacity(0.5))),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_loginUserIDController.text == '' || _loginUserIDController.text == null) {
                          CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Please Enter Amount');
                          return;
                        }
                        if (_loginUserIDController.text == '0') {
                          CommonFunction.showSnackBarKey(key: _scaffoldKey, context: context, color: Colors.red, text: 'Please Enter valid Amount');
                          return;
                        }
                        if (widget.type == "add") {
                          if (widget.fromActivity == "Add Funds")
                            Navigator.pop(context, _loginUserIDController.text.toString());
                          else {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFunds()));
                          }
                        } else {
                          var requestJson = {
                            "token": Dataconstants.fundstoken,
                          };
                          // log('checkMarket Payout -- $requestJson');
                          var response = await CommonFunction.checkMarket(requestJson);

                          //print(response.toString());
                          var jsonres = json.decode(response);
                          if (jsonres["status"] == "true") {
                            var requestCollPayout = {
                              "Amount": _loginUserIDController.text.trim(),
                              "Platform_Flg": "MOBILE",

                              /// WEB/MOBILE/EXE
                              "token": Dataconstants.fundstoken,
                              "Merchant_RefNo": "", //if Req_action is Modify/cancel then pass this from GetPayoutDetail
                              "Id": "", //if Req_action is Modify/cancel then pass this from GetPayoutDetails ID
                              "Req_action": "Initiate" //Initiate / Modify /Cancel
                            };

                            var resPayout = await CommonFunction.getCollectPayout(requestCollPayout);
                            var jsonres = json.decode(resPayout);
                            if (jsonres["status"] == "true") {
                              bottomSheets("success", jsonres["message"], "Your reference no for transaction is ${jsonres["merchantRefNo"]}",
                                  "Your request for withdrawal has been received and requested amount will be credited based on available balance");
                            }
                          } else {
                            bottomSheets("success", jsonres["message"], "", "");
                          }

                          // bottomSheets(
                          //     "success",
                          //     "Withdrawal Request Received",
                          //     "",
                          //     "Your request for withdrawal has been received and requested amount will be credited based on available balance");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                        child: Text(
                          widget.type == "add" ? "Add Money to Account" : "Withdraw Money from Account",
                          style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bottomSheets(type, errorTitle, amount, description) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 2,
                width: 40,
                color: Utils.greyColor.withOpacity(0.4),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SvgPicture.asset(type == "error" ? "assets/appImages/fundsFailed.svg" : "assets/appImages/successFund.svg"),
            SizedBox(
              height: 30,
            ),
            Text(
              errorTitle,
              style: Utils.fonts(
                size: 20.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              amount,
              style: Utils.fonts(
                size: 17.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                description,
                style: Utils.fonts(size: 13.0, color: Utils.greyColor.withOpacity(0.5)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            InAppSelection.mainScreenIndex = 0;
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => MainScreen(
                                          toChangeTab: true,
                                        )),
                                (route) => true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            child: Text(
                              type == "error" ? "Retry" : "Take me to Home",
                              style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: Utils.greyColor))))),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LimitScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            child: Text(
                              type == "error" ? "Fund Details" : "Got it",
                              style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ))))
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
      backgroundColor: Utils.whiteColor,
    );
  }
}
