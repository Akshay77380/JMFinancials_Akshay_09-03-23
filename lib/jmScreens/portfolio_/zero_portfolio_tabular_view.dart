import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/Utils.dart';

class zeroPortfoliTabular extends StatefulWidget {

  @override
  State<zeroPortfoliTabular> createState() => _zeroPortfoliTabularState();
}

class _zeroPortfoliTabularState extends State<zeroPortfoliTabular> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.0),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff7ca6fa).withOpacity(0.2),
                    Color(0xff219305ff).withOpacity(0.2)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,children: [
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
                            ],)
                          ],
                        ),
                        SvgPicture.asset('assets/appImages/portfolio/zero_wallet.svg')
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
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
                                color: Colors.grey),
                          ),
                          Text(
                            "67,78,340.8",
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
                                color: Colors.grey),
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
                                color: Colors.grey),
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
          SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 3,
            color: Colors.grey[350],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("Asset Class",style: Utils.fonts(
                      fontWeight: FontWeight.w500,
                      size: 11.0,
                      color: Colors.grey)),
                  SizedBox(height: 15)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Current",style: Utils.fonts(
                      fontWeight: FontWeight.w500,
                      size: 11.0,
                      color: Colors.grey)),
                  Text("Invested",style: Utils.fonts(
                      fontWeight: FontWeight.w500,
                      size: 11.0,
                      color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Overall P/L",style: Utils.fonts(
                        fontWeight: FontWeight.w700,
                        size: 11.0,
                        color: Colors.blue)),
                      Container(child: SvgPicture.asset('assets/appImages/inverted_blue_rectangle.svg'),)
                    ],
                  ),
                  SizedBox(height: 15)
                ],
              ),
            ],
          ),SizedBox(height: 10,),
          Divider(
            thickness: 2,
            color: Colors.grey[350],
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: 6,
                itemBuilder: (BuildContext context, int index ) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset('assets/appImages/portfolio/zero_equity.svg'),),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text("Equity", style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size: 14.0,
                              color: Colors.grey)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Text("67,21,434.54", style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size: 14.0,
                              color: Colors.grey)),
                          SizedBox(
                            height: 10,
                          ),
                          Text("32,43,876.6", style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.greyColor))
                        ],),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Text("67,21,434.54", style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.darkGreenColor)),
                            SizedBox(
                              height: 10,
                            ),
                          Text("32.65%", style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.darkGreenColor)),

                            Divider(
                              thickness: 3,
                              color: Utils.greyColor,
                            ),

                        ],),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Utils.greyColor.withOpacity(0.5),
                  ),
                ],
              );

            }),

          ),
        ],
      ),
    );
  }
}


