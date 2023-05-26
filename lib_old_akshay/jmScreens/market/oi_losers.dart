import 'package:flutter/material.dart';

import '../../util/Utils.dart';

class OILosers extends StatefulWidget {

  @override
  State<OILosers> createState() => _OILosersState();
}

class _OILosersState extends State<OILosers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(var i = 0; i < 5; i++)
          Row(
            children: [
              Column(
                children: [
                  Text("ONGC",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w700,
                          size: 14.0,
                          color: Colors.black)),
                  Row(
                    children: [
                      Text("29 AUG",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Colors.black)),
                      Text("FUT",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.primaryColor)),
                    ],
                  )
                ],
              )
            ],
          )
      ],
    );
  }
}
