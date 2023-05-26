import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:markets/screens/intellectChart/Charting/flutter_k_chart.dart';
import '../../util/Utils.dart';

class EventsDividend2 extends StatefulWidget
{
  List<dynamic> matchingDividendList;
  EventsDividend2(this.matchingDividendList, {Key key}) : super(key: key);
  @override
  State<EventsDividend2> createState() => _EventsDividendState2();
}

class _EventsDividendState2 extends State<EventsDividend2> {
  @override
  Widget build(BuildContext context) {
    if (widget.matchingDividendList == null || widget.matchingDividendList.isEmpty) {
      return const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      );
    }
    return Column(children: [
      for (var i = 0; i < widget.matchingDividendList.length; i++)
        Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.matchingDividendList[i]['symbol']}',
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
                Text("${widget.matchingDividendList[i]['divamt']} / share",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ex Date",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    // Text("",
                    //     style: Utils.fonts(
                    //         fontWeight: FontWeight.w500,
                    //         size: 14.0,
                    //         color: Colors.black)),
                    Text(
                      DateFormat('yyyy-MM-dd').format(widget.matchingDividendList[i]['divDate']),
                      style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black,
                      ),
                    )

                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Record Date",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    // Text("12 Mar, 22",
                    //     style: Utils.fonts(
                    //         fontWeight: FontWeight.w500,
                    //         size: 14.0,
                    //         color: Colors.black)),
                    Text(
                      DateFormat('yyyy-MM-dd').format(widget.matchingDividendList[i]['TradeDate']),
                      style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Div Yield",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.grey)),
                    Text("-",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Utils.darkGreenColor)),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[350],
          ),
        ]),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              height:  MediaQuery.of(context).size.width * 0.060,
              width: MediaQuery.of(context).size.width * 0.060,
              child: Image.asset("assets/appImages/markets/bellSmall.svg",),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "This is all we have for you today",
              style: Utils.fonts(color: Utils.greyColor),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 10,
      ),
    ]);
  }
}
