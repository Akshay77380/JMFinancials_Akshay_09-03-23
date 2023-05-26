import 'dart:convert';

import 'package:get/get.dart';
import 'package:markets/util/CommonFunctions.dart';
import '../Connection/ISecITS/ITSClient.dart';
import '../jmScreens/ScriptInfo/bar_chart.dart';
import '../model/PayInmodel.dart';
import '../util/Dataconstants.dart';

class PayInController extends GetxController{
  static var isLoading = true.obs;
  static var fundTransactionModel = PayInModel().obs;
  static List<Datum> getPayInTransactionListItems = <Datum>[].obs;

  @override
  void onInit() {
    // getIpoRecentListing();
    // getPayoutRequest();
    super.onInit();
  }

  Future<void> getPayInRequest({String fromdate,String todate,String token, int payType}) async {
    try{
      // var todayDate = DateTime.now();
      // var last30Days = new DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
      // var last10Days = new DateTime(todayDate.year, todayDate.month, todayDate.day - 10);
      isLoading(true);
      var stringResponse =  await CommonFunction.getPaymentStauts({
        "from": DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day).toString().split(" ")[0], //yyyy-mm-dd
        "to" : DateTime.now().toString().split(" ")[0], //yyyy-mm-dd
        "token" : Dataconstants.fundstoken,
        "payType" : payType.toString()});

      print("Stringres: ${stringResponse}");

      var jsonResponse = jsonDecode(stringResponse);

      var res = PayInModel.fromJson(jsonResponse);
      if(res.status){
        isLoading(false);
        getPayInTransactionListItems.clear();

        for(int i=0;i<res.data.length;i++){
          getPayInTransactionListItems.add(res.data[i]);
        }
        print('Data in getPayTransaction:$getPayInTransactionListItems');
      }
    }
    catch(e) {
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