import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/Utils.dart';
import '../../widget/slider_button.dart';
import '../baskets/basket_overview.dart';

class editBulkOrder extends StatefulWidget {

  @override
  State<editBulkOrder> createState() => _editBulkOrderState();
}

class _editBulkOrderState extends State<editBulkOrder> {

  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Edit Bulk Order" , style: Utils.fonts(color: Utils.blackColor, size: 17.0),),
        actions: [
          SvgPicture.asset("assets/appImages/tranding.svg"),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bulk Order", style: Utils.fonts(
                  fontWeight: FontWeight.w700,
                  size : 13.0,
                ),),
                SvgPicture.asset("assets/appImages/edit.svg")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Required Margin: 6,5765", style: Utils.fonts(
                  fontWeight: FontWeight.w700,
                  size : 13.0,
                ),),
                Text("2 Scrips", style: Utils.fonts(
                  fontWeight: FontWeight.w700,
                  size : 13.0,
                ),),
              ],
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Expanded(
            // height: MediaQuery.of(context).size.height- 140,
            // width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Utils.lightGreenColor,
                              ),
                              child: Center(
                                child: Text(
                                  "BUY",
                                  style: Utils.fonts(
                                      fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text("IDEA", style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              size : 16.0,
                            ),),
                            Row(
                              children: [
                                Text("1 @ 13.95", style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size : 16.0,
                                ),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SvgPicture.asset("assets/appImages/delete.svg"),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                            height: 5
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text("NSE . MIS", style: Utils.fonts(
                              fontWeight: FontWeight.w700,
                              color: Utils.greyColor.withOpacity(0.5),
                              size : 11.0,
                            ),),
                            Row(
                              children: [
                                Text("2.7", style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  color: Utils.greyColor.withOpacity(0.5),
                                  size : 11.0,
                                ),),
                                Container(
                                  width: 30,
                                )
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                        )
                      ],
                    ),
                  );
                }
             ),
          ),
        ],
      ),
    );
  }
}
