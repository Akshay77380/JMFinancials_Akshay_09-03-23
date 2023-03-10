import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/Utils.dart';

class viewTransactions extends StatefulWidget {

  @override
  State<viewTransactions> createState() => _viewTransactionsState();
}

class _viewTransactionsState extends State<viewTransactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions",
      ),
        actions: <Widget>[
          SvgPicture.asset('assets/appImages/tranding.svg'),
          SizedBox(width: 10,)
        ],
    elevation: 0,
    ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 2,
              color: Colors.grey[350],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "View Transactions for TATAPOWER",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))

                      ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10),
                              child: Text(
                                "Last 10 Days (1Apr to 10 Apr)",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500, size: 16.0),

                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RotatedBox(
                                quarterTurns: 2,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: SvgPicture.asset('assets/appImages/inverted_rectangle.svg', color: Colors.black,),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            "Last 10  Transactions",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500, size: 12.0),
                          ),
                        ),
                        SizedBox(width: 200,),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset('assets/appImages/download_image.svg',),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Transaction",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500, size: 16.0),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Date", style: Utils.fonts(
                                  fontWeight: FontWeight.w500, size: 16.0),),
                            ],
                          )
                        ),
                        SizedBox(width: 60,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Buy Price",
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500, size: 16.0),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Sell Price", style: Utils.fonts(
                                fontWeight: FontWeight.w500, size: 16.0),),
                          ],
                        ),
                        SizedBox(width: 60,),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Qty",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w500, size: 16.0),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Valuation", style: Utils.fonts(
                                    fontWeight: FontWeight.w500, size: 16.0),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 3,
                      color: Colors.grey[350],
                    ),
                    Container(
                      height: 900,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: 18,
                          itemBuilder: (BuildContext context, int index){
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(child: Padding(padding: const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Utils.brightRedColor,
                                              ),
                                              child: Text('SELL', style: Utils.fonts(size: 14.0, color: Utils.whiteColor, fontWeight: FontWeight.w700)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("10 Mar, 22", style: Utils.fonts(
                                                fontWeight: FontWeight.w500, size: 16.0, color: Colors.grey),),
                                          ],
                                        )
                                    ),),
                                    SizedBox(width: 60,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("150",
                                          style: Utils.fonts(
                                              fontWeight: FontWeight.w500, size: 16.0),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("-", style: Utils.fonts(
                                            fontWeight: FontWeight.w500, size: 16.0),),
                                      ],
                                    ),
                                    SizedBox(width: 100,),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("1500",
                                              style: Utils.fonts(
                                                  fontWeight: FontWeight.w500, size: 16.0),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("37,899.50", style: Utils.fonts(
                                                fontWeight: FontWeight.w500, size: 16.0, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 3,
                                  color: Colors.grey[350],
                                ),

                              ],
                            );
                          }),
                    )
                  ],
                ),
            )
          ],
        ),
      ),
    );
  }
}
