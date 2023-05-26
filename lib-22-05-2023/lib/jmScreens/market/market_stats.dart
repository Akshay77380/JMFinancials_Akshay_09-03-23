import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/DataConstants.dart';
import '../../util/Utils.dart';
import 'market_stats_next.dart';

class MarketStats extends StatefulWidget {
  var elem = [
    'Top Gainers',
    'Top Losers',
    'Most Active Volume',
    'Most Active Value',
    'Most Active Futures',
    'Most Active Calls',
    'Most Active Puts',
    '52 Week High',
    '52 Week Low',
    'OI Gainers',
    'OI Losers'
  ];

  @override
  State<MarketStats> createState() => _MarketStatsState();
}

class _MarketStatsState extends State<MarketStats> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < widget.elem.length; i++)
              InkWell(
                onTap: () {
                  if (i == 2) Dataconstants.mostActiveTab = 1;
                  if (i == 3) Dataconstants.mostActiveTab = 2;
                  if (i == 4) Dataconstants.mostActiveTab = 3;
                  if (i == 5) Dataconstants.mostActiveTab = 4;
                  if (i == 6) Dataconstants.mostActiveTab = 5;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketStatsNext(
                          name: widget.elem[i],
                          currentTabIndex: i == 0 ? 0 : i == 1 ? 1 : i == 2 || i == 3 || i == 4 || i == 5 || i == 6 ? 2 : i == 7 ? 3 : i == 8 ? 4  : i == 9 ? 5 : 6,
                        ),
                      ));
                },
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.elem[i],
                              style: Utils.fonts(
                                size: 16.0,
                                color: Utils.blackColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SvgPicture.asset(
                                "assets/appImages/markets/arrow_right_circle.svg")
                          ],
                        ),
                      ),
                    ),


                    Divider(
                      thickness: 2,
                    )

                  ],
                ),
              ),
          ],
        ));
  }
}
