import 'package:flutter/material.dart';

import '../../util/Utils.dart';

class BoardMeet extends StatefulWidget {
  @override
  State<BoardMeet> createState() => _BoardMeetState();
}

class _BoardMeetState extends State<BoardMeet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 7; i++)
          Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("TATAMOTORS",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w700,
                          size: 14.0,
                          color: Utils.blackColor.withOpacity(0.8))),
                  Text("12 Jan, 2022",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w700,
                          size: 14.0,
                          color: Utils.blackColor.withOpacity(0.8))),
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
                      Text("Agenda",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.greyColor)),
                      Text("Quaterly Results",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.greyColor)),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[350],
            ),
          ]),  SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.060,
                width: MediaQuery.of(context).size.width * 0.060,
                child: Image.asset(
                  "assets/appImages/markets/bellSmall.svg",
                ),
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
      ],
    );
  }
}