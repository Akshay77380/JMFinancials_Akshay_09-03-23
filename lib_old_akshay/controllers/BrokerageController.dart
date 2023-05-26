// import 'dart:convert';
//
// import 'package:get/get.dart';
// import '../Connection/ISecITS/ITSClient.dart';
// import '../model/jmModel/Brokerage.dart';
// import '../model/jmModel/BseAdvance.dart';
// import '../util/Dataconstants.dart';
// import 'package:http/http.dart' as http;
//
// class BrokerageController extends GetxController {
//   static var brokerage = Brokerage().obs;
//   static var isLoading = true.obs;
//   static List<Datum> getBlockDealsListItems = <Datum>[].obs;
//   static var jsonVarUsables;
//
//   @override
//   void onInit() {
//     // getBlockDeals();
//     super.onInit();
//   }
//
//   Future<void> getBrokerage(trtype, exchange, segment, symbol, strikePrice, product, quantity, price, orderValue) async {
//     var brokerageVariable;
//
//     // brokerageVariable = await ITSClient.httpGetWithHeader(
//     //     'https://tradeapiuat.jmfonline.in:9190/Brokerage/GetClientBrokerage',
//     //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjEwMTE2MjQxIiwiTWlkZGxlV2FyZV9NYXBwaW5nIjoiMTAiLCJNaWRkbGVXYXJlX0pzb25EYXRhIjoi'
//     // );
//
//     var requestJson = {
//       "TransactionType": trtype,
//       "Exchange": exchange,
//       "Segment": segment,
//       "Instrument": "NA",
//       "Symbol": symbol,
//       "ExpiryDate": "NA",
//       "Optiontype": "NA",
//       "StrikePrice": strikePrice.toStringAsFixed(2),
//       "Product": product,
//       "ISIN": "NA",
//       "BSESymbol": "NA",
//       "Series": "EQ",
//       "Quantity": quantity,
//       "Price": price,
//       "OrderValue": orderValue.toStringAsFixed(2)
//     };
//
//     isLoading(true);
//     brokerageVariable = await Dataconstants.itsClient.httpPostWithHeaderNew("https://tradeapiuat.jmfonline.in:9190/Brokerage/GetClientBrokerage", requestJson, Dataconstants.jwtTokenThroughoutApp);
//
//     print(brokerageVariable.body.toString());
//
//     var jsonVar = jsonDecode(brokerageVariable.body.toString());
//
//     jsonVarUsables = jsonDecode(brokerageVariable.body.toString());
//
//     print("This is the target : ${jsonVarUsables["data"]["Brokerage"]}");
//     try {
//       brokerage.value = brokerageFromJson(brokerageVariable.body.toString());
//       getBlockDealsListItems.clear();
//
//       // print(brokerage.value.data.length);
//     } catch (e, s) {
//       print(e);
//     } finally {
//       isLoading(false);
//     }
//     return;
//   }
// }

import 'dart:convert';

import 'package:get/get.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../model/jmModel/Brokerage.dart';
import '../util/BrokerInfo.dart';
import '../util/Dataconstants.dart';

class BrokerageController extends GetxController{
  static var brokerage = Brokerage().obs;
  static List<Data> getBrokerageListItems = <Data>[].obs;
  var jsonVarUsables;
  static var isLoading = true.obs;
  static var brokerageVal;
  static var transCharge;
  static var secCharge;
  static var sebiTax;
  static var stampduty;
  static var gst;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getBrokerage (
      series,
      trtype,
      exchange,
      segment,
      symbol,
      strikePrice,
      product,
      expiry,
      optionType,
      quantity,
      price,
      orderValue
      ) async {

    isLoading(true);

    var requestJson = {
      "TransactionType": trtype.toString(),
      "Exchange": exchange.toString(),
      "Segment": segment.toString(),
      "Instrument": "NA",
      "Symbol": symbol.toString(),
      "ExpiryDate": expiry,
      "Optiontype": "NA",
      "StrikePrice": strikePrice.toStringAsFixed(2),
      "Product": product.toString(),
      "ISIN": "NA",
      "BSESymbol": "NA",
      "Series": series,
      "Quantity": quantity.toString(),
      "Price": price.toString(),
      "OrderValue": "${(double.parse(quantity.toString()) * double.parse(price.toString()))}"
    };
    print(requestJson);
    try {
    var brokerageVariable;
    brokerageVariable =
    await Dataconstants.itsClient.httpPostWithHeader(
        "${BrokerInfo.mainUrl}Brokerage/GetClientBrokerage",
        requestJson,
        Dataconstants.loginData.data.jwtToken
    );



      brokerageVal = null;
      transCharge = null;
      secCharge = null;
      sebiTax = null;
      stampduty = null;
      gst = null;
      brokerage.value = brokerageFromJson(brokerageVariable.body.toString());

      jsonVarUsables = jsonDecode(brokerageVariable.body.toString());

      print("This is the target : ${jsonVarUsables["data"]["Brokerage"]}");

      brokerageVal = jsonVarUsables["data"]["Brokerage"];
      transCharge = jsonVarUsables["data"]["Trans_Charge"];
      secCharge = jsonVarUsables["data"]["STT_CTT"];
      sebiTax = jsonVarUsables["data"]["SEBI_Fees"];
      stampduty = jsonVarUsables["data"]["Stamp_Duty"];
      gst = jsonVarUsables["data"]["GST"];

    } catch (e, s) {
      print(e);
    } finally {
      isLoading(false);
    }
    return;
  }

}
