import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../controllers/stock_sip/get_sip_listController.dart';
import '../../model/stock_sip_model/stock_sip_model/get_sip_list.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/DateUtil.dart';
import '../../util/DateUtilBigul.dart';
import 'equity_sip_order_details.dart';

class ActiveSipOrderReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(body: Obx(() {
      return GetSipListController.isLoading.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GetSipListController.ActiveSipListData.isEmpty
              ? Center(
                  child: Text(
                    'There\'s nothing here for now',
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return Dataconstants.getSipListController.fetchGetSipListData();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 15,),
                        //   child: Column(
                        //       children:[
                        //         // SizedBox(
                        //         //   height: 10,
                        //         // ),
                        //         // Container(
                        //         //   decoration: BoxDecoration(
                        //         //     borderRadius: BorderRadius.circular(8),
                        //         //     color: Utils.greyColor.withOpacity(0.1),
                        //         //   ),
                        //         //   height: 48,
                        //         //   padding: const EdgeInsets.symmetric(horizontal: 10),
                        //         //   child: Row(
                        //         //     children: [
                        //         //       Expanded(
                        //         //         child: TextField(
                        //         //           onChanged: (value) {},
                        //         //           decoration: InputDecoration(
                        //         //             hintText: 'Search Scrip',
                        //         //             border: InputBorder.none,
                        //         //             prefixIcon: Padding(
                        //         //               padding: const EdgeInsets.only(bottom: 5),
                        //         //               child: SvgPicture.asset(
                        //         //                 'assets/appImages/searchSmall.svg',
                        //         //                 fit: BoxFit.scaleDown,
                        //         //                 alignment: Alignment.center,
                        //         //               ),
                        //         //             ),
                        //         //             suffixIcon: SvgPicture.asset(
                        //         //               'assets/appImages/voiceSearchGrey.svg',
                        //         //             ),
                        //         //             labelStyle: TextStyle( fontSize: 14,fontWeight: FontWeight.w600),
                        //         //             hintStyle: TextStyle( fontSize: 14,fontWeight: FontWeight.w600,color: Colors.grey),
                        //         //             focusedBorder: InputBorder.none,
                        //         //             enabledBorder: InputBorder.none,
                        //         //             errorBorder: InputBorder.none,
                        //         //             disabledBorder: InputBorder.none,
                        //         //           ),
                        //         //         ),
                        //         //       ),
                        //         //     ],
                        //         //   ),
                        //         // ),
                        //         const SizedBox(
                        //           height: 15,
                        //         ),
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(
                        //                     'CURRENT',
                        //                     style: TextStyle( fontSize: 12,fontWeight: FontWeight.w500)
                        //                 ),
                        //                 Text('6,50,325.5',
                        //                     style: TextStyle( fontSize: 14,fontWeight: FontWeight.w600)
                        //                 )
                        //               ],
                        //             ),
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.end,
                        //               children: [
                        //                 Text('OVERALL P/L',
                        //                     style: TextStyle( fontSize: 12,fontWeight: FontWeight.w500)),
                        //                 Text('50,325.5',
                        //                     style: TextStyle( fontSize: 14,fontWeight: FontWeight.w600,color: ThemeConstants.buyColor))
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //         Divider(),
                        //         const SizedBox(
                        //           height: 15,
                        //         ),
                        //
                        //       ]
                        //   ),
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: GetSipListController.ActiveSipListData.length,
                            itemBuilder: (context, index) => ActiveSipRow(theme: theme, activeSessionList: GetSipListController.ActiveSipListData[index])),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                );
    }));
  }
}

class ActiveSipRow extends StatelessWidget {
  final ThemeData theme;
  final GetSipList activeSessionList;

  ActiveSipRow({this.theme, this.activeSessionList});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            // backgroundColor: Colors.transparent,
            builder: (context) => EquitySipOrderDetails(true, activeSessionList.instId, activeSessionList));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  activeSessionList.symbol.toString(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  activeSessionList.exch.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(3)),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text(
                    double.parse(activeSessionList.buyExchTradedRate.toString()) > 0.0
                        ? "${(double.parse(activeSessionList.model.close.toString()) - double.parse(activeSessionList.buyExchTradedRate.toString())) / double.parse(activeSessionList.buyExchTradedRate.toString())}%"
                        : "0%",
                    // '+12.5%',

                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIP Date',
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateUtilBigul.getDateStockEvent(activeSessionList.startDate.toString().split("T")[0].toString().split(" ")[0].toString()).toString(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SIPs Done',
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateUtilBigul.getDateStockEvent(activeSessionList.expiryDate.toString().split("T")[0].toString().split(" ")[0].toString()).toString(),
                      // '25 Months',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'SIP Qty',
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      activeSessionList.qty.toString(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
