import 'dart:convert';

import 'package:get/get.dart';
import 'package:markets/model/custom_processed.dart';
import 'package:markets/model/jmModel/fundtransactionmodel.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../jmScreens/ScriptInfo/bar_chart.dart';
import '../util/Dataconstants.dart';

class FundTransactionControlller extends GetxController {
  static var isLoading = true.obs;
  static var fundTransactionModel = FundTransactionModel().obs;
  static List<Detail> getFundTransactionListItems = <Detail>[].obs;
  static List<Datum> getFundTransactionList = <Datum>[].obs;
  static List<CustomProcessed> getCustomFundTransactionList = [];

  @override
  void onInit() {
    // getIpoRecentListing();
    // getPayoutRequest();
    super.onInit();
  }

  Future<void> getPayoutRequest(
      {String fromdate, String todate, String token, int payType}) async {
    try {
      isLoading(true);
      var stringResponse = payType == 3
          ? await CommonFunction.getPayoutDetails({
              "From_Date": fromdate, //yyyy-mm-dd
              "To_Date": todate, //yyyy-mm-dd
              "token": token,
              "payType": payType.toString()
            })
          : await CommonFunction.getPaymentStauts({
              "from": fromdate, //yyyy-mm-dd
              "to": todate, //yyyy-mm-dd
              "token": token,
              "payType": payType.toString()
            });
      var jsonResponse = jsonDecode(stringResponse);

      Dataconstants.payOutId =
          jsonResponse["data"][0]["detail"][0]["PayOutId"].toString();

      var res = FundTransactionModel.fromJson(jsonResponse);
      // if(res.status){
      //   isLoading(false);
      //   getFundTransactionList.clear();
      //   getFundTransactionListItems.clear();
      //   List<Detail> newDetailList = [];
      //   List<Datum> processedList = [];
      //   List<CustomProcessed> processedItemList = [];
      //
      //   Iterable<Datum> processes = res.data.toList().where((element) => element.status=="Processed");
      //   Iterable<Datum> others = res.data.toList().where((element) => element.status!="Processed");
      //
      //   for(int i=0;i<res.data.length;i++)
      //   {
      //
      //     getFundTransactionList.add(res.data[i]);
      //      int totalProcessedAmount = 0;
      //     for(int j=0;j<res.data[i].detail.length;j++)
      //     {
      //       if(res.data[i].status=="Processed"){
      //         totalProcessedAmount += int.parse(res.data[i].detail[j].amount);
      //       }else{
      //         totalProcessedAmount = int.parse(res.data[i].detail[j].amount);
      //       }
      //
      //       res.data[i].detail[j].bankname = res.data[i].bankName ?? "";
      //       res.data[i].detail[j].transactionDate = res.data[i].transactionDate ?? "";
      //     }
      //     if(res.data[i].status=="Processed"){
      //       processedItemList.add(CustomProcessed(res.data[i].status, res.data[i].transactionDate, totalProcessedAmount.toString(), res.data[i].bankName,res.data[i].id));
      //     }else{
      //       processedItemList.add(CustomProcessed(res.data[i].status, res.data[i].transactionDate, totalProcessedAmount.toString(), res.data[i].bankName,res.data[i].id));
      //     }
      //     getFundTransactionListItems.addAll(res.data[i].detail);
      //
      //   }
      // }
      if (res.status) {
        isLoading(false);
        getFundTransactionList.clear();
        // getFundTransactionListItems.clear();
        getCustomFundTransactionList.clear();

        for (int i = 0; i < res.data.length; i++) {
          getFundTransactionList.add(res.data[i]);
          if (res.data[i].status == "Processed") {
            getCustomFundTransactionList.add(CustomProcessed(
                res.data[i].status,
                res.data[i].transactionDate,
                res.data[i].amount ?? "0",
                res.data[i].bankName,
                res.data[i].id));
          }
          for (int j = 0; j < res.data[i].detail.length; j++) {
            if (res.data[i].detail[j].status != "Processed") {
              getCustomFundTransactionList.add(CustomProcessed(
                  res.data[i].detail[j].status,
                  res.data[i].transactionDate,
                  res.data[i].detail[j].amount,
                  res.data[i].bankName,
                  res.data[i].detail[j].payOutId));
            }
            // res.data[i].detail[j].bankname = res.data[i].bankName ?? "";
            // res.data[i].detail[j].transactionDate = res.data[i].transactionDate ?? "";
          }

          // getFundTransactionListItems.addAll(res.data[i].detail);
        }

        /*getCustomFundTransactionList.map((e) {
          Iterable<CustomProcessed> processedList =
        },);
        print('Custom Processed ${getCustomFundTransactionList.toString()}');*/
      }
    } catch (e) {
      isLoading(false);
      print(e);
    }
  }

// Future<void> getDetailResult () async{
//
//   var res1;
//   isLoading(true);
//   String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
//   String bs64 = base64.encode(rawData.codeUnits);
//   print(bs64);
//
//   res1 = await ITSClient.httpGetDpHoldings(
//       "https://mobilepms.jmfonline.in/TrPositionsCMDetail.svc/TrPositionsCMDetailGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}",
//       bs64
//   );
//
//   //pnlVariable = await ITSClient.httpGet('https://cmdatafeed.jmfonline.in/api/ProftandLoss/6/s');
//   print("RecentListing : ${res1.runtimeType}");
//   try {
//     print("Hello");
//
//     detail.value = detailFromJson(res1);
//     getDetailResultListItems.clear();
//
//     for (var i = 0; i < detail.value.trPositionsCmDetailGetDataResult.length; i++) {
//       getDetailResultListItems.add(detail.value.trPositionsCmDetailGetDataResult[i]);
//     }
//
//     // print("List items: $getRecentListingDetailListItems");
//
//   } catch (e, s) {
//     print(e);
//   } finally {
//     isLoading(false);
//   }
//   return;
//
// }
}
