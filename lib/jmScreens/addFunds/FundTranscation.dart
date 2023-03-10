import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'CombinedLedger.dart';
import 'PayDetails.dart';

class FundTransactions extends StatefulWidget {
  const FundTransactions({Key key}) : super(key: key);

  @override
  State<FundTransactions> createState() => _FundTransactionsState();
}

class _FundTransactionsState extends State<FundTransactions>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getpaymentstatus();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Funds Transactions",
          style: Utils.fonts(color: Utils.greyColor, size: 18.0),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
              const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
              child: TabBar(
                isScrollable: true,
                labelStyle:
                Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
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
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: payIn(),
        ),
      ),
    );
  }

  payIn() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      "2,56,412.20",
                      style: Utils.fonts(
                        size: 16.0,
                      ),
                    ),
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
                "View Pay In Ledger for",
                style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400),
              ),
              Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CombinedLedger()));
                  },
                  child: SvgPicture.asset("assets/appImages/download.svg"))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Utils.dullWhiteColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    "Last 10 Days ",
                    style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "(1 Apr to 10 Apr)",
                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: (){

                      },
                      child: Icon(Icons.arrow_drop_down))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  isDismissible: true,
                  builder: (context) => PayDetails("Pending"));
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Funds Debited",
                                  style: Utils.fonts(
                                      size: 14.0, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "10 Mar, 9:58 AM",
                                  style: Utils.fonts(
                                      size: 12.0, color: Utils.greyColor),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "-111.85",
                                  style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: Utils.darkRedColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "HDFC Bank",
                                  style: Utils.fonts(
                                      size: 12.0, color: Utils.greyColor),
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
                          "Pending",
                          style: Utils.fonts(
                              size: 12.0, color: Utils.primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => PayDetails("Success"));
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Funds Debited",
                                  style: Utils.fonts(
                                      size: 14.0, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "10 Mar, 9:58 AM",
                                  style: Utils.fonts(
                                      size: 12.0, color: Utils.greyColor),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "-32,652.5",
                                  style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: Utils.darkRedColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "HDFC Bank",
                                  style: Utils.fonts(
                                      size: 12.0, color: Utils.greyColor),
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
                        color: Utils.lightGreenColor.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Success",
                          style: Utils.fonts(
                              size: 12.0, color: Utils.darkGreenColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Funds Debited",
                                style: Utils.fonts(
                                    size: 14.0, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "10 Mar, 9:58 AM",
                                style: Utils.fonts(
                                    size: 12.0, color: Utils.greyColor),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "-25,000.0",
                                style: Utils.fonts(
                                    size: 14.0,
                                    fontWeight: FontWeight.w700,
                                    color: Utils.darkRedColor),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "HDFC Bank",
                                style: Utils.fonts(
                                    size: 12.0, color: Utils.greyColor),
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
                      color: Utils.lightRedColor.withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Failed",
                        style:
                        Utils.fonts(size: 12.0, color: Utils.darkRedColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getpaymentstatus() async {
    try{
      var header = {
        "from": "2022-11-10",
        "to": "2022-11-16",
        "payType": "2",
        "token": Dataconstants.fundstoken,
      };

      var stringResponse = await CommonFunction.getPaymentStatus(header);

      var jsonResponse = jsonDecode(stringResponse);

      if(jsonResponse == null || jsonResponse == ''){
        return;
      }

    }
    catch(e) {
      //print(e);
    }
  }
}
