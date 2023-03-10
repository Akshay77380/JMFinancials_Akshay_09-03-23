import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/Utils.dart';

class EventsDividend extends StatefulWidget {

  @override
  State<EventsDividend> createState() => _EventsDividendState();
}

class _EventsDividendState extends State<EventsDividend> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (var i = 0; i < 7; i++)
        Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TCS",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
                Text("12.50 / share",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w500,
                        size: 14.0,
                        color: Colors.black)),
              ],
            ),
          ),
          SizedBox(
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
                    Text("12 Mar, 22",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.black)),
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
                    Text("12 Mar, 22",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 14.0,
                            color: Colors.black)),
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
                    Text("5.90%",
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
      SizedBox(
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
      SizedBox(
        height: 10,
      ),
    ]);
  }
}
