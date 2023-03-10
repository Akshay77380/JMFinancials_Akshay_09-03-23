import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/Utils.dart';

class zeroPortfolio extends StatefulWidget {
  @override
  State<zeroPortfolio> createState() => _zeroPortfolioState();
}

class _zeroPortfolioState extends State<zeroPortfolio> {


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              color: Color(0xff7ca6fa).withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Value",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0),
                              ),
                              Text(
                                "1,233,654.4",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w900,
                                    size: 14.0),
                              )
                            ],
                          ),
                          CircleAvatar(
                            backgroundColor: Utils.greyColor,
                            child: Center(
                                child: SvgPicture.asset(
                                    'assets/appImages/portfolio/zero_wallet.svg')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invested",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.greyColor),
                            ),
                            Text(
                              "67,68,340.8",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w900, size: 14.0),
                            ),
                            Text("")
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Day's P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.greyColor),
                            ),
                            Text(
                              "23,43,545.5",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            ),
                            Text(
                              "3.17%",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Unrealised P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.greyColor),
                            ),
                            Text(
                              "43,56,657.4",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            ),
                            Text(
                              "2.71%",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            color: Utils.greyColor,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Center(
                    child: SvgPicture.asset(
                        'assets/appImages/portfolio/zero_equity.svg')),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Equity",
                  style:
                      Utils.fonts(fontWeight: FontWeight.w900, size: 14.0),
                ),
              ),
              Container(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: SvgPicture.asset(
                          'assets/appImages/right_arrow_image.svg'))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.185 ,
              width:  MediaQuery.of(context).size.width * 0.99 ,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Color(0xff7cfaf2).withOpacity(0.2)),
              child: Container(
                // color: Color(0x7ca6fa),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Total Value",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0),
                              ),
                              Text(
                                "1,233,654.4",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w900,
                                    size: 14.0),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 75,
                          // child: CircleAvatar(
                          //   child: Text(
                          //     "Image",
                          //     style: Utils.fonts(
                          //         fontWeight: FontWeight.w500, size: 14.0),
                          //   ),
                          // ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invested",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.greyColor),
                            ),
                            Text(
                              "67,68,340.8",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w900, size: 14.0),
                            ),
                            Text("")
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Day's P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.greyColor),
                            ),
                            Text(
                              "23,43,545.5",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            ),
                            Text(
                              "3.17%",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Unrealised P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.greyColor),
                            ),
                            Text(
                              "43,56,657.4",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            ),
                            Text(
                              "2.71%",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 30,
                    width: 30,
                    child: Center(
                        child: SvgPicture.asset(
                            'assets/appImages/portfolio/zero_derivative.svg'))),
              ),
              Text(
                "Derivative",
                style: Utils.fonts(fontWeight: FontWeight.w900, size: 14.0),
              ),
              Center(
                  child: SvgPicture.asset(
                      'assets/appImages/right_arrow_image.svg')),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.185 ,
              width:  MediaQuery.of(context).size.width * 0.99 ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xffffca5d).withOpacity(0.2),
              ),
              child: Container(
                color: Color(0x7ca6fa),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Total Value",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0),
                              ),
                              Text(
                                "1,233,654.4",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w900,
                                    size: 14.0),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invested",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.greyColor),
                            ),
                            Text(
                              "67,68,340.8",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w700, size: 14.0),
                            ),
                            Text("")
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Day's P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.greyColor),
                            ),
                            Text(
                              "23,43,545.5",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            ),
                            Text(
                              "3.17%",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Unrealised P/L",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.greyColor),
                            ),
                            Text(
                              "43,56,657.4",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            ),
                            Text(
                              "2.71%",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0,
                                  color: Utils.brightGreenColor),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: SvgPicture.asset(
                      'assets/appImages/portfolio/zero_commodity.svg')),
            ),
            Text(
              "Commodity",
              style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0),
            ),
            Container(
                height: 30,
                width: 30,
                child: Center(
                    child: SvgPicture.asset(
                        'assets/appImages/right_arrow_image.svg'))),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.185 ,
              width:  MediaQuery.of(context).size.width * 0.99 ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xff81fba9).withOpacity(0.2),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Total Value",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0),
                            ),
                            Text(
                              "1,233,654.4",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 14.0),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invested",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.greyColor),
                          ),
                          Text(
                            "67,68,340.8",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w700, size: 14.0),
                          ),
                          Text("")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Day's P/L",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.greyColor),
                          ),
                          Text(
                            "23,43,545.5",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.brightGreenColor),
                          ),
                          Text(
                            "3.17%",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.brightGreenColor),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unrealised P/L",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.greyColor),
                          ),
                          Text(
                            "43,56,657.4",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.brightGreenColor),
                          ),
                          Text(
                            "2.71%",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.brightGreenColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: SvgPicture.asset(
                          'assets/appImages/portfolio/zero_currency.svg'))),
            ),
            Text(
              "Currency",
              style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0),
            ),
            Center(
                child: SvgPicture.asset(
                    'assets/appImages/right_arrow_image.svg')),
          ]),
          Container(
            height: MediaQuery.of(context).size.height * 0.185 ,
            width:  MediaQuery.of(context).size.width * 0.99 ,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xffa693f6).withOpacity(0.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 13, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Value",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0),
                          ),
                          Text(
                            "1,233,654.4",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w700,
                                size: 14.0),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Invested",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.greyColor),
                        ),
                        Text(
                          "67,68,340.8",
                          style: Utils.fonts(
                            fontWeight: FontWeight.w700,
                            size: 14.0,
                          ),
                        ),
                        Text("")
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Day's P/L",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,color: Utils.greyColor ,size: 14.0),
                        ),
                        Text(
                          "23,43,545.5",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.brightGreenColor),
                        ),
                        Text(
                          "3.17%",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.brightGreenColor),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unrealised P/L",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.greyColor),
                        ),
                        Text(
                          "43,56,657.4",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.brightGreenColor),
                        ),
                        Text(
                          "2.71%",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.brightGreenColor),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: SvgPicture.asset(
                      'assets/appImages/portfolio/zero_mutual_fund.svg')),
            ),
            Text(
              "Mutual Funds",
              style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0),
            ),
            Center(
                child: SvgPicture.asset(
                    'assets/appImages/right_arrow_image.svg')),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.185 ,
              width:  MediaQuery.of(context).size.width * 0.99 ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xfff9d3b5).withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Total Value",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 14.0),
                            ),
                            Text(
                              "1,233,654.4",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 14.0),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invested",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.greyColor),
                          ),
                          Text(
                            "67,68,340.8",
                            style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size: 14.0,
                            ),
                          ),
                          Text("")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Day's P/L",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.greyColor),
                          ),
                          Text(
                            "23,43,545.5",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.brightGreenColor),
                          ),
                          Text(
                            "3.17%",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.brightGreenColor),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unrealised P/L",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.greyColor),
                          ),
                          Text(
                            "43,56,657.4",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.brightGreenColor),
                          ),
                          Text(
                            "2.71%",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.brightGreenColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
