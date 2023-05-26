import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:markets/controllers/fundtransactioncontroller.dart';
import 'package:markets/jmScreens/addFunds/PayInScreen.dart';
import 'package:markets/jmScreens/profile/LimitScreen.dart';
import 'package:markets/model/jmModel/fundtransactionmodel.dart';
import 'package:markets/util/CommonFunctions.dart';
import 'package:markets/widget/custom_tab_bar.dart';
import '../../controllers/PayInController.dart';
import '../../controllers/limitController.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'CombinedLedger.dart';
import 'PayDetails.dart';

class FundTransactions extends StatefulWidget {
  var index;

  FundTransactions({@required this.index, Key key}) : super(key: key);

  // FundTransactions(this.index);

  @override
  State<FundTransactions> createState() => _FundTransactionsState();
}

class _FundTransactionsState extends State<FundTransactions> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  ScrollController controller;

  Map<String, String> lastDates = Map();

  // String _productType;
  // Map<String, String> _productItems;

  String amount = "";

  @override
  void initState() {
    // print("widget.index: ${widget.index}");
    super.initState();
    CommonFunction.getpaymentstatus();
    CommonFunction.getPaymentAccessTokenFund();

    try{
      CommonFunction.getLastDates(1);
    }catch(e){

    }

    controller = ScrollController();
    // getpayoutdetails();


    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          // _currentIndex = _tabController.index;
          print("Hi");
        });
      });

    try {
      _tabController.index = widget.index;
    } catch (e) {}
  }

  // getPaymentAccessToken() async {
  //   var header = {"application": "Intellect"};
  //
  //   var stringResponse = await CommonFunction.getPaymentAccessToken(header);
  //
  //   var jsonResponse = jsonDecode(stringResponse);
  //
  //   print("Get access token: ${jsonResponse}");
  //
  //   Dataconstants.fundstoken = await jsonResponse['data'];
  //
  //   // getBankdetails();
  //
  //   await Dataconstants.bankDetailsController.getBankDetails();
  //
  //   // getItems();
  //
  //   print(Dataconstants.fundstoken);
  //
  //   // getBankdetails();
  //
  //   return Dataconstants.fundstoken;
  // }
  //
  // getLastDates(){
  //   var todayDate = DateTime.now();
  //   var last30Days = new DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
  //   var last10Days = new DateTime(todayDate.year, todayDate.month, todayDate.day - 10);
  //   _productType = 'Last 10 Days';
  //   _productItems = {
  //     'Last 30 Days' : last30Days.toString(),
  //     'Last 10 Days' : last10Days.toString(),
  //   };
  //   FundTransactionControlller.getFundTransactionListItems.clear();
  //   Dataconstants.fundTransactionController.getPayoutRequest(fromdate: last10Days.toString().split(" ")[0],todate: DateTime.now().toString().split(" ")[0],token: Dataconstants.fundstoken);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (_) => LimitScreen(),
              //   ),
              // );
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)
        ),
        title: Text(
          "Funds Transactions",
          style: Utils.fonts(color: Utils.greyColor, size: 18.0),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
              child: TabBar(
                isScrollable: true,
                labelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                unselectedLabelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                unselectedLabelColor: Colors.grey[600],
                labelColor: Utils.primaryColor,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 0,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 30.0,
                  insets: EdgeInsets.symmetric(horizontal: 2),
                  indicatorColor: Utils.primaryColor.withOpacity(0.3),
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                controller: _tabController,
                tabs: [
                  Tab(
                    child: const Text(
                      'Pay In',
                    ),
                  ),
                  Tab(
                    child: const Text(
                      'Pay Out',
                    ),
                  ),
                ],
                onTap: (value) {
                  // print("value : ${value}");
                  // return value;
                  if(value == 0) {
                    CommonFunction.getLastDates(0);
                  }else{
                    CommonFunction.getLastDates(1);
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        physics: CustomTabBarScrollPhysics(),
        controller: _tabController,
          // (changed here)
        children: [payIn(), payOut()],
      ),
    );
  }

  Widget payOut() {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
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
                                  "Current Balance",
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
                        width: size.width,
                        padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Utils.dullWhiteColor),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            items: CommonFunction.productItems.keys.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
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
                                  style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                                ),
                              ],
                            ),
                            icon: Icon(
                              // Add this
                              Icons.arrow_drop_down, // Add this
                              color: Theme.of(context).textTheme.bodyText1.color, // Add this
                            ),
                            onChanged: (value) {
                              var todayDate = DateTime.now();
                              var last30Days = new DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
                              var last10Days = new DateTime(todayDate.year, todayDate.month, todayDate.day - 10);
                              List<Detail> _list = [];
                              if (value == "Last 10 Days") {
                                for (int i = 0; i < FundTransactionControlller.getFundTransactionListItems.length; i++) {
                                  print(CommonFunction.productItems.values.toString().split(",")[0].replaceAll("(", ""));
                                  final DateTime now = DateTime.now();
                                  DateFormat formatter = DateFormat('yyyy-mm-dd');
                                  var datecurrentDateEpoch = formatter.format(now);
                                  var currentDateEpoch = now.millisecondsSinceEpoch;
                                  var last10DaysEpoch = last10Days.millisecondsSinceEpoch;
                                  if (currentDateEpoch <= last10DaysEpoch) {
                                    _list.add(FundTransactionControlller.getFundTransactionListItems[i]);
                                  }
                                }
                              } else if (value == "Last 30 Days") {
                                for (int i = 0; i < FundTransactionControlller.getFundTransactionListItems.length; i++) {
                                  print(CommonFunction.productItems.values.toString().split(",")[0].replaceAll("(", ""));
                                  final DateTime now = DateTime.now();
                                  DateFormat formatter = DateFormat('yyyy-mm-dd');
                                  var datecurrentDateEpoch = formatter.format(now);
                                  // var datecurrentDateEpoch = DateFormat('yyyy-mm-dd').parse(DateTime.now().toString());
                                  var currentDateEpoch = now.millisecondsSinceEpoch;
                                  var last30DaysEpoch = last30Days.millisecondsSinceEpoch;
                                  if (last30DaysEpoch <= currentDateEpoch) {
                                    _list.add(FundTransactionControlller.getFundTransactionListItems[i]);
                                  }
                                }
                              }

                              if (_list.length > 0) {
                                FundTransactionControlller.getFundTransactionListItems.clear();
                              }
                              setState(() {
                                FundTransactionControlller.getFundTransactionListItems.addAll(_list);
                                CommonFunction.productType = value;
                              });
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
                      reverse: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return FundTransactionRow(
                          index: index,
                          data: FundTransactionControlller.getFundTransactionListItems[index],
                          datum: FundTransactionControlller.getFundTransactionList,
                        );
                        // return Text("ghjjk");
                      },
                      itemCount: FundTransactionControlller.getFundTransactionListItems.length,
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget payIn() {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
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
                                  "Current Balance",
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
                            // (changed here)
                            "View Pay In Ledger for",
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
                        width: size.width,
                        padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Utils.dullWhiteColor),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            items: CommonFunction.productItems.keys.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
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
                                  style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                                ),
                              ],
                            ),
                            icon: Icon(
                              // Add this
                              Icons.arrow_drop_down, // Add this
                              color: Theme.of(context).textTheme.bodyText1.color, // Add this
                            ),
                            onChanged: (value) {
                              var todayDate = DateTime.now();
                              var last30Days = new DateTime(todayDate.year, todayDate.month - 1, todayDate.day);
                              var last10Days = new DateTime(todayDate.year, todayDate.month, todayDate.day - 10);
                              List<Detail> _list = [];
                              if (value == "Last 10 Days") {
                                for (int i = 0; i < FundTransactionControlller.getFundTransactionListItems.length; i++) {
                                  print(CommonFunction.productItems.values.toString().split(",")[0].replaceAll("(", ""));
                                  final DateTime now = DateTime.now();
                                  DateFormat formatter = DateFormat('yyyy-mm-dd');
                                  var datecurrentDateEpoch = formatter.format(now);
                                  var currentDateEpoch = now.millisecondsSinceEpoch;
                                  var last10DaysEpoch = last10Days.millisecondsSinceEpoch;
                                  if (currentDateEpoch <= last10DaysEpoch) {
                                    _list.add(FundTransactionControlller.getFundTransactionListItems[i]);
                                  }
                                }
                              } else if (value == "Last 30 Days") {
                                for (int i = 0; i < FundTransactionControlller.getFundTransactionListItems.length; i++) {
                                  print(CommonFunction.productItems.values.toString().split(",")[0].replaceAll("(", ""));
                                  final DateTime now = DateTime.now();
                                  DateFormat formatter = DateFormat('yyyy-mm-dd');
                                  var datecurrentDateEpoch = formatter.format(now);
                                  // var datecurrentDateEpoch = DateFormat('yyyy-mm-dd').parse(DateTime.now().toString());
                                  var currentDateEpoch = now.millisecondsSinceEpoch;
                                  var last30DaysEpoch = last30Days.millisecondsSinceEpoch;
                                  if (last30DaysEpoch <= currentDateEpoch) {
                                    _list.add(FundTransactionControlller.getFundTransactionListItems[i]);
                                  }
                                }
                              }

                              if (_list.length > 0) {
                                FundTransactionControlller.getFundTransactionListItems.clear();
                              }
                              setState(() {
                                FundTransactionControlller.getFundTransactionListItems.addAll(_list);
                                CommonFunction.productType = value;
                              });
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
                      itemBuilder: (context, index) {
                        return InkWell(
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
                                                style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                PayInController.getPayInTransactionListItems[index].completedDate.toString(),
                                                style: Utils.fonts(size: 12.0, color: Utils.greyColor),
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
                                      color: PayInController.getPayInTransactionListItems[index].status == "failed" ? Utils.lightRedColor.withOpacity(0.2) : Utils.lightGreenColor.withOpacity(0.2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        PayInController.getPayInTransactionListItems[index].status == "failed" ? "FAILED" : "SUCCESS",
                                        style: Utils.fonts(size: 12.0, color: Utils.primaryColor),
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

// Widget payIn({
//   int index,
//   Datum data
// }) {
//   var size = MediaQuery.of(context).size;
//   List<String> _productItems = ['data1', 'data2', 'data3'];
//   String _productType = 'Last 10 Days (1 Apr to 10 Apr)';
//   var theme = Theme.of(context);
//   return Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 16,
//         ),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Utils.primaryColor.withOpacity(0.1),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Center(
//               child: Column(
//                 children: [
//                   Text(
//                     "Current Balance",
//                     style: Utils.fonts(
//                       size: 12.0,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "2,56,412.20",
//                     style: Utils.fonts(
//                       size: 16.0,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 16,
//         ),
//         Row(
//           children: [
//             Text(
//               "View Pay In Ledger for",
//               style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400),
//             ),
//             Spacer(),
//             InkWell(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => CombinedLedger()));
//                 },
//                 child: SvgPicture.asset("assets/appImages/download.svg"))
//           ],
//         ),
//         SizedBox(
//           height: 15,
//         ),
//
//         Container(
//           height: 55,
//           width: size.width,
//           padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 10),
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Utils.dullWhiteColor),
//           child: DropdownButton<String>(
//               isExpanded: true,
//               items: _productItems.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(
//                     value,
//                     style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
//                   ),
//                   onTap:() {
//                     print("data");
//                   },
//                 );
//               }).toList(),
//               underline: SizedBox(),
//               hint: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _productType,
//                     style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
//                   ),
//                 ],
//               ),
//               icon: Icon(
//                 // Add this
//                 Icons.arrow_drop_down, // Add this
//                 color: Theme.of(context).textTheme.bodyText1.color, // Add this
//               ),
//               onTap: (){
//                 print("data");
//               },
//               onChanged: (val) {
//                 setState(() {
//                   _productType = val;
//                 });
//               }),
//         ),
//
//         // Container(
//         //   decoration: BoxDecoration(
//         //     borderRadius: BorderRadius.circular(10),
//         //     color: Utils.dullWhiteColor,
//         //   ),
//         //   child: Padding(
//         //     padding: const EdgeInsets.all(15.0),
//         //     child: Row(
//         //       children: [
//         //         Text(
//         //           "Last 10 Days ",
//         //           style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700),
//         //         ),
//         //         Text(
//         //           "(1 Apr to 10 Apr)",
//         //           style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
//         //         ),
//         //         Spacer(),
//         //         InkWell(
//         //           onTap: (){
//         //
//         //           },
//         //             child: Icon(Icons.arrow_drop_down))
//         //       ],
//         //     ),
//         //   ),
//         // ),
//         SizedBox(
//           height: 16,
//         ),
//         InkWell(
//           onTap: () {
//             showModalBottomSheet(
//                 isScrollControlled: true,
//                 context: context,
//                 backgroundColor: Colors.transparent,
//                 isDismissible: true,
//                 builder: (context) => PayDetails("Pending"));
//           },
//           child: Container(
//             height: 90,
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15.0),
//                   child: Container(
//                     height: 80,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Utils.dullWhiteColor.withOpacity(0.5),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10.0, vertical: 15.0),
//                       child: Row(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Funds Debited",
//                                 style: Utils.fonts(
//                                     size: 14.0, fontWeight: FontWeight.w700),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 "10 Mar, 9:58 AM",
//                                 style: Utils.fonts(
//                                     size: 12.0, color: Utils.greyColor),
//                               ),
//                             ],
//                           ),
//                           Spacer(),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 "-111.85",
//                                 style: Utils.fonts(
//                                     size: 14.0,
//                                     fontWeight: FontWeight.w700,
//                                     color: Utils.darkRedColor),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 "HDFC Bank",
//                                 style: Utils.fonts(
//                                     size: 12.0, color: Utils.greyColor),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: Utils.primaryColor.withOpacity(0.2),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Text(
//                         "Pending",
//                         style: Utils.fonts(
//                             size: 12.0, color: Utils.primaryColor),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//
//
//         // InkWell(
//         //   onTap: () {
//         //     showModalBottomSheet(
//         //         isScrollControlled: true,
//         //         context: context,
//         //         backgroundColor: Colors.transparent,
//         //         builder: (context) => PayDetails("Success"));
//         //   },
//         //   child: Container(
//         //     height: 90,
//         //     child: Stack(
//         //       children: [
//         //         Padding(
//         //           padding: const EdgeInsets.only(top: 15.0),
//         //           child: Container(
//         //             height: 80,
//         //             decoration: BoxDecoration(
//         //               borderRadius: BorderRadius.circular(10),
//         //               color: Utils.dullWhiteColor.withOpacity(0.5),
//         //             ),
//         //             child: Padding(
//         //               padding: const EdgeInsets.symmetric(
//         //                   horizontal: 10.0, vertical: 15.0),
//         //               child: Row(
//         //                 children: [
//         //                   Column(
//         //                     crossAxisAlignment: CrossAxisAlignment.start,
//         //                     children: [
//         //                       Text(
//         //                         "Funds Debited",
//         //                         style: Utils.fonts(
//         //                             size: 14.0, fontWeight: FontWeight.w700),
//         //                       ),
//         //                       SizedBox(
//         //                         height: 5,
//         //                       ),
//         //                       Text(
//         //                         "10 Mar, 9:58 AM",
//         //                         style: Utils.fonts(
//         //                             size: 12.0, color: Utils.greyColor),
//         //                       ),
//         //                     ],
//         //                   ),
//         //                   Spacer(),
//         //                   Column(
//         //                     crossAxisAlignment: CrossAxisAlignment.end,
//         //                     children: [
//         //                       Text(
//         //                         "-32,652.5",
//         //                         style: Utils.fonts(
//         //                             size: 14.0,
//         //                             fontWeight: FontWeight.w700,
//         //                             color: Utils.darkRedColor),
//         //                       ),
//         //                       SizedBox(
//         //                         height: 5,
//         //                       ),
//         //                       Text(
//         //                         "HDFC Bank",
//         //                         style: Utils.fonts(
//         //                             size: 12.0, color: Utils.greyColor),
//         //                       ),
//         //                     ],
//         //                   )
//         //                 ],
//         //               ),
//         //             ),
//         //           ),
//         //         ),
//         //         Padding(
//         //           padding: const EdgeInsets.only(left: 10.0),
//         //           child: Container(
//         //             decoration: BoxDecoration(
//         //               borderRadius: BorderRadius.circular(5),
//         //               color: Utils.lightGreenColor.withOpacity(0.2),
//         //             ),
//         //             child: Padding(
//         //               padding: const EdgeInsets.all(5.0),
//         //               child: Text(
//         //                 "Success",
//         //                 style: Utils.fonts(
//         //                     size: 12.0, color: Utils.darkGreenColor),
//         //               ),
//         //             ),
//         //           ),
//         //         ),
//         //       ],
//         //     ),
//         //   ),
//         // ),
//
//
//         // SizedBox(
//         //   height: 10,
//         // ),
//         // Container(
//         //   height: 90,
//         //   child: Stack(
//         //     children: [
//         //       Padding(
//         //         padding: const EdgeInsets.only(top: 15.0),
//         //         child: Container(
//         //           height: 80,
//         //           decoration: BoxDecoration(
//         //             borderRadius: BorderRadius.circular(10),
//         //             color: Utils.dullWhiteColor.withOpacity(0.5),
//         //           ),
//         //           child: Padding(
//         //             padding: const EdgeInsets.symmetric(
//         //                 horizontal: 10.0, vertical: 15.0),
//         //             child: Row(
//         //               children: [
//         //                 Column(
//         //                   crossAxisAlignment: CrossAxisAlignment.start,
//         //                   children: [
//         //                     Text(
//         //                       "Funds Debited",
//         //                       style: Utils.fonts(
//         //                           size: 14.0, fontWeight: FontWeight.w700),
//         //                     ),
//         //                     SizedBox(
//         //                       height: 5,
//         //                     ),
//         //                     Text(
//         //                       "10 Mar, 9:58 AM",
//         //                       style: Utils.fonts(
//         //                           size: 12.0, color: Utils.greyColor),
//         //                     ),
//         //                   ],
//         //                 ),
//         //                 Spacer(),
//         //                 Column(
//         //                   crossAxisAlignment: CrossAxisAlignment.end,
//         //                   children: [
//         //                     Text(
//         //                       "-25,000.0",
//         //                       style: Utils.fonts(
//         //                           size: 14.0,
//         //                           fontWeight: FontWeight.w700,
//         //                           color: Utils.darkRedColor),
//         //                     ),
//         //                     SizedBox(
//         //                       height: 5,
//         //                     ),
//         //                     Text(
//         //                       "HDFC Bank",
//         //                       style: Utils.fonts(
//         //                           size: 12.0, color: Utils.greyColor),
//         //                     ),
//         //                   ],
//         //                 )
//         //               ],
//         //             ),
//         //           ),
//         //         ),
//         //       ),
//         //       Padding(
//         //         padding: const EdgeInsets.only(left: 10.0),
//         //         child: Container(
//         //           decoration: BoxDecoration(
//         //             borderRadius: BorderRadius.circular(5),
//         //             color: Utils.lightRedColor.withOpacity(0.2),
//         //           ),
//         //           child: Padding(
//         //             padding: const EdgeInsets.all(5.0),
//         //             child: Text(
//         //               "Failed",
//         //               style:
//         //                   Utils.fonts(size: 12.0, color: Utils.darkRedColor),
//         //             ),
//         //           ),
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         // )
//       ],
//     ),
//   );
// }

// getpaymentstatus() async {
//   try{
//     var header = {
//       "from": "2022-11-10",
//       "to": "2022-11-16",
//       "payType": "2",
//       "token": Dataconstants.fundstoken,
//     };
//
//     var stringResponse = await CommonFunction.getPaymentStauts(header);
//
//     var jsonResponse = jsonDecode(stringResponse);
//
//     if(jsonResponse == null || jsonResponse == ''){
//       return;
//     }
//   }
//   catch(e) {
//     print(e);
//   }
// }
}

class FundTransactionRow extends StatefulWidget {
  final Detail data;
  final List<Datum> datum;
  final int index;

  FundTransactionRow({this.index, this.data, this.datum});

  @override
  State<FundTransactionRow> createState() => _FundTransactionRowState();
}

class _FundTransactionRowState extends State<FundTransactionRow> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Datum datummodel;
        for (int i = 0; i < widget.datum.length; i++) {
          if (widget.data.payOutId == widget.datum[i].id) {
            datummodel = widget.datum[i];
            break;
          }
        }

        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            isDismissible: true,
            builder: (context) => PayDetails(
                status: datummodel.status,
                details: FundTransactionControlller.getFundTransactionListItems[widget.index],
                fundTransactionModel: datummodel
            )
        ).then((value) => setState(() {
          Dataconstants.payInModifyButton = true;
        }));
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
                            "Fund Withdrawal",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w700,
                                color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.data.transactionDate.toString(),
                            style: Utils.fonts(
                                size: 12.0,
                                color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.data.amount,
                            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.darkRedColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.data.bankname,
                            style: Utils.fonts(size: 12.0,color: ThemeConstants.themeMode.value == ThemeMode.light ? Utils.blackColor : Utils.whiteColor ),
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
                  color: Utils.primaryColor.withOpacity(0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    widget.data.status,
                    style: Utils.fonts(size: 12.0, color: Utils.primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
