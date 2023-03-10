// import 'dart:convert';
// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../model/jmModel/todaysPosition.dart';
// import '../util/BrokerInfo.dart';
// import '../util/Dataconstants.dart';
//
// class TodaysPositionController extends GetxController {
//   static var isLoading = true.obs;
//   static var TodaysPositionList = TodaysPositions().obs;
//   static List<TodaysPositionDatum> openPositionList = <TodaysPositionDatum>[].obs;
//   static List<TodaysPositionDatum> openPositionFilteredList = <TodaysPositionDatum>[];
//   static var TodaysPositionLength = 0.obs;
//   static RxInt squareOffCount = 0.obs;
//   static RxDouble totalBuy = 0.0.obs, totalSell = 0.0.obs, totalNet = 0.0.obs;
//   RxDouble _unrealisedPl = 0.0.obs;
//
//   @override
//   void onInit() {
//     // fetchTodaysPosition();
//     super.onInit();
//   }
//
//   // void fetchOrderBook() async {
//   //   try {
//   //     isLoading(true);
//   //     var products = await HttpService.fetchOrderBook();
//   //     if (products != null) {
//   //       OrderBookList.value = products;
//   //     }
//   //   } finally {
//   //     isLoading(false);
//   //   }
//   // }
//
//   Future<void> fetchTodaysPosition() async {
//     var requestJson = {};
//     // isLoading(true);
//     http.Response response = await Dataconstants.itsClient.httpPostWithHeader(
//         BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "GetDayPositions",
//         requestJson,
//         Dataconstants.loginData.data.jwtToken);
//     var responses = response.body.toString();
//     TodaysPositionList.value = TodaysPositionList();
//     TodaysPositionLength.value = 0;
//     try {
//       TodaysPositionList.value = todaysPositionsFromJson(responses);
//       openPositionList = [];
//       openPositionFilteredList = [];
//       totalBuy.value = 0.0;
//       TodaysPositionLength.value = TodaysPositionList.value.data.length;
//       squareOffCount.value = TodaysPositionLength.value;
//       //log("todays position log ${responses}");
//       for(var i = 0; i < TodaysPositionList.value.data.length; i++) {
//         openPositionList.add(TodaysPositionList.value.data[i]);
//         openPositionFilteredList.add(TodaysPositionList.value.data[i]);
//         // totalBuy += double.tryParse(TodaysPositionList.value.data[i].totalbuyvalue.replaceAll(",", ''));
//         // totalSell += double.tryParse(TodaysPositionList.value.data[i].totalsellvalue.replaceAll(",", ''));
//         // totalNet += double.tryParse(TodaysPositionList.value.data[i].netvalue.replaceAll(",", ''));
//       }
//       // openPositionList.addAll(TodaysPositionList.value.data);
//       // openPositionFilteredList.addAll(TodaysPositionList.value.data);
//       isLoading(false);
//     } catch (e) {
//       var jsons = json.decode(responses);
//       // CommonFunction.showBasicToast(jsons["message"].toString());
//       TodaysPositionList.value = TodaysPositionList();
//       // TodaysPositionLength.value = 0;
//       isLoading(false);
//     } finally {
//       isLoading(false);
//     }
//     return;
//
//     // Navigator.of(context).pushReplacement(
//     //   MaterialPageRoute(
//     //     builder: (_) => MainScreen(),
//     //   ),
//     // );
//   }
//
// }
