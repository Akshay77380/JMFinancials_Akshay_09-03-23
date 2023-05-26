import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:markets/jmScreens/addFunds/FundSuccess.dart';
import 'package:markets/util/BrokerInfo.dart';

import '../../controllers/BankDetailsController.dart';
import '../../model/jmModel/bankDetails.dart';
import '../../model/jmModel/validateupi.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';

// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:razorpay_flutter_customui/razorpay_flutter_customui.dart';
import 'package:quantupi/quantupi.dart';
import '../../widget/loader.dart';
import '../profile/LimitScreen.dart';
import 'AddMoney.dart';

class AddFunds extends StatefulWidget {
  @override
  State<AddFunds> createState() => _AddFundsState();
}

@override
class _AddFundsState extends State<AddFunds> {
  var isBorder = false;
  var selectUPI;

  var selectedBank = -1;
  var selectedbankname = '';
  var selectedbankaccno;
  var selectedifsccode;
  var upiSelected = false;
  var netbanking = false;
  var isnetbanking = false;
  var formatter = NumberFormat('#,##,###');
  var upibank = false;
  var showBottomSheet = false;
  String dropDownValue;
  var upiAppsSelected = false;
  var upiIdSelected = false;
  var netbankingSelected = false;
  var googlePay = false;
  var datanew;
  var items = [];
  bool upiIdDisplay = false;
  var netbankupi = false;
  var _apps;
  var paytmSelected = false;
  var bhim = false;
  var phonePe = false;
  var upiValidate = 0;
  var ifscNumber;
  bool disableProceed = false;

  Quantupi upi;
  var _razorpay;
  TextEditingController _loginUserIDController = TextEditingController();
  TextEditingController _upiController = TextEditingController();
  final FocusNode myFocusNodeUserIDLogin = FocusNode();
  final FocusNode myFocusNodePaymentPurposeLogin = FocusNode();
  final StreamController<requestResponseState> _streamupiContoller = StreamController.broadcast();
  double moneynew = 0.0;
  List bankdetails = List();
  var _installedApps;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

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
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => SimplifiedLogin()));
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
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => AddFunds()));
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

  void _handlePaymentSuccess(Map<dynamic, dynamic> response) async {
    // //print("$response");
    setState(() {
      disableProceed = false;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FundSuccess(_loginUserIDController.text, response['data']['razorpay_payment_id'])));
    Dataconstants.limitController.getLimitsData();
    try {
      var data = {
        'payment_id': '${response['data']['razorpay_payment_id']}',
        'order_id': '${response['data']['razorpay_order_id']}',
        'signature': '${response['data']['razorpay_signature']}',
      };

      var json = {
        "Payment_status": "Success", // pass Success or Failed based on handler
        "Order_Id": response['data']['razorpay_order_id'], // Order Id created in Collect request
        "Respjsonstring": '$data', // Response received after txn
      };
      //print('success payload----$json');
      var stringResponse = await CommonFunction.sendPaymentResponse(json);

      var jsonResponse = jsonDecode(stringResponse);
    } catch (e) {
      //print(e);
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FundSuccess(_loginUserIDController.text, response['data']['razorpay_payment_id'])));

    // Do something when payment succeeds
  }

  void _handlePaymentError(Map<dynamic, dynamic> response) async {
    print(response['data']['message']);
    setState(() {
      disableProceed = false;
    });
    try {
      // //print("rs: ${response.message.toString()}");
      //   // var jsonResponse = jsonDecode(stringResponse);
      //   //
      //   // if(jsonResponse == null || jsonResponse == ''){
      //   //   return;
      //   // } else {
      //   //   //print("_handlePaymentSuccess -- $jsonResponse");
      //   // }
      //print(response);
      var data = {
        'payment_id': '${response['data']['razorpay_payment_id']}',
        'order_id': '${response['data']['razorpay_order_id']}',
        'signature': '${response['data']['razorpay_signature']}',
      };

      var json = {
        "Payment_status": "Failure", // pass Success or Failed based on handler
        "Order_Id": Dataconstants.ordernumber, // Order Id created in Collect request
        "Respjsonstring": response['data']['message'], // Response received after txn
      };
      //print('success payload----$json');
      var stringResponse = await CommonFunction.sendPaymentResponse(json);

      showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          context: context,
          builder: (context) {
            return DraggableScrollableSheet(
                expand: false,
                minChildSize: 0.3,
                initialChildSize: 0.4,
                maxChildSize: 0.45,
                builder: (context, scrollController) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      SvgPicture.asset("assets/appImages/failedFunds.svg"),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Funds addition failed",
                        style: Utils.fonts(fontWeight: FontWeight.w700, size: 26.0),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Rs ${_loginUserIDController.text}",
                        style: Utils.fonts(fontWeight: FontWeight.w600, size: 20.0),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Is Your money debited from your account? Don't worry!",
                        style: Utils.fonts(color: Utils.greyColor),
                      ),
                      Text(
                        "Your money will be credited back in 48 hrs",
                        style: Utils.fonts(color: Utils.greyColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), border: Border.all()),
                              child: Center(child: Text("Retry")),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LimitScreen()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Utils.primaryColor, border: Border.all()),
                              child: Center(
                                child: Text(
                                  "Fund Details",
                                  style: TextStyle(color: Utils.whiteColor, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                });
          });
    } catch (e, s) {
      //print(e);
    }
    // Do something when payment fails

    //print(response);
  }

  getDetails() {
    for (var i = 0; i < BankDetailsController.getBankDetailsListItems.length; i++) {
      if (BankDetailsController.getBankDetailsListItems[i].id.toString().split("|")[0] == Dataconstants.dropDownInitialValue) {
        setState(() {
          Dataconstants.ifsc = BankDetailsController.getBankDetailsListItems[i].ifsc;
          Dataconstants.bankName = BankDetailsController.getBankDetailsListItems[i].name;
          Dataconstants.accountNo = BankDetailsController.getBankDetailsListItems[i].accountNo;
          Dataconstants.clientName = BankDetailsController.getBankDetailsListItems[i].clientName;
        });
      }
    }
  }

  @override
  Future<void> initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpay.initilizeSDK('rzp_live_s3EsaEfnuWiP9X');
    bankdetails = bankDetails;
  }

  addDirectMoney(value) {
    if (_loginUserIDController.text.isNotEmpty) {
      var actualValue = int.parse(_loginUserIDController.text.replaceAll(",", ""));
      var finalValue = actualValue + value;
      setState(() {
        _loginUserIDController.text = formatter.format(finalValue);
      });
    } else {
      setState(() {
        _loginUserIDController.text = formatter.format(value);
      });
    }
  }

  @override
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  getPaymentAccessToken() async {
    var header = {"application": "Intellect"};

    var stringResponse = await CommonFunction.getPaymentAccessToken(header);

    var jsonResponse = jsonDecode(stringResponse);

    //print("Get access token: ${jsonResponse}");

    Dataconstants.fundstoken = await jsonResponse['data'];

    // getBankdetails();

    Dataconstants.bankDetailsController.getBankDetails();

    //print(Dataconstants.fundstoken);

    // getBankdetails();

    return Dataconstants.fundstoken;
  }

  getItems() async {
    items.clear();

    for (var i = 0; i < BankDetailsController.getBankDetailsListItems.length; i++) {
      items.add(BankDetailsController.getBankDetailsListItems[i].name.toString());
    }
    dropDownValue = items.first.toString().trim();
  }

  Widget build(BuildContext context) {
    // moneynew = "200";
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          // automaticallyImplyLeading: false,
          // bottom: 2,
          bottomOpacity: 2,
          backgroundColor: Utils.whiteColor,
          title: Text(
            "Select Payment Mode",
            style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
          ),
          elevation: 1,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Utils.greyColor,
              // size: 1,
            ),
          )),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MONEY TO BE ADDED",
                      // style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
                      style: Utils.fonts(size: 17.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _loginUserIDController,
                      focusNode: myFocusNodeUserIDLogin,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      // showCursor: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(myFocusNodeUserIDLogin);
                        // myFocusNodeUserIDLogin.requestFocus();
                      },
                      readOnly: false,
                      style: Utils.fonts(size: 25.0, color: Utils.blackColor),
                      decoration: InputDecoration(
                        fillColor: Utils.lightGreenColor.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: Utils.lightGreenColor.withOpacity(0.1),
                          fontSize: 15,
                        ),
                        focusColor: Utils.lightGreenColor.withOpacity(0.1),
                        filled: true,
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Utils.lightGreenColor, width: 2.0),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset('assets/appImages/edit.svg'),
                        ),
                        // labelText: "Mobile No",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Registered Banks",
                      style: Utils.fonts(size: 17.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return BankDetailsController.isLoading.value == true
                          ? Center(
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Loading..",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ))
                          : BankDetailsController.getBankDetailsListItems.isEmpty
                              ? Center(child: Text("No banks available to add funds"))
                              : Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.92,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          value: Dataconstants.dropDownInitialValue,
                                          items: Dataconstants.items.map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  items,
                                                  // style: TextStyle(color: Utils.blackColor, fontWeight: FontWeight.w200, overflow: TextOverflow.fade),
                                                  style: Utils.fonts(
                                                    color: Utils.blackColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              Dataconstants.dropDownInitialValue = newValue;
                                              Dataconstants.bankName = newValue.split("*")[0];
                                              getDetails();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Payment Mode",
                                          style: Utils.fonts(size: 17.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Platform.isAndroid
                                        ? InkWell(
                                            onTap: () async {
                                              setState(() {
                                                upiAppsSelected = true;
                                                upiIdSelected = false;
                                                netbankingSelected = false;
                                              });
                                              setState(() {
                                                moneynew = double.parse(_loginUserIDController.text);
                                                disableProceed = false;
                                              });
                                            },
                                            child: Container(
                                              // height: 100,
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: upiAppsSelected ? Utils.primaryColor : Utils.greyColor),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                        height: MediaQuery.of(context).size.width * 0.045,
                                                        width: MediaQuery.of(context).size.width * 0.045,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(50.0), border: Border.all(), color: upiAppsSelected ? Utils.primaryColor : Utils.whiteColor)),
                                                  ),
                                                  Container(
                                                      child: Image.asset(
                                                    "assets/appImages/upi.png",
                                                  )),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("UPI Apps", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
                                                      SizedBox(
                                                        width: size.width * 0.68,
                                                        child: Text(
                                                          "Pay Using UPI apps like Google Pay,\nPhonePe, PayTM and others",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Column(
                                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                                  //   children: [
                                                  //     Spacer(),
                                                  //     Column(
                                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                                  //       children: [
                                                  //         Text("UPI Apps", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
                                                  //         Text(
                                                  //           "Pay Using UPI apps like Google Pay,\nPhonePe, PayTM and others",
                                                  //         ),
                                                  //       ],
                                                  //     ),
                                                  //     Spacer(),
                                                  //   ],
                                                  // )
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          upiIdSelected = true;
                                          upiAppsSelected = false;
                                          netbankingSelected = false;
                                          upiIdDisplay = true;
                                          disableProceed = false;
                                        });
                                      },
                                      child: Container(
                                        // height: upiIdSelected ? 150 : 100,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: upiIdSelected ? Utils.primaryColor : Utils.greyColor),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 14.0),
                                                  child: Container(
                                                    height: 17,
                                                    width: 17,
                                                    decoration:
                                                        BoxDecoration(borderRadius: BorderRadius.circular(50.0), border: Border.all(), color: upiIdSelected ? Utils.primaryColor : Utils.whiteColor),
                                                  ),
                                                ),
                                                Container(
                                                    child: Image.asset(
                                                  "assets/appImages/upi.png",
                                                  height: 50,
                                                )),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("UPI ID", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
                                                    SizedBox(
                                                      width: size.width * 0.68,
                                                      child: Text(
                                                        "Enter a UPI VPA(Virtual Payment \nAddress) to initiate payment",
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.20,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    upiIdDisplay && upiIdSelected
                                                        ? Container(
                                                            height: 55,
                                                            width: size.width * 0.66,
                                                            // width: 250,
                                                            child: TextField(
                                                              controller: _upiController,
                                                              onChanged: (_) {
                                                                setState(() {
                                                                  upiValidate = 0;
                                                                });
                                                              },
                                                              // textAlignVertical: TextAlignVertical.center,
                                                              decoration: InputDecoration(
                                                                  hintText: 'Enter your UPI ID',
                                                                  hintStyle: TextStyle(),
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    borderSide: BorderSide(
                                                                      color: upiValidate == 1
                                                                          ? Colors.green
                                                                          : upiValidate == 2
                                                                              ? Utils.brightRedColor
                                                                              : Colors.black,
                                                                      width: 1.0,
                                                                    ),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                      color: upiValidate == 1
                                                                          ? Colors.green
                                                                          : upiValidate == 2
                                                                              ? Utils.brightRedColor
                                                                              : Colors.black,
                                                                      width: 2.0,
                                                                    ),
                                                                  )),
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                    SizedBox(height: 5),
                                                    upiIdSelected == true
                                                        ? upiValidate == 1
                                                            ? Column(
                                                                children: [
                                                                  SizedBox(height: 10),
                                                                  Text("Valid UPI ID", style: Utils.fonts(fontWeight: FontWeight.w700, size: 20.0, color: Utils.brightGreenColor)),
                                                                  SizedBox(height: 10)
                                                                ],
                                                              )
                                                            : upiValidate == 2
                                                                ? Column(
                                                                    children: [
                                                                      SizedBox(height: 10),
                                                                      Text("Not a valid UPI ID", style: Utils.fonts(fontWeight: FontWeight.w700, size: 20.0, color: Utils.brightRedColor)),
                                                                      SizedBox(height: 10)
                                                                    ],
                                                                  )
                                                                : SizedBox.shrink()
                                                        : SizedBox.shrink()
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
//np58845@okhdfcbank
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          netbankingSelected = true;
                                          upiAppsSelected = false;
                                          upiIdSelected = false;
                                          disableProceed = false;
                                        });
                                      },
                                      child: Container(
                                        // height: 100,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: netbankingSelected ? Utils.primaryColor : Utils.greyColor),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Container(
                                                  height: MediaQuery.of(context).size.width * 0.045,
                                                  width: MediaQuery.of(context).size.width * 0.045,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(50.0), border: Border.all(), color: netbankingSelected ? Utils.primaryColor : Utils.whiteColor)),
                                            ),
                                            Container(
                                                child: Image.asset(
                                              "assets/appImages/netbanking.png",
                                              height: 50,
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Net banking", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
                                                  SizedBox(
                                                    width: size.width * 0.60,
                                                    child: Text(
                                                      "Use your bank's website to complete payment",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Column(
                                            //   children: [
                                            //     Spacer(),
                                            //     Padding(
                                            //       padding: const EdgeInsets.all(8.0),
                                            //       child: Column(
                                            //         crossAxisAlignment: CrossAxisAlignment.start,
                                            //         children: [
                                            //           Text("Net banking", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
                                            //           Text(
                                            //             "Use your bank's website to complete\npayment",
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     ),
                                            //     Spacer(),
                                            //   ],
                                            // )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                    }),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder<requestResponseState>(
              stream: _streamupiContoller.stream,
              builder: (context, snapshot) {
                if (isUpi == true) {
                  if (snapshot.data == requestResponseState.Loading || snapshot.data == null) {
                    return Loader(msg: 'Loading');
                  } else if (snapshot.data == requestResponseState.DataReceived) {
                    isUpi = false;
                  }
                } else if (isnetbanking == true) {
                  if (snapshot.data == requestResponseState.Loading || snapshot.data == null) {
                    return Loader(msg: 'Loading');
                  } else if (snapshot.data == requestResponseState.DataReceived) {
                    isnetbanking = false;
                  }
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed:
                        disableProceed
                            ? null
                            : () async {
                                if (_loginUserIDController.text.isEmpty) {
                                  CommonFunction.showBasicToastForJm('Please enter an 20');
                                } else if (upiAppsSelected == false && upiIdSelected == false && netbankingSelected == false) {
                                  CommonFunction.showBasicToastForJm('Please select a mode of payment');
                                } else {
                                  if (upiAppsSelected) {
                                    setState(() {
                                      disableProceed = true;
                                    });
                                    // upi = Quantupi(
                                    //   receiverUpiId: 'jmfinancial.rzp@icici',
                                    //   receiverName: 'JM Financial',
                                    //   transactionRefId: '',
                                    //   transactionNote: 'Paying to JM Financials',
                                    //   amount: double.parse(_loginUserIDController.text),
                                    // );
                                    //
                                    // final response = await upi.startTransaction();
                                    // print(response);

                                    var header = {
                                      "upiId": upiIdSelected ? _upiController.text : "",
                                      // "name": BankDetailsController.getBankDetailsListItem s[0].clientName,
                                      "name": Dataconstants.clientName,
                                      "mobileNo": InAppSelection.profileData['mobileno'],
                                      "email": InAppSelection.profileData['email'],
                                      // "bankName": BankDetailsController.getBankDetailsListItems[0].name.split(" ")[0],
                                      "bankName": Dataconstants.dropDownInitialValue.split("*")[0],
                                      "bankAccNo": Dataconstants.accountNo,
                                      "ifsc": Dataconstants.ifsc,
                                      "amount": _loginUserIDController.text,
                                      "mode": "upi",
                                      "ordersource": "MOB",
                                      "token": Dataconstants.fundstoken
                                    };

                                    var stringResponse = await CommonFunction.collectPaymentrequest(header);

                                    var jsonRes = json.decode(stringResponse);

                                    // //print("stringResponse.runtimeType: ${}");

                                    Dataconstants.bankCode = jsonRes["bankCode"];

                                    var jsonResponse = json.decode(stringResponse);

                                    if (jsonResponse == null || jsonResponse == '') {
                                      return;
                                    }

                                    final _datanew = jsonResponse['data'];

                                    Dataconstants.ordernumber = _datanew['id'];

                                    final supportedUpiApps = _razorpay.getAppsWhichSupportUpi();

                                    print(supportedUpiApps);

                                    var options = {
                                      "key": BrokerInfo.mainUrl == BrokerInfo.CUGURL ? BrokerInfo.razorKeyLive : BrokerInfo.razorKeyTest,
                                      "amount": double.parse(_loginUserIDController.text) * 100,
                                      "currency": "INR",
                                      // "email": "gaurav.kumar@example.com",
                                      // "contact": "9009009009",
                                      "method": "upi",
                                      "_[flow]": "intent",
                                      // "upi_app_package_name": "com.google.android.apps.nbu.paisa.user",
                                      "order_id": Dataconstants.ordernumber
                                    };
                                    _razorpay.submit(options);
                                  }
                                  else if (upiIdSelected) {
                                    if (_upiController.text.isEmpty) {
                                      CommonFunction.showBasicToastForJm('Please enter UPI ID');
                                    } else {
                                      upiValidate == 1 ? validateupi() : validateOnlyUpi();
                                    }
                                  } else if (netbankingSelected) {
                                    setState(() {
                                      disableProceed = true;
                                    });
                                    collectPaymentStatus();
                                  }
                                }
                              },
                        child: Text(
                          upiIdSelected
                              ? upiValidate == 1
                                  ? "Proceed"
                                  : "Validate"
                              : "Proceed",
                          style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                        style: ButtonStyle(
                            backgroundColor: disableProceed ? MaterialStateProperty.all<Color>(Utils.primaryColor.withOpacity(0.2)) : MaterialStateProperty.all<Color>(Utils.primaryColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            )))),
                  ),
                );
              })
        ],
      ),
      // bottomNavigationBar: StreamBuilder<requestResponseState>(
      //     stream: _streamupiContoller.stream,
      //     builder: (context, snapshot) {
      //       if (isUpi == true) {
      //         if (snapshot.data == requestResponseState.Loading || snapshot.data == null) {
      //           return Loader(msg: 'Loading');
      //         } else if (snapshot.data == requestResponseState.DataReceived) {
      //           isUpi = false;
      //         }
      //       } else if (isnetbanking == true) {
      //         if (snapshot.data == requestResponseState.Loading || snapshot.data == null) {
      //           return Loader(msg: 'Loading');
      //         } else if (snapshot.data == requestResponseState.DataReceived) {
      //           isnetbanking = false;
      //         }
      //       }
      //       return Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: ElevatedButton(
      //             onPressed: () async {
      //               if (_loginUserIDController.text.isEmpty) {
      //                 CommonFunction.showBasicToastForJm('Please enter an amount');
      //               } else if (upiAppsSelected == false && upiIdSelected == false && netbankingSelected == false) {
      //                 CommonFunction.showBasicToastForJm('Please select a mode of payment');
      //               } else {
      //                 if (upiAppsSelected) {
      //                   upi = Quantupi(
      //                     receiverUpiId: 'merchant737120.augp@aubank',
      //                     receiverName: 'Tester',
      //                     transactionRefId: 'TestingId',
      //                     transactionNote: 'Not actual. Just an example.',
      //                     amount: moneynew,
      //                   );
      //
      //                   final response = await upi.startTransaction();
      //                   //print(response);
      //                 } else if (upiIdSelected) {
      //                   if (_upiController.text.isEmpty) {
      //                     CommonFunction.showBasicToastForJm('Please enter UPI ID');
      //                   } else {
      //                     upiValidate == 1 ? validateupi() : validateOnlyUpi();
      //
      //                   }
      //                 } else if (netbankingSelected) {
      //                   validateupi();
      //                 }
      //               }
      //             },
      //             child: Text(
      //               upiIdSelected
      //                   ? upiValidate == 1
      //                       ? "Proceed"
      //                       : "Validate"
      //                   : "Proceed",
      //               style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
      //             ),
      //             style: ButtonStyle(
      //                 backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
      //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(50.0),
      //                 )))),
      //       );
      //     }),
    );
  }

  Future<String> initiateTransaction({QuantUPIPaymentApps app}) async {
    Quantupi upi = Quantupi(
      receiverUpiId: 'jmfinancial.rzp@icici',
      receiverName: '',
      transactionRefId: Dataconstants.ordernumber,
      transactionNote: 'Paying JM Financial',
      amount: 1.0,
      appname: app,
      merchantId: "DIG6yj29RUxpim",
    );
    String response = await upi.startTransaction();

    return response;
  }

  var isUpi = false;

  validateupi() async {
    setState(() {
      disableProceed = true;
    });
    try {
      var header = {
        "vpa": _upiController.text,
        "application": "mob",
        "token": Dataconstants.fundstoken,
      };

      setState(() {});

      var stringResponse = await CommonFunction.getValidateUPI(header);

      upiValidate = stringResponse.toString().contains("false") ? 2 : 1;

      setState(() {});

      var jsonResponse = jsonDecode(stringResponse);

      if (jsonResponse == null || jsonResponse == '') {
        return;
      }
      final _datanew = jsonResponse['data'] as Map<String, dynamic>;

      var data = Data.fromJson(_datanew);

      datanew = data;

      collectPaymentStatus();

      _streamupiContoller.add(requestResponseState.DataReceived);
    } catch (e) {
      //print(e);
    }
  }

  validateOnlyUpi() async {
    var header = {
      "vpa": _upiController.text,
      "application": "mob",
      "token": Dataconstants.fundstoken,
    };

    setState(() {});
    var stringResponse = await CommonFunction.getValidateUPI(header);

    upiValidate = stringResponse.toString().contains("false") ? 2 : 1;

    setState(() {});
  }

  QuantUPIPaymentApps appoptiontoenum(String appname) {
    switch (appname) {
      case 'Amazon Pay':
        return QuantUPIPaymentApps.amazonpay;
      case 'BHIMUPI':
        return QuantUPIPaymentApps.bhimupi;
      case 'Google Pay':
        return QuantUPIPaymentApps.googlepay;
      case 'Mi Pay':
        return QuantUPIPaymentApps.mipay;
      case 'Mobikwik':
        return QuantUPIPaymentApps.mobikwik;
      case 'Airtel Thanks':
        return QuantUPIPaymentApps.myairtelupi;
      case 'Paytm':
        return QuantUPIPaymentApps.paytm;
      case 'PhonePe':
        return QuantUPIPaymentApps.phonepe;
      case 'SBI PAY':
        return QuantUPIPaymentApps.sbiupi;
      default:
        return QuantUPIPaymentApps.googlepay;
    }
  }

  collectPaymentStatus() async {
    try {
      var header = {
        "upiId": upiIdSelected ? _upiController.text : "",
        // "name": BankDetailsController.getBankDetailsListItem s[0].clientName,
        "name": Dataconstants.clientName,
        "mobileNo": InAppSelection.profileData['mobileno'],
        "email": InAppSelection.profileData['email'],
        // "bankName": BankDetailsController.getBankDetailsListItems[0].name.split(" ")[0],
        "bankName": Dataconstants.dropDownInitialValue.split("*")[0],
        "bankAccNo": Dataconstants.accountNo,
        "ifsc": Dataconstants.ifsc,
        "amount": _loginUserIDController.text,
        "mode": upiIdSelected ? "upi" : "netbanking",
        "ordersource": "MOB",
        "token": Dataconstants.fundstoken
      };

      var stringResponse = await CommonFunction.collectPaymentrequest(header);

      var jsonRes = json.decode(stringResponse);

      // //print("stringResponse.runtimeType: ${}");

      Dataconstants.bankCode = jsonRes["bankCode"];

      var jsonResponse = json.decode(stringResponse);

      if (jsonResponse == null || jsonResponse == '') {
        return;
      }

      final _datanew = jsonResponse['data'];

      Dataconstants.ordernumber = _datanew['id'];

      var rzpkey;
      if (BrokerInfo.mainUrl == BrokerInfo.CUGURL || BrokerInfo.mainUrl == BrokerInfo.AWSURL) {
        rzpkey = BrokerInfo.razorKeyLive;
      } else if (BrokerInfo.mainUrl == BrokerInfo.UATURL) {
        rzpkey = BrokerInfo.razorKeyTest;
      }

      var options = {
        // 'key': 'rzp_live_s3EsaEfnuWiP9X',
        'key': rzpkey,
        'amount': int.parse((double.parse(_loginUserIDController.text) * 100).toStringAsFixed(0)),
        // in the smallest currency sub-unit.
        //'name': Dataconstants.dropDownInitialValue.split("*")[0],
        "bank": Dataconstants.bankCode,
        'order_id': Dataconstants.ordernumber,
        // Generate order_id using Orders API
        // 'description': 'Fine T-Shirt',
        "currency": "INR",
        'vpa': upiIdSelected ? _upiController.text : "",
        'method': upiIdSelected ? "upi" : "netbanking",
        "_[flow]": upiIdSelected ? "collect" : "",
        'contact': InAppSelection.profileData['mobileno'],
        'email': InAppSelection.profileData['email'],
        // in seconds
      };
      _razorpay.submit(options);

      //print("option --- $options");
    } catch (e) {
      //print(e);
    }
  }
}
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// // import 'package:flutter_appavailability/flutter_appavailability.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:markets/jmScreens/addFunds/FundSuccess.dart';
// import 'package:markets/util/BrokerInfo.dart';
//
// import '../../controllers/BankDetailsController.dart';
// import '../../model/jmModel/bankDetails.dart';
// import '../../model/jmModel/validateupi.dart';
// import '../../style/theme.dart';
// import '../../util/CommonFunctions.dart';
// import '../../util/Dataconstants.dart';
// import '../../util/InAppSelections.dart';
// import '../../util/Utils.dart';
//
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:razorpay_flutter_customui/razorpay_flutter_customui.dart';
// import 'package:quantupi/quantupi.dart';
// import '../../widget/loader.dart';
// import '../profile/LimitScreen.dart';
// import 'AddMoney.dart';
//
// class AddFunds extends StatefulWidget {
//   @override
//   State<AddFunds> createState() => _AddFundsState();
// }
//
// @override
// class _AddFundsState extends State<AddFunds> {
//   var isBorder = false;
//   var selectUPI;
//
//   var selectedBank = -1;
//   var selectedbankname = '';
//   var selectedbankaccno;
//   var selectedifsccode;
//   var upiSelected = false;
//   var netbanking = false;
//   var isnetbanking = false;
//   var formatter = NumberFormat('#,##,###');
//   var upibank = false;
//   var showBottomSheet = false;
//   String dropDownValue;
//   var upiAppsSelected = false;
//   var upiIdSelected = false;
//   var netbankingSelected = false;
//   var googlePay = false;
//   var datanew;
//   var items = [];
//   bool upiIdDisplay = false;
//   var netbankupi = false;
//   var _apps;
//   var paytmSelected = false;
//   var bhim = false;
//   var phonePe = false;
//   var upiValidate = 0;
//   var ifscNumber;
//   bool disableProceed = false;
//
//   Quantupi upi;
//   var _razorpay;
//   TextEditingController _loginUserIDController = TextEditingController();
//   TextEditingController _upiController = TextEditingController();
//   final FocusNode myFocusNodeUserIDLogin = FocusNode();
//   final FocusNode myFocusNodePaymentPurposeLogin = FocusNode();
//   final StreamController<requestResponseState> _streamupiContoller = StreamController.broadcast();
//   double moneynew = 0.0;
//   List bankdetails = List();
//   var _installedApps;
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
//
//   bottomSheets(type, errorTitle, amount, description) {
//     return showModalBottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       context: context,
//       builder: (context) {
//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: 2,
//                 width: 40,
//                 color: Utils.greyColor.withOpacity(0.4),
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             SvgPicture.asset(type == "error" ? "assets/appImages/fundsFailed.svg" : "assets/appImages/successFund.svg"),
//             SizedBox(
//               height: 30,
//             ),
//             Text(
//               errorTitle,
//               style: Utils.fonts(
//                 size: 20.0,
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               amount,
//               style: Utils.fonts(
//                 size: 17.0,
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: Text(
//                 description,
//                 style: Utils.fonts(size: 13.0, color: Utils.greyColor.withOpacity(0.5)),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Expanded(
//               child: Align(
//                 alignment: FractionalOffset.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                           onPressed: () {
//                             // Navigator.of(context).push(MaterialPageRoute(
//                             //     builder: (context) => SimplifiedLogin()));
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//                             child: Text(
//                               type == "error" ? "Retry" : "Take me to Home",
//                               style: Utils.fonts(size: 14.0, color: Utils.greyColor, fontWeight: FontWeight.w400),
//                             ),
//                           ),
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                               shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0), side: BorderSide(color: Utils.greyColor))))),
//                       ElevatedButton(
//                           onPressed: () {
//                             // Navigator.push(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (context) => AddFunds()));
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//                             child: Text(
//                               type == "error" ? "Fund Details" : "Got it",
//                               style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
//                             ),
//                           ),
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
//                               shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(50.0),
//                               ))))
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//       backgroundColor: Utils.whiteColor,
//     );
//   }
//
//   void _handlePaymentSuccess(Map<dynamic, dynamic> response) async {
//     // //print("$response");
//     setState(() {
//       disableProceed = false;
//     });
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FundSuccess(_loginUserIDController.text, response['data']['razorpay_payment_id'])));
//     Dataconstants.limitController.getLimitsData();
//     try {
//       var data = {
//         'payment_id': '${response['data']['razorpay_payment_id']}',
//         'order_id': '${response['data']['razorpay_order_id']}',
//         'signature': '${response['data']['razorpay_signature']}',
//       };
//
//       var json = {
//         "Payment_status": "Success", // pass Success or Failed based on handler
//         "Order_Id": response['data']['razorpay_order_id'], // Order Id created in Collect request
//         "Respjsonstring": '$data', // Response received after txn
//       };
//       //print('success payload----$json');
//       var stringResponse = await CommonFunction.sendPaymentResponse(json);
//
//       var jsonResponse = jsonDecode(stringResponse);
//     } catch (e) {
//       //print(e);
//     }
//
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FundSuccess(_loginUserIDController.text, response['data']['razorpay_payment_id'])));
//
//     // Do something when payment succeeds
//   }
//
//   void _handlePaymentError(Map<dynamic, dynamic> response) async {
//     print(response);
//     setState(() {
//       disableProceed = false;
//     });
//     try {
//       // //print("rs: ${response.message.toString()}");
//       //   // var jsonResponse = jsonDecode(stringResponse);
//       //   //
//       //   // if(jsonResponse == null || jsonResponse == ''){
//       //   //   return;
//       //   // } else {
//       //   //   //print("_handlePaymentSuccess -- $jsonResponse");
//       //   // }
//       //print(response);
//       showModalBottomSheet(
//           isScrollControlled: true,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
//           context: context,
//           builder: (context) {
//             return DraggableScrollableSheet(
//                 expand: false,
//                 minChildSize: 0.3,
//                 initialChildSize: 0.4,
//                 maxChildSize: 0.45,
//                 builder: (context, scrollController) {
//                   return Column(
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       SvgPicture.asset("assets/appImages/failedFunds.svg"),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Funds addition failed",
//                         style: Utils.fonts(fontWeight: FontWeight.w700, size: 26.0),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Rs ${_loginUserIDController.text}",
//                         style: Utils.fonts(fontWeight: FontWeight.w600, size: 20.0),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Is Your money debited from your account? Don't worry!",
//                         style: Utils.fonts(color: Utils.greyColor),
//                       ),
//                       Text(
//                         "Your money will be credited back in 48 hrs",
//                         style: Utils.fonts(color: Utils.greyColor),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//                               height: MediaQuery.of(context).size.height * 0.05,
//                               width: MediaQuery.of(context).size.width * 0.3,
//                               decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), border: Border.all()),
//                               child: Center(child: Text("Retry")),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => LimitScreen()));
//                             },
//                             child: Container(
//                               height: MediaQuery.of(context).size.height * 0.05,
//                               width: MediaQuery.of(context).size.width * 0.3,
//                               decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Utils.primaryColor, border: Border.all()),
//                               child: Center(
//                                 child: Text(
//                                   "Fund Details",
//                                   style: TextStyle(color: Utils.whiteColor, fontWeight: FontWeight.w700),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   );
//                 });
//           });
//     } catch (e, s) {
//       //print(e);
//     }
//     // Do something when payment fails
//
//     //print(response);
//   }
//
//   getDetails() {
//     for (var i = 0; i < BankDetailsController.getBankDetailsListItems.length; i++) {
//       if (BankDetailsController.getBankDetailsListItems[i].id.toString().split("|")[0] == Dataconstants.dropDownInitialValue) {
//         setState(() {
//           Dataconstants.ifsc = BankDetailsController.getBankDetailsListItems[i].ifsc;
//           Dataconstants.bankName = BankDetailsController.getBankDetailsListItems[i].name;
//           Dataconstants.accountNo = BankDetailsController.getBankDetailsListItems[i].accountNo;
//           Dataconstants.clientName = BankDetailsController.getBankDetailsListItems[i].clientName;
//         });
//       }
//     }
//   }
//
//   @override
//   Future<void> initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     _razorpay.initilizeSDK('rzp_live_s3EsaEfnuWiP9X');
//     bankdetails = bankDetails;
//   }
//
//   addDirectMoney(value) {
//     if (_loginUserIDController.text.isNotEmpty) {
//       var actualValue = int.parse(_loginUserIDController.text.replaceAll(",", ""));
//       var finalValue = actualValue + value;
//       setState(() {
//         _loginUserIDController.text = formatter.format(finalValue);
//       });
//     } else {
//       setState(() {
//         _loginUserIDController.text = formatter.format(value);
//       });
//     }
//   }
//
//   @override
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   getPaymentAccessToken() async {
//     var header = {"application": "Intellect"};
//
//     var stringResponse = await CommonFunction.getPaymentAccessToken(header);
//
//     var jsonResponse = jsonDecode(stringResponse);
//
//     //print("Get access token: ${jsonResponse}");
//
//     Dataconstants.fundstoken = await jsonResponse['data'];
//
//     // getBankdetails();
//
//     Dataconstants.bankDetailsController.getBankDetails();
//
//     //print(Dataconstants.fundstoken);
//
//     // getBankdetails();
//
//     return Dataconstants.fundstoken;
//   }
//
//   getItems() async {
//     items.clear();
//
//     for (var i = 0; i < BankDetailsController.getBankDetailsListItems.length; i++) {
//       items.add(BankDetailsController.getBankDetailsListItems[i].name.toString());
//     }
//     dropDownValue = items.first.toString().trim();
//   }
//
//   Widget build(BuildContext context) {
//     // moneynew = "200";
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         // automaticallyImplyLeading: false,
//         // bottom: 2,
//           bottomOpacity: 2,
//           backgroundColor: Utils.whiteColor,
//           title: Text(
//             "Select Payment Mode",
//             style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
//           ),
//           elevation: 1,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(
//               Icons.arrow_back,
//               color: Utils.greyColor,
//               // size: 1,
//             ),
//           )),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "MONEY TO BE ADDED",
//                       // style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
//                       style: Utils.fonts(size: 17.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextField(
//                       controller: _loginUserIDController,
//                       focusNode: myFocusNodeUserIDLogin,
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.numberWithOptions(),
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
//                       ],
//                       // showCursor: true,
//                       onTap: () {
//                         FocusScope.of(context).requestFocus(myFocusNodeUserIDLogin);
//                         // myFocusNodeUserIDLogin.requestFocus();
//                       },
//                       readOnly: false,
//                       style: Utils.fonts(size: 25.0, color: Utils.blackColor),
//                       decoration: InputDecoration(
//                         fillColor: Utils.lightGreenColor.withOpacity(0.1),
//                         labelStyle: TextStyle(
//                           color: Utils.lightGreenColor.withOpacity(0.1),
//                           fontSize: 15,
//                         ),
//                         focusColor: Utils.lightGreenColor.withOpacity(0.1),
//                         filled: true,
//                         enabledBorder: UnderlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Utils.lightGreenColor, width: 2.0),
//                         ),
//                         suffixIcon: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: SvgPicture.asset('assets/appImages/edit.svg'),
//                         ),
//                         // labelText: "Mobile No",
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       "Registered Banks",
//                       style: Utils.fonts(size: 17.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Obx(() {
//                       return BankDetailsController.isLoading.value == true
//                           ? Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("Loading..",
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.bold,
//                                   )),
//                             ],
//                           ))
//                           : BankDetailsController.getBankDetailsListItems.isEmpty
//                           ? Center(child: Text("No banks available to add funds"))
//                           : Column(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.92,
//                             decoration: BoxDecoration(
//                               border: Border.all(),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton(
//                                 isExpanded: true,
//                                 value: Dataconstants.dropDownInitialValue,
//                                 items: Dataconstants.items.map((items) {
//                                   return DropdownMenuItem(
//                                     value: items,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         items,
//                                         // style: TextStyle(color: Utils.blackColor, fontWeight: FontWeight.w200, overflow: TextOverflow.fade),
//                                         style: Utils.fonts(
//                                           color: Utils.blackColor,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                         textAlign: TextAlign.justify,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     Dataconstants.dropDownInitialValue = newValue;
//                                     Dataconstants.bankName = newValue.split("*")[0];
//                                     getDetails();
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "Payment Mode",
//                                 style: Utils.fonts(size: 17.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               setState(() {
//                                 upiAppsSelected = true;
//                                 upiIdSelected = false;
//                                 netbankingSelected = false;
//                               });
//                               setState(() {
//                                 moneynew = double.parse(_loginUserIDController.text);
//                                 disableProceed = false;
//                               });
//                             },
//                             child: Container(
//                               // height: 100,
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: upiAppsSelected ? Utils.primaryColor : Utils.greyColor),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Container(
//                                         height: MediaQuery.of(context).size.width * 0.045,
//                                         width: MediaQuery.of(context).size.width * 0.045,
//                                         decoration:
//                                         BoxDecoration(borderRadius: BorderRadius.circular(50.0), border: Border.all(), color: upiAppsSelected ? Utils.primaryColor : Utils.whiteColor)),
//                                   ),
//                                   Container(
//                                       child: Image.asset(
//                                         "assets/appImages/upi.png",
//                                       )),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("UPI Apps", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
//                                       SizedBox(
//                                         width: size.width * 0.68,
//                                         child: Text(
//                                           "Pay Using UPI apps like Google Pay,\nPhonePe, PayTM and others",
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   // Column(
//                                   //   crossAxisAlignment: CrossAxisAlignment.start,
//                                   //   children: [
//                                   //     Spacer(),
//                                   //     Column(
//                                   //       crossAxisAlignment: CrossAxisAlignment.start,
//                                   //       children: [
//                                   //         Text("UPI Apps", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
//                                   //         Text(
//                                   //           "Pay Using UPI apps like Google Pay,\nPhonePe, PayTM and others",
//                                   //         ),
//                                   //       ],
//                                   //     ),
//                                   //     Spacer(),
//                                   //   ],
//                                   // )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 upiIdSelected = true;
//                                 upiAppsSelected = false;
//                                 netbankingSelected = false;
//                                 upiIdDisplay = true;
//                                 disableProceed = false;
//                               });
//                             },
//                             child: Container(
//                               // height: upiIdSelected ? 150 : 100,
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: upiIdSelected ? Utils.primaryColor : Utils.greyColor),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 14.0),
//                                         child: Container(
//                                           height: 17,
//                                           width: 17,
//                                           decoration:
//                                           BoxDecoration(borderRadius: BorderRadius.circular(50.0), border: Border.all(), color: upiIdSelected ? Utils.primaryColor : Utils.whiteColor),
//                                         ),
//                                       ),
//                                       Container(
//                                           child: Image.asset(
//                                             "assets/appImages/upi.png",
//                                             height: 50,
//                                           )),
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text("UPI ID", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
//                                           SizedBox(
//                                             width: size.width * 0.68,
//                                             child: Text(
//                                               "Enter a UPI VPA(Virtual Payment \nAddress) to initiate payment",
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       SizedBox(
//                                         width: MediaQuery.of(context).size.width * 0.20,
//                                       ),
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           upiIdDisplay && upiIdSelected
//                                               ? Container(
//                                             height: 55,
//                                             width: size.width * 0.66,
//                                             // width: 250,
//                                             child: TextField(
//                                               controller: _upiController,
//                                               onChanged: (_) {
//                                                 setState(() {
//                                                   upiValidate = 0;
//                                                 });
//                                               },
//                                               // textAlignVertical: TextAlignVertical.center,
//                                               decoration: InputDecoration(
//                                                   hintText: 'Enter your UPI ID',
//                                                   hintStyle: TextStyle(),
//                                                   enabledBorder: OutlineInputBorder(
//                                                     borderRadius: BorderRadius.circular(5),
//                                                     borderSide: BorderSide(
//                                                       color: upiValidate == 1
//                                                           ? Colors.green
//                                                           : upiValidate == 2
//                                                           ? Utils.brightRedColor
//                                                           : Colors.black,
//                                                       width: 1.0,
//                                                     ),
//                                                   ),
//                                                   focusedBorder: OutlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                       color: upiValidate == 1
//                                                           ? Colors.green
//                                                           : upiValidate == 2
//                                                           ? Utils.brightRedColor
//                                                           : Colors.black,
//                                                       width: 2.0,
//                                                     ),
//                                                   )),
//                                             ),
//                                           )
//                                               : SizedBox.shrink(),
//                                           SizedBox(height: 5),
//                                           upiIdSelected == true
//                                               ? upiValidate == 1
//                                               ? Column(
//                                             children: [
//                                               SizedBox(height: 10),
//                                               Text("Valid UPI ID", style: Utils.fonts(fontWeight: FontWeight.w700, size: 20.0, color: Utils.brightGreenColor)),
//                                               SizedBox(height: 10)
//                                             ],
//                                           )
//                                               : upiValidate == 2
//                                               ? Column(
//                                             children: [
//                                               SizedBox(height: 10),
//                                               Text("Not a valid UPI ID", style: Utils.fonts(fontWeight: FontWeight.w700, size: 20.0, color: Utils.brightRedColor)),
//                                               SizedBox(height: 10)
//                                             ],
//                                           )
//                                               : SizedBox.shrink()
//                                               : SizedBox.shrink()
//                                         ],
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
// //np58845@okhdfcbank
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 netbankingSelected = true;
//                                 upiAppsSelected = false;
//                                 upiIdSelected = false;
//                                 disableProceed = false;
//                               });
//                             },
//                             child: Container(
//                               // height: 100,
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: netbankingSelected ? Utils.primaryColor : Utils.greyColor),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(10),
//                                     child: Container(
//                                         height: MediaQuery.of(context).size.width * 0.045,
//                                         width: MediaQuery.of(context).size.width * 0.045,
//                                         decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(50.0), border: Border.all(), color: netbankingSelected ? Utils.primaryColor : Utils.whiteColor)),
//                                   ),
//                                   Container(
//                                       child: Image.asset(
//                                         "assets/appImages/netbanking.png",
//                                         height: 50,
//                                       )),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 8.0),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text("Net banking", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
//                                         SizedBox(
//                                           width: size.width * 0.60,
//                                           child: Text(
//                                             "Use your bank's website to complete payment",
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // Column(
//                                   //   children: [
//                                   //     Spacer(),
//                                   //     Padding(
//                                   //       padding: const EdgeInsets.all(8.0),
//                                   //       child: Column(
//                                   //         crossAxisAlignment: CrossAxisAlignment.start,
//                                   //         children: [
//                                   //           Text("Net banking", style: Utils.fonts(fontWeight: FontWeight.w700), textAlign: TextAlign.left),
//                                   //           Text(
//                                   //             "Use your bank's website to complete\npayment",
//                                   //           ),
//                                   //         ],
//                                   //       ),
//                                   //     ),
//                                   //     Spacer(),
//                                   //   ],
//                                   // )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           StreamBuilder<requestResponseState>(
//               stream: _streamupiContoller.stream,
//               builder: (context, snapshot) {
//                 if (isUpi == true) {
//                   if (snapshot.data == requestResponseState.Loading || snapshot.data == null) {
//                     return Loader(msg: 'Loading');
//                   } else if (snapshot.data == requestResponseState.DataReceived) {
//                     isUpi = false;
//                   }
//                 } else if (isnetbanking == true) {
//                   if (snapshot.data == requestResponseState.Loading || snapshot.data == null) {
//                     return Loader(msg: 'Loading');
//                   } else if (snapshot.data == requestResponseState.DataReceived) {
//                     isnetbanking = false;
//                   }
//                 }
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: ElevatedButton(
//                         onPressed: disableProceed
//                             ? null
//                             : () async {
//                           if (_loginUserIDController.text.isEmpty) {
//                             CommonFunction.showBasicToastForJm('Please enter an amount');
//                           } else if (upiAppsSelected == false && upiIdSelected == false && netbankingSelected == false) {
//                             CommonFunction.showBasicToastForJm('Please select a mode of payment');
//                           } else {
//                             if (upiAppsSelected) {
//                               setState(() {
//                                 disableProceed = false;
//                               });
//                               // upi = Quantupi(
//                               //   receiverUpiId: 'jmfinancial.rzp@icici',
//                               //   receiverName: '',
//                               //   transactionRefId:  Dataconstants.ordernumber,
//                               //   transactionNote: 'Paying JM Financial',
//                               //   amount: double.parse(_loginUserIDController.text),
//                               // );
//                               //
//                               // final response = await upi.startTransaction();
//
//                               final supportedUpiApps = _razorpay.getAppsWhichSupportUpi();
//
//                               var options = {
//                                 // 'key': 'rzp_live_s3EsaEfnuWiP9X',
//                                 'key': "rzp_live_s3EsaEfnuWiP9X",
//                                 'amount': int.parse((double.parse(_loginUserIDController.text) * 100).toStringAsFixed(0)),
//                                 // in the smallest currency sub-unit.
//                                 //'name': Dataconstants.dropDownInitialValue.split("*")[0],
//                                 // "bank": Dataconstants.bankCode,
//                                 'order_id': Dataconstants.ordernumber,
//                                 // Generate order_id using Orders API
//                                 // 'description': 'Fine T-Shirt',
//                                 "currency": "INR",
//                                 "_[flow]": "intent",
//                                 'contact': InAppSelection.profileData['mobileno'],
//                                 'email': InAppSelection.profileData['email'],
//                                 // in seconds
//                               };
//
//                               _razorpay.submit(options);
//                               //print(response);
//                             } else if (upiIdSelected) {
//                               if (_upiController.text.isEmpty) {
//                                 CommonFunction.showBasicToastForJm('Please enter UPI ID');
//                               } else {
//                                 upiValidate == 1 ? validateupi() : validateOnlyUpi();
//                               }
//                             } else if (netbankingSelected) {
//                               collectPaymentStatus();
//                             }
//                           }
//                         },
//                         child: Text(
//                           upiIdSelected
//                               ? upiValidate == 1
//                               ? "Proceed"
//                               : "Validate"
//                               : "Proceed",
//                           style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
//                         ),
//                         style: ButtonStyle(
//                             backgroundColor: disableProceed ? MaterialStateProperty.all<Color>(Utils.primaryColor.withOpacity(0.2)) : MaterialStateProperty.all<Color>(Utils.primaryColor),
//                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50.0),
//                             )))),
//                   ),
//                 );
//               })
//         ],
//       ),
//       // bottomNavigationBar: StreamBuilder<requestResponseState>(
//       //     stream: _streamupiContoller.stream,
//       //     builder: (context, snapshot) {
//       //       if (isUpi == true) {
//       //         if (snapshot.data == requestResponseState.Loading || snapshot.data == null) {
//       //           return Loader(msg: 'Loading');
//       //         } else if (snapshot.data == requestResponseState.DataReceived) {
//       //           isUpi = false;
//       //         }
//       //       } else if (isnetbanking == true) {
//       //         if (snapshot.data == requestResponseState.Loading || snapshot.data == null) {
//       //           return Loader(msg: 'Loading');
//       //         } else if (snapshot.data == requestResponseState.DataReceived) {
//       //           isnetbanking = false;
//       //         }
//       //       }
//       //       return Padding(
//       //         padding: const EdgeInsets.all(8.0),
//       //         child: ElevatedButton(
//       //             onPressed: () async {
//       //               if (_loginUserIDController.text.isEmpty) {
//       //                 CommonFunction.showBasicToastForJm('Please enter an amount');
//       //               } else if (upiAppsSelected == false && upiIdSelected == false && netbankingSelected == false) {
//       //                 CommonFunction.showBasicToastForJm('Please select a mode of payment');
//       //               } else {
//       //                 if (upiAppsSelected) {
//       //                   upi = Quantupi(
//       //                     receiverUpiId: 'merchant737120.augp@aubank',
//       //                     receiverName: 'Tester',
//       //                     transactionRefId: 'TestingId',
//       //                     transactionNote: 'Not actual. Just an example.',
//       //                     amount: moneynew,
//       //                   );
//       //
//       //                   final response = await upi.startTransaction();
//       //                   //print(response);
//       //                 } else if (upiIdSelected) {
//       //                   if (_upiController.text.isEmpty) {
//       //                     CommonFunction.showBasicToastForJm('Please enter UPI ID');
//       //                   } else {
//       //                     upiValidate == 1 ? validateupi() : validateOnlyUpi();
//       //
//       //                   }
//       //                 } else if (netbankingSelected) {
//       //                   validateupi();
//       //                 }
//       //               }
//       //             },
//       //             child: Text(
//       //               upiIdSelected
//       //                   ? upiValidate == 1
//       //                       ? "Proceed"
//       //                       : "Validate"
//       //                   : "Proceed",
//       //               style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
//       //             ),
//       //             style: ButtonStyle(
//       //                 backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
//       //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
//       //                   borderRadius: BorderRadius.circular(50.0),
//       //                 )))),
//       //       );
//       //     }),
//     );
//   }
//
//   Future<String> initiateTransaction({QuantUPIPaymentApps app}) async {
//     Quantupi upi = Quantupi(
//       receiverUpiId: 'jmfinancial.rzp@icici',
//       receiverName: '',
//       transactionRefId: Dataconstants.ordernumber,
//       transactionNote: 'Paying JM Financial',
//       amount: 1.0,
//       appname: app,
//       merchantId: "DIG6yj29RUxpim",
//     );
//     String response = await upi.startTransaction();
//
//     return response;
//   }
//
//   var isUpi = false;
//
//   validateupi() async {
//     setState(() {
//       disableProceed = true;
//     });
//     try {
//       var header = {
//         "vpa": _upiController.text,
//         "application": "mob",
//         "token": Dataconstants.fundstoken,
//       };
//
//       setState(() {});
//
//       var stringResponse = await CommonFunction.getValidateUPI(header);
//
//       upiValidate = stringResponse.toString().contains("false") ? 2 : 1;
//
//       setState(() {});
//
//       var jsonResponse = jsonDecode(stringResponse);
//
//       if (jsonResponse == null || jsonResponse == '') {
//         return;
//       }
//       final _datanew = jsonResponse['data'] as Map<String, dynamic>;
//
//       var data = Data.fromJson(_datanew);
//
//       datanew = data;
//
//       collectPaymentStatus();
//
//       _streamupiContoller.add(requestResponseState.DataReceived);
//     } catch (e) {
//       //print(e);
//     }
//   }
//
//   validateOnlyUpi() async {
//     var header = {
//       "vpa": _upiController.text,
//       "application": "mob",
//       "token": Dataconstants.fundstoken,
//     };
//
//     setState(() {});
//     var stringResponse = await CommonFunction.getValidateUPI(header);
//
//     upiValidate = stringResponse.toString().contains("false") ? 2 : 1;
//
//     setState(() {});
//   }
//
//   collectPaymentStatus() async {
//     try {
//
//
//       if(upiIdSelected){
//         var header = {
//           "upiId": upiIdSelected ? _upiController.text : "",
//           // "name": BankDetailsController.getBankDetailsListItem s[0].clientName,
//           "name": Dataconstants.clientName,
//           "mobileNo": InAppSelection.profileData['mobileno'],
//           "email": InAppSelection.profileData['email'],
//           // "bankName": BankDetailsController.getBankDetailsListItems[0].name.split(" ")[0],
//           "bankName": Dataconstants.dropDownInitialValue.split("*")[0],
//           "bankAccNo": Dataconstants.accountNo,
//           "ifsc": Dataconstants.ifsc,
//           "amount": _loginUserIDController.text,
//           "mode": upiIdSelected ? "upi" : "netbanking",
//           "ordersource": "MOB",
//           "token": Dataconstants.fundstoken
//         };
//
//         var stringResponse = await CommonFunction.collectPaymentrequest(header);
//
//         var jsonRes = json.decode(stringResponse);
//
//         Dataconstants.bankCode = jsonRes["bankCode"];
//
//         var jsonResponse = json.decode(stringResponse);
//
//         if (jsonResponse == null || jsonResponse == '') {
//           return;
//         }
//
//         final _datanew = jsonResponse['data'];
//
//         Dataconstants.ordernumber = _datanew['id'];
//       } else {
//
//         var header = {
//           "upiId": upiIdSelected ? _upiController.text : "",
//           // "name": BankDetailsController.getBankDetailsListItem s[0].clientName,
//           "name": Dataconstants.clientName,
//           "mobileNo": InAppSelection.profileData['mobileno'],
//           "email": InAppSelection.profileData['email'],
//           // "bankName": BankDetailsController.getBankDetailsListItems[0].name.split(" ")[0],
//           "bankName": Dataconstants.dropDownInitialValue.split("*")[0],
//           "bankAccNo": Dataconstants.accountNo,
//           "ifsc": Dataconstants.ifsc,
//           "amount": _loginUserIDController.text,
//           "mode": upiIdSelected ? "upi" : "netbanking",
//           "ordersource": "MOB",
//           "token": Dataconstants.fundstoken
//         };
//
//         var stringResponse = await CommonFunction.collectPaymentrequest(header);
//
//         var jsonRes = json.decode(stringResponse);
//
//         Dataconstants.bankCode = jsonRes["bankCode"];
//
//         var jsonResponse = json.decode(stringResponse);
//
//         if (jsonResponse == null || jsonResponse == '') {
//           return;
//         }
//
//         final _datanew = jsonResponse['data'];
//
//         Dataconstants.ordernumber = _datanew['id'];
//
//         var rzpkey;
//
//         if (BrokerInfo.mainUrl == BrokerInfo.CUGURL) {
//           rzpkey = BrokerInfo.razorKeyLive;
//         } else if (BrokerInfo.mainUrl == BrokerInfo.UATURL) {
//           rzpkey = BrokerInfo.razorKeyTest;
//         }
//
//         var options = {
//           // 'key': 'rzp_live_s3EsaEfnuWiP9X',
//           'key': rzpkey,
//           'amount': int.parse((double.parse(_loginUserIDController.text) * 100).toStringAsFixed(0)),
//           // in the smallest currency sub-unit.
//           //'name': Dataconstants.dropDownInitialValue.split("*")[0],
//           "bank": Dataconstants.bankCode,
//           'order_id': Dataconstants.ordernumber,
//           // Generate order_id using Orders API
//           // 'description': 'Fine T-Shirt',
//           "currency": "INR",
//           'vpa': upiIdSelected ? _upiController.text : "",
//           'method': upiIdSelected ? "upi" : "netbanking",
//           "_[flow]": upiIdSelected ? "collect" : "",
//           'contact': InAppSelection.profileData['mobileno'],
//           'email': InAppSelection.profileData['email'],
//           // in seconds
//         };
//         _razorpay.submit(options);
//       }
//
//       //print("option --- $options");
//     } catch (e) {
//       //print(e);
//     }
//   }
// }
