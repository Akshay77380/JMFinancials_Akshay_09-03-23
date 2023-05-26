import 'package:flutter/material.dart';

import '../../util/Utils.dart';

class ExchMessage extends StatefulWidget {
  var _currentIndex = 0;

  @override
  State<ExchMessage> createState() => _ExchMessageState();
}

class _ExchMessageState extends State<ExchMessage> {

  var exchMessages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              exchMessages = 1;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                  top: exchMessages == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: exchMessages == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: exchMessages == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                  left: exchMessages == 1
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                )),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("NSE",
                  style: Utils.fonts(
                      fontWeight: FontWeight.w500,
                      size: 14.0,
                      color: exchMessages == 1
                          ? Utils.primaryColor
                          : Utils.greyColor)),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              exchMessages = 2;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                  top: exchMessages == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  bottom: exchMessages == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  right: exchMessages == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide(color: Utils.greyColor),
                  left: exchMessages == 2
                      ? BorderSide(color: Utils.primaryColor)
                      : BorderSide.none,
                )),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("BSE",
                  style: Utils.fonts(
                      fontWeight: FontWeight.w500,
                      size: 14.0,
                      color: exchMessages == 2
                          ? Utils.primaryColor
                          : Utils.greyColor)),
            ),
          ),
        ),
      ],
    ),
        for (var i = 0; i < 20; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text("Closing price calculation is finished.",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size: 14.0,
                              color: Utils.blackColor.withOpacity(0.7))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("09 Mar, 2022 03:05:11",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w700,
                            size: 14.0,
                            color: Utils.greyColor.withOpacity(0.6))),
                  ],
                ),
                Divider(thickness: 2,)
              ],
            ),
          )
      ],
    );
  }
}
