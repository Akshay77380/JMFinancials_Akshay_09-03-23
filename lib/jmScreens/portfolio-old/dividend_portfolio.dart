import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';

class dividendPortfolio extends StatefulWidget {
  // const dividendPortfolio({Key? key}) : super(key: key);

  @override
  State<dividendPortfolio> createState() => _dividendPortfolioState();
}

class _dividendPortfolioState extends State<dividendPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            for(var i = 0; i < 10; i++)
              Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("TCS",style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Colors.black)),
                          Text("12.50 / share",style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Colors.black)),
                        ],),
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
                            crossAxisAlignment:CrossAxisAlignment.start,children: [
                            Text("Ex Date",style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Colors.grey)),
                            Text("12 Mar, 22",style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Colors.black)),
                          ],),
                          Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                            Text("Record Date",style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Colors.grey)),
                            Text("12 Mar, 22",style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Colors.black)),
                          ],),
                          Column(crossAxisAlignment:CrossAxisAlignment.end,children: [
                            Text("Div Yield",style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Colors.grey)),
                            Text("5.90%",style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: Utils.darkGreenColor)),
                          ],),
                        ],
                      ),
                    ),


                    Divider(
                      thickness: 2,
                      color: Colors.grey[350],
                    ),


                  ]
              ),
            SizedBox(
              height: 20,
            ),
            CommonFunction.message('That\'s all we have for you today'),
            SizedBox(
              height: 120,
            ),
            Row(
              children: [
                Spacer(),
                Expanded(
                  child: Text("What is Dividend?",style: Utils.fonts(
                      fontWeight: FontWeight.w500,
                      size: 14.0,
                      color: Colors.blue)),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}
