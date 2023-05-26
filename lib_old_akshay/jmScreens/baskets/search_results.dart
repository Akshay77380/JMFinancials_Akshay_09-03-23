import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/Utils.dart';

class searchResult extends StatefulWidget {

  @override
  State<searchResult> createState() => _searchResultState();
}

class _searchResultState extends State<searchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Container(
            height: 50,
            width: 390,
            decoration: BoxDecoration(
                color: Utils.containerColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.abc),
                  border: InputBorder.none
              ),
            )

        ),
        actions: [
            Container(
                height: 30,
                child: Center(
                    child: Text(
                      "Cancel",
                      style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                    ))),
          SizedBox(width: 10,)
          ],

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10
            ),
            Divider(
              thickness: 2,
              color: Utils.greyColor.withOpacity(0.2),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "Search Results",
                 style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: 10
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 900,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index){
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height: 23,width: 23,
                                  child: Icon(Icons.abc),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Utils.greyColor.withOpacity(0.2)
                                  )
                              ),
                              Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("NIFTY" , style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("NFO" ,  style: Utils.fonts(fontWeight: FontWeight.w500, size: 11.0),)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text("27 FEB" , style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("FUT" ,  style: Utils.fonts(fontWeight: FontWeight.w500, size: 11.0, color: Colors.blue.withOpacity(0.2)),)
                                        ],
                                      )
                                    ],
                                  )
                              ),
                              SizedBox(
                                width: 130,
                              ),
                              Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Text("15,342.54" ,  style: Utils.fonts(fontWeight: FontWeight.w500, size: 11.0),),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text("-3.545 (-2.43%)" , style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),),
                                          SizedBox(height: 10,),
                                          Container(child: SvgPicture.asset('assets/appImages/basket/inverted_rectangle.svg'),)
                                        ],
                                      )
                                    ],
                                  )
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Utils.greyColor,
                          )
                        ],
                      );
                    }),
              )
            )
          ],
        ),
      ),
    );
  }
}

