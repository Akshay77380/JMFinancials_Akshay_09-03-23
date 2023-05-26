import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/Utils.dart';

class bottomSheets extends StatefulWidget {
  @override
  State<bottomSheets> createState() => _bottomSheetsState();
}

class _bottomSheetsState extends State<bottomSheets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "App Bar",
          style: Utils.fonts(color: Utils.blackColor, size: 16.0),
        ),
        actions: [
          InkWell(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    context: context,
                    builder: (context) {
                      return DraggableScrollableSheet(
                          expand: false,
                          minChildSize: 0.3,
                          initialChildSize: 0.5,
                          maxChildSize: 0.50,
                          builder: (context, scrollController) {
                            return DotExpand1(scrollController);
                          });
                    }).then((value) {
                  setState(() {});
                });
              },
              child: Icon(Icons.more_vert)),
          InkWell(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    context: context,
                    builder: (context) {
                      return DraggableScrollableSheet(
                          expand: false,
                          minChildSize: 0.3,
                          initialChildSize: 0.5,
                          maxChildSize: 0.50,
                          builder: (context, scrollController) {
                            return DotExpand2(scrollController);
                          });
                    }).then((value) {
                  setState(() {});
                });
              },
              child: Icon(Icons.more_vert))
        ],
      ),
    );
  }
}

Widget DotExpand1(ScrollController scrollController) {
  return Stack(children: <Widget>[
    SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Add Scrip",
                  style: Utils.fonts(color: Utils.blackColor, size: 16.0),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(
                              "NIFTY",
                              style: Utils.fonts(
                                  color: Utils.blackColor, size: 16.0),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "NFO",
                              style: Utils.fonts(
                                  color: Utils.greyColor.withOpacity(0.9),
                                  size: 16.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "15223.00",
                              style: Utils.fonts(
                                  color: Utils.blackColor, size: 16.0),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text(
                                "23 SEP",
                                style: Utils.fonts(
                                    color: Utils.greyColor.withOpacity(0.6),
                                    size: 11.0),
                              ),
                              Text(
                                "31000",
                                style: Utils.fonts(
                                    color: Utils.greyColor.withOpacity(0.6),
                                    size: 11.0),
                              ),
                              Text(
                                "CE",
                                style: Utils.fonts(
                                    color: Utils.mediumGreenColor, size: 11.0),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                "2.60 (0.26%)",
                                style: Utils.fonts(
                                    color: Utils.mediumGreenColor, size: 11.0),
                              ),
                              Container(
                                child: SvgPicture.asset(
                                  "assets/appImages/inverted_rectangle.svg",
                                  color: Utils.mediumGreenColor,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            Divider(
              thickness: 2,
            )
          ],
        ),
      ),
    ),
    Positioned(
      bottom: 0,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 34, vertical: 10),
          child: Center(
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Utils.mediumGreenColor,
                  ),
                  child: Center(
                      child: Text(
                    "BUY",
                    style: TextStyle(color: Utils.whiteColor, fontSize: 20),
                  )),
                ),
                // Spacer(flex: 1),
                SizedBox(
                  width: 30,
                ),
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Utils.brightRedColor,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 50),
                      Text(
                        "SELL",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    )
  ]);
}

Widget DotExpand2(ScrollController scrollController) {
  return Stack(children: <Widget>[
    SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [

            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
              ),
            ),

            Row(
              children: [
                Text(
                  "New Bulk Order",
                  style: Utils.fonts(color: Utils.blackColor, size: 16.0),
                ),
              ],
            ),

            SizedBox(
              height: 30,
            ),

            TextFormField(
              initialValue: 'RBI Policy',
              decoration: InputDecoration(
                labelText: 'Label text',
                border: OutlineInputBorder(),
              ),
            ),


          ],
        ),
      ),
    ),
    Positioned(
      bottom: 0,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 34, vertical: 10),
          child: Center(
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      
                      border: Border.all(color: Utils.greyColor.withOpacity(0.7))),
                  child: Center(
                      child: Text(
                    "Cancel",
                    style: TextStyle(color: Utils.greyColor.withOpacity(0.8), fontSize: 20),
                  )),
                ),
                // Spacer(flex: 1),
                SizedBox(
                  width: 30,
                ),
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.blue,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 50),
                      Text(
                        "Create",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    )
  ]);
}
