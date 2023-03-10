import 'package:flutter/material.dart';

import '../../util/Utils.dart';
import 'dart:math' as math;

class CombinedLedger extends StatefulWidget {
  const CombinedLedger({Key key}) : super(key: key);

  @override
  State<CombinedLedger> createState() => _CombinedLedgerState();
}

class _CombinedLedgerState extends State<CombinedLedger> {
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
          "Combined Ledger",
          style: Utils.fonts(color: Utils.greyColor, size: 18.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "View Combined Ledger for",
                style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
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
                        style: Utils.fonts(
                            size: 16.0, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "(1 Apr to 10 Apr)",
                        style: Utils.fonts(
                            size: 14.0, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "All Exchanges",
                    style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Debit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "13,250.29",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.mediumRedColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Credit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "13,250.29",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.mediumGreenColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Net Balance",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "0.0",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "NSE",
                        style: Utils.fonts(
                            size: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Transform.rotate(
                        angle: 270 * math.pi / 180,
                        child: Icon(
                          Icons.arrow_drop_down_circle_rounded,
                          color: Utils.greyColor.withOpacity(0.5),
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Debit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "12,674.29",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.mediumRedColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Credit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "12,674.29",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.mediumGreenColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Net Balance",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "0.0",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "BSE",
                        style: Utils.fonts(
                            size: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Transform.rotate(
                        angle: 270 * math.pi / 180,
                        child: Icon(
                          Icons.arrow_drop_down_circle_rounded,
                          color: Utils.greyColor.withOpacity(0.5),
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Debit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "531.00",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.mediumRedColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Credit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "531.00",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.mediumGreenColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Net Balance",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "0.0",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "F&O",
                        style: Utils.fonts(
                            size: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Transform.rotate(
                        angle: 270 * math.pi / 180,
                        child: Icon(
                          Icons.arrow_drop_down_circle_rounded,
                          color: Utils.greyColor.withOpacity(0.5),
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Debit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "-",
                            style: Utils.fonts(
                                size: 14.0, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Credit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "-",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Net Balance",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "-",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Currency",
                        style: Utils.fonts(
                            size: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Transform.rotate(
                        angle: 270 * math.pi / 180,
                        child: Icon(
                          Icons.arrow_drop_down_circle_rounded,
                          color: Utils.greyColor.withOpacity(0.5),
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Debit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "-",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Credit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "-",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Net Balance",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "-",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Commodity",
                        style: Utils.fonts(
                            size: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Transform.rotate(
                        angle: 270 * math.pi / 180,
                        child: Icon(
                          Icons.arrow_drop_down_circle_rounded,
                          color: Utils.greyColor.withOpacity(0.5),
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Debit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "-",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Credit",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "-",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Net Balance",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                          Text(
                            "-",
                            style: Utils.fonts(
                              size: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
