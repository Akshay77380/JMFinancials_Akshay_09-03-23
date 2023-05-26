import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/Utils.dart';

class emptyPortfolio extends StatefulWidget {

  @override
  State<emptyPortfolio> createState() => _emptyPortfolioState();
}

class _emptyPortfolioState extends State<emptyPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions",
        ),
        actions: <Widget>[
          SvgPicture.asset('assets/appImages/tranding.svg'),
          SizedBox(width:10)
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 350,
                  width: double.infinity,
                  child: Center(child: SvgPicture.asset('assets/appImages/portfolio/empty_portfolio.svg'),),
                ),

                Container(
                  child: Text(
                    "You have not bought any script in portfolio",
                      style: Utils.fonts(
                  fontWeight: FontWeight.w500,
                      size: 14.0,
                      color: Colors.grey)
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          child: Text("Top Research Picks",
                        style: Utils.fonts(
                  fontWeight: FontWeight.w700,
                        size: 16.0)
                          ),
                        ),
                      ),
                      Container(
                        child: SvgPicture.asset('assets/appImages/arrow_right_circle.svg'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Utils.primaryColor)),
                            child: Center(
                                child: Text(
                                  'Technical',
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 11.0,
                                      color: Utils.primaryColor),
                                )),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1, color: Utils.lightGreyColor),
                                  bottom: BorderSide(
                                      width: 1, color: Utils.lightGreyColor),
                                  right: BorderSide(
                                      width: 1, color: Utils.lightGreyColor),
                                )),
                            child: Center(
                                child: Text(
                                  'Research',
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 11.0,
                                      color: Utils.lightGreyColor),
                                )),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1, color: Utils.lightGreyColor),
                                  bottom: BorderSide(
                                      width: 1, color: Utils.lightGreyColor),
                                  right: BorderSide(
                                      width: 1, color: Utils.lightGreyColor),
                                )),
                            child: Center(
                                child: Text(
                                  'Derivatives',
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 11.0,
                                      color: Utils.lightGreyColor),
                                )),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1, color: Utils.lightGreyColor),
                                  bottom: BorderSide(
                                      width: 1, color: Utils.lightGreyColor),
                                  right: BorderSide(
                                      width: 1, color: Utils.lightGreyColor),
                                )),
                            child: Center(
                                child: Text(
                                  'Commodity and Currency',
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500,
                                      size: 11.0,
                                      color: Utils.lightGreyColor),
                                )),
                          ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    width: 1, color: Utils.lightGreyColor),
                                bottom: BorderSide(
                                    width: 1, color: Utils.lightGreyColor),
                                right: BorderSide(
                                    width: 1, color: Utils.lightGreyColor),
                              )),
                          child: Center(
                              child: Text(
                                'Commodity and Currency',
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 11.0,
                                    color: Utils.lightGreyColor),
                              )),
                        ),
                        ],

                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13.0),
                  child: Container(height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (BuildContext Context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal:6.0),
                            child: Container(
                              height: 100,
                              width: 190,
                              decoration: BoxDecoration(
                                border: Border.all(color: Utils.greyColor.withOpacity(0.2)),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("TATAMOTORS" ,style: Utils.fonts(
                                                  fontWeight: FontWeight.w500,
                                                  size: 12.0)),
                                            Text("BUY" ,style: Utils.fonts(
                                                fontWeight: FontWeight.w500,
                                                size: 10.0, color: Utils.mediumGreenColor))
                                          ],
                                        ),
                                        // SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("Exp. Return" ,style: Utils.fonts(
                                                fontWeight: FontWeight.w500,
                                                size: 10.0)),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0),),
                                                color: Utils.lightGreenColor.withOpacity(0.3)
                                              ),
                                              child: Text("11.1%" ,style: Utils.fonts(
                                                  fontWeight: FontWeight.w500,
                                                  size: 14.0, color: Utils.darkGreenColor)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        // Graph Content Here
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Divider(
                  thickness: 3,
                  color: Colors.grey[350],
                ),

                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Recently Visited",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 16.0)
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13.0),
                  child: Container(height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (BuildContext Context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal:6.0),
                            child: Container(
                              height: 121,
                              width: 147,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Utils.greyColor.withOpacity(0.2)),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("GOLD",style: Utils.fonts(
                                                fontWeight: FontWeight.w500,
                                                size: 10.0,
                                                color: Colors.grey)),
                                            Row(
                                              children: [
                                                Container(
                                                  child: SvgPicture.asset('assets/appImages/inverted_triangle.svg', color: Utils.mediumGreenColor,),
                                                ),
                                                Container(
                                                  child: Text("7.71%",style: Utils.fonts(
                                                      fontWeight: FontWeight.w500,
                                                      size: 10.0,
                                                      color: Utils.mediumGreenColor) ),
                                                )
                                              ],

                                            ),

                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text("22 Mar FUT", style: Utils.fonts(
                                                  fontWeight: FontWeight.w500,
                                                  size: 10.0,
                                                  color: Colors.grey)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(

                                        //Graph Content Here

                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],

        ),
      ),
    );
  }
}
